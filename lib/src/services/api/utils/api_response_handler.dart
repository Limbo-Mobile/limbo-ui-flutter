import '../models/api_exception.dart';

class ApiResponseHandler {
  static Map<String, dynamic> handle(dynamic responseData, int statusCode) {
    if (statusCode >= 200 && statusCode < 300) {
      if (responseData is List) return {'data': responseData};
      final map = responseData as Map<String, dynamic>;
      if (!map.containsKey('data')) return map;
      final data = map['data'];
      if (data is List) return {'data': data};
      return data as Map<String, dynamic>;
    }
    final map = responseData as Map<String, dynamic>?;
    throw ApiException(
      map?['message'] as String? ?? 'Error del servidor',
      statusCode: statusCode,
    );
  }
}
