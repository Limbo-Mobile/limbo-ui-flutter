import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:limbo_ui_flutter/limbo_ui_flutter.dart';

class _MemoryStorage implements TokenStorage {
  final Map<String, String> values = {};

  @override
  Future<String?> read(String key) async => values[key];

  @override
  Future<void> write(String key, String value) async => values[key] = value;

  @override
  Future<void> delete(String key) async => values.remove(key);
}

/// Routes requests to a handler so tests control every server answer.
class _FakeAdapter implements HttpClientAdapter {
  final ResponseBody Function(RequestOptions options) handler;
  final List<RequestOptions> requests = [];

  _FakeAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _json(int status, Map<String, dynamic> body) => ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );

void main() {
  late _MemoryStorage storage;
  late SessionStore store;
  late _FakeAdapter adapter;
  late Dio dio;
  late int expiredCalls;
  late int refreshCalls;
  late ResponseBody Function(RequestOptions) refreshAnswer;

  ResponseBody route(RequestOptions o) {
    if (o.path.endsWith('/auth/refresh')) {
      refreshCalls++;
      return refreshAnswer(o);
    }
    final auth = o.headers['Authorization'];
    if (auth == 'Bearer new-access') return _json(200, {'data': {'ok': true}});
    return _json(401, {'message': 'Unauthenticated'});
  }

  setUp(() async {
    storage = _MemoryStorage();
    store = SessionStore(storage);
    await store.save(
      accessToken: 'old-access',
      refreshToken: 'old-refresh',
      expiresInSeconds: 3600,
    );
    expiredCalls = 0;
    refreshCalls = 0;
    refreshAnswer = (_) => _json(200, {
          'data': {
            'token': 'new-access',
            'refresh_token': 'new-refresh',
            'expires_in': 3600,
          },
        });

    adapter = _FakeAdapter(route);
    final options = BaseOptions(baseUrl: 'http://test/api/v1');
    dio = Dio(options)..httpClientAdapter = adapter;
    final refresherDio = Dio(options)..httpClientAdapter = adapter;

    final interceptor = AuthInterceptor(
      session: store,
      refresher: SessionRefresher(dio: refresherDio, store: store),
      onTokenExpired: () async => expiredCalls++,
    )..attach(dio);
    dio.interceptors.add(interceptor);
  });

  test('401 triggers one refresh and the request is retried with the new token',
      () async {
    final response = await dio.get<dynamic>('/orders');

    expect(response.statusCode, 200);
    expect(refreshCalls, 1);
    expect(expiredCalls, 0);
    expect(await store.readAccessToken(), 'new-access');
    expect(await store.readRefreshToken(), 'new-refresh');
  });

  test('parallel 401s share a single refresh call (single-flight)', () async {
    final results = await Future.wait([
      dio.get<dynamic>('/orders'),
      dio.get<dynamic>('/cart'),
      dio.get<dynamic>('/home'),
    ]);

    expect(results.every((r) => r.statusCode == 200), isTrue);
    expect(refreshCalls, 1);
  });

  test('rejected refresh token ends the session exactly once per request',
      () async {
    refreshAnswer = (_) => _json(401, {
          'message': 'Sesión expirada',
          'code': 'refresh_invalid',
        });

    await expectLater(
      dio.get<dynamic>('/orders'),
      throwsA(isA<DioException>()),
    );

    expect(expiredCalls, 1);
    expect(await store.readAccessToken(), isNull);
    expect(await store.readRefreshToken(), isNull);
  });

  test('network/5xx on refresh keeps the session (no logout)', () async {
    refreshAnswer = (_) => _json(503, {'message': 'down'});

    await expectLater(
      dio.get<dynamic>('/orders'),
      throwsA(isA<DioException>()),
    );

    expect(expiredCalls, 0);
    expect(await store.readRefreshToken(), 'old-refresh');
  });

  test('a 401 from the refresh endpoint itself never loops', () async {
    refreshAnswer = (_) => _json(401, {'code': 'refresh_invalid'});

    await expectLater(
      dio.post<dynamic>(
        '/auth/refresh',
        data: {'refresh_token': 'x'},
        options: Options(headers: {'Authorization': 'Bearer old-access'}),
      ),
      throwsA(isA<DioException>()),
    );

    expect(refreshCalls, 1);
    expect(expiredCalls, 0);
  });

  test('requests without a token (login) never refresh or log out', () async {
    await storage.delete(SessionStore.accessKey);

    await expectLater(
      dio.post<dynamic>('/auth/login', data: {'email': 'a@b.c'}),
      throwsA(isA<DioException>()),
    );

    expect(refreshCalls, 0);
    expect(expiredCalls, 0);
  });

  test('logout path is skipped even when it answers 401', () async {
    await expectLater(
      dio.post<dynamic>('/auth/logout'),
      throwsA(isA<DioException>()),
    );

    expect(refreshCalls, 0);
    expect(expiredCalls, 0);
  });

  test('refreshIfExpiring only refreshes inside the threshold', () async {
    final refresher = SessionRefresher(
      dio: Dio(BaseOptions(baseUrl: 'http://test/api/v1'))
        ..httpClientAdapter = adapter,
      store: store,
    );

    expect(await refresher.refreshIfExpiring(const Duration(minutes: 5)), isNull);
    expect(refreshCalls, 0);

    await store.save(
      accessToken: 'old-access',
      refreshToken: 'old-refresh',
      expiresInSeconds: 60,
    );
    expect(
      await refresher.refreshIfExpiring(const Duration(minutes: 5)),
      RefreshOutcome.refreshed,
    );
    expect(refreshCalls, 1);
  });

  test('ApiErrorHandler exposes code and body of 403 responses', () {
    final error = DioException(
      requestOptions: RequestOptions(path: '/auth/login'),
      type: DioExceptionType.badResponse,
      response: Response(
        requestOptions: RequestOptions(path: '/auth/login'),
        statusCode: 403,
        data: {
          'message': 'Debes verificar tu correo',
          'code': 'email_not_verified',
          'email': 'ana@example.com',
        },
      ),
    );

    final exception = ApiErrorHandler.handle(error);

    expect(exception.message, 'Debes verificar tu correo');
    expect(exception.statusCode, 403);
    expect(exception.code, 'email_not_verified');
    expect(exception.body?['email'], 'ana@example.com');
  });
}
