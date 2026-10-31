import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../session/session_refresher.dart';
import '../session/session_store.dart';

/// Adds the bearer token and keeps the session alive.
///
/// With a [refresher], a 401 on an authenticated request triggers one silent
/// token refresh and a single retry of the original request. Only when the
/// refresh token itself is rejected is [onTokenExpired] called (logout).
/// Without a [refresher] it keeps the legacy behavior: any 401 on an
/// authenticated request calls [onTokenExpired].
class AuthInterceptor extends Interceptor {
  static const String _retriedKey = 'limbo_auth_retried';

  final SessionStore _session;
  final SessionRefresher? refresher;
  final Future<void> Function() onTokenExpired;

  /// Paths that must never trigger a refresh / logout cycle.
  final List<String> skipPaths;

  /// Dio used to replay a request after a refresh; set by [attach].
  Dio? _dio;

  AuthInterceptor({
    FlutterSecureStorage? storage,
    SessionStore? session,
    this.refresher,
    this.skipPaths = const ['/auth/logout'],
    required this.onTokenExpired,
  }) : _session = session ?? SessionStore.secure(storage);

  /// Binds the Dio instance this interceptor is installed on (for retries).
  void attach(Dio dio) => _dio = dio;

  bool _shouldSkip(String path) =>
      skipPaths.any(path.endsWith) || (refresher?.isRefreshPath(path) ?? false);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _session.readAccessToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final wasAuthenticated = request.headers['Authorization'] != null;

    if (!isUnauthorized || !wasAuthenticated || _shouldSkip(request.path)) {
      return super.onError(err, handler);
    }

    final refresher = this.refresher;
    final dio = _dio;
    if (refresher == null || dio == null) {
      await onTokenExpired();
      return super.onError(err, handler);
    }

    // The retry itself failed with 401: the session is not recoverable.
    if (request.extra[_retriedKey] == true) {
      await onTokenExpired();
      return super.onError(err, handler);
    }

    final outcome = await refresher.refresh();
    switch (outcome) {
      case RefreshOutcome.refreshed:
        try {
          final token = await _session.readAccessToken();
          final retry = await dio.fetch<dynamic>(_cloneForRetry(request, token));
          return handler.resolve(retry);
        } on DioException catch (retryError) {
          return handler.next(retryError);
        }
      case RefreshOutcome.invalid:
        await onTokenExpired();
        return super.onError(err, handler);
      case RefreshOutcome.unavailable:
        // Keep the session: a transient outage must not log the user out.
        return super.onError(err, handler);
    }
  }

  RequestOptions _cloneForRetry(RequestOptions original, String? token) {
    final data = original.data;
    final headers = Map<String, dynamic>.from(original.headers);
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    return original.copyWith(
      // A consumed multipart body cannot be re-sent: clone it.
      data: data is FormData ? data.clone() : data,
      headers: headers,
      extra: {...original.extra, _retriedKey: true},
    );
  }
}
