import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';
import 'session/session_refresher.dart';
import 'session/session_store.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;
  late final SessionStore _session;
  SessionRefresher? _refresher;

  DioClient._internal({
    required String baseUrl,
    required Future<void> Function() onTokenExpired,
    required bool enableRefresh,
    required String refreshPath,
    SessionStore? session,
  }) {
    final options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );
    _dio = Dio(options);
    _session = session ?? SessionStore.secure();

    if (enableRefresh) {
      // Dedicated Dio without the auth interceptor: refreshing must never
      // recurse into itself.
      _refresher = SessionRefresher(
        dio: Dio(options.copyWith()),
        store: _session,
        path: refreshPath,
      );
    }

    final authInterceptor = AuthInterceptor(
      session: _session,
      refresher: _refresher,
      onTokenExpired: onTokenExpired,
    )..attach(_dio);

    _dio.interceptors.addAll([
      authInterceptor,
      LoggingInterceptor(),
    ]);
  }

  /// Initialises the singleton.
  ///
  /// With [enableRefresh] (default) the client silently renews the access
  /// token via `POST [refreshPath]` when a request answers 401, and only calls
  /// [onTokenExpired] once the refresh token itself is rejected.
  static DioClient init({
    required String baseUrl,
    required Future<void> Function() onTokenExpired,
    bool enableRefresh = true,
    String refreshPath = SessionRefresher.defaultPath,
    SessionStore? session,
  }) {
    _instance = DioClient._internal(
      baseUrl: baseUrl,
      onTokenExpired: onTokenExpired,
      enableRefresh: enableRefresh,
      refreshPath: refreshPath,
      session: session,
    );
    return _instance!;
  }

  static DioClient get instance {
    assert(
      _instance != null,
      'DioClient not initialized. Call DioClient.init() first.',
    );
    return _instance!;
  }

  Dio get dio => _dio;

  /// Token store shared with the HTTP layer.
  SessionStore get session => _session;

  /// Forces a refresh now (e.g. on app start when the access token expired).
  /// Returns [RefreshOutcome.invalid] when refresh is disabled or impossible.
  Future<RefreshOutcome> refreshSession() async =>
      await _refresher?.refresh() ?? RefreshOutcome.invalid;

  /// Refreshes only if the access token expires within [threshold]
  /// (default 5 min). Returns `null` when nothing was needed.
  Future<RefreshOutcome?> refreshIfExpiring({
    Duration threshold = const Duration(minutes: 5),
  }) async =>
      _refresher?.refreshIfExpiring(threshold);
}
