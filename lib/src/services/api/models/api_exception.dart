class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final bool isNetworkError;

  ApiException(this.message, {this.statusCode, this.isNetworkError = false});

  @override
  String toString() =>
      'ApiException: $message (Status: ${statusCode ?? "N/A"})';
}
