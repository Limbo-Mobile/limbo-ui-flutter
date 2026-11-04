class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;

  /// Machine-readable error code sent by the backend (`code` field), e.g.
  /// `email_not_verified`, `use_password_login`, `google_not_configured`.
  final String? code;

  /// Decoded JSON error body, when the server sent one (e.g. `email`,
  /// `retry_after`).
  final Map<String, dynamic>? body;

  ApiException(
    this.message, {
    this.statusCode,
    this.isNetworkError = false,
    this.code,
    this.body,
  });

  @override
  String toString() =>
      'ApiException: $message (Status: ${statusCode ?? "N/A"})';
}
