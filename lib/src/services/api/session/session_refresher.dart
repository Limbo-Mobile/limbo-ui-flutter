import 'package:dio/dio.dart';
import 'session_store.dart';

/// Result of an attempt to renew the access token.
enum RefreshOutcome {
  /// New pair stored; retry the failed request.
  refreshed,

  /// The refresh token is invalid / expired / revoked (or absent): the
  /// session is over and local tokens were cleared.
  invalid,

  /// The server could not be reached (or answered 5xx). The session may still
  /// be valid, so nothing was cleared.
  unavailable,
}

/// Exchanges the stored refresh token for a new access/refresh pair.
///
/// Calls are **single-flight**: concurrent callers share one network request
/// and all receive its outcome, which matters because refresh tokens rotate
/// (a second parallel call with the old token would look like token reuse and
/// revoke the whole session family).
class SessionRefresher {
  static const String defaultPath = '/auth/refresh';

  /// Plain Dio (no auth interceptor) pointed at the API base URL.
  final Dio _dio;
  final SessionStore _store;
  final String path;

  Future<RefreshOutcome>? _inFlight;

  SessionRefresher({
    required Dio dio,
    required SessionStore store,
    this.path = defaultPath,
  })  : _dio = dio,
        _store = store;

  /// Whether [requestPath] is the refresh endpoint (never refresh for it).
  bool isRefreshPath(String requestPath) => requestPath.endsWith(path);

  Future<RefreshOutcome> refresh() => _inFlight ??= _doRefresh().whenComplete(
        () => _inFlight = null,
      );

  /// Refreshes only when the access token expires within [threshold].
  /// Returns `null` when no refresh was needed.
  Future<RefreshOutcome?> refreshIfExpiring(Duration threshold) async {
    final refreshToken = await _store.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) return null;
    if (!await _store.isExpiringWithin(threshold)) return null;
    return refresh();
  }

  Future<RefreshOutcome> _doRefresh() async {
    final refreshToken = await _store.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return RefreshOutcome.invalid;
    }
    try {
      final response = await _dio.post<dynamic>(
        path,
        data: {'refresh_token': refreshToken},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );
      final body = response.data;
      final payload = body is Map<String, dynamic>
          ? (body['data'] is Map<String, dynamic>
              ? body['data'] as Map<String, dynamic>
              : body)
          : null;
      if (payload == null || payload['token'] is! String) {
        return RefreshOutcome.unavailable;
      }
      await _store.saveFromPayload(payload);
      return RefreshOutcome.refreshed;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 401 || status == 403 || status == 422) {
        await _store.clear();
        return RefreshOutcome.invalid;
      }
      return RefreshOutcome.unavailable;
    }
  }
}
