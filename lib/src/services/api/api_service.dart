import 'dio_client.dart';
import 'models/multipart_file_data.dart';
import 'repositories/http_repository.dart';
import 'repositories/multipart_repository.dart';

class ApiService {
  static late final HttpRepository _http;
  static late final MultipartRepository _multipart;

  static void init() {
    final dio = DioClient.instance.dio;
    _http = HttpRepository(dio: dio);
    _multipart = MultipartRepository(dio: dio);
  }

  static Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) =>
      _http.get(path, queryParameters: queryParameters, requiresAuth: requiresAuth);

  static Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) =>
      _http.post(path, body: body, requiresAuth: requiresAuth);

  static Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) =>
      _http.put(path, body: body, requiresAuth: requiresAuth);

  static Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) =>
      _http.patch(path, body: body, requiresAuth: requiresAuth);

  static Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) =>
      _http.delete(path, body: body, requiresAuth: requiresAuth);

  static Future<Map<String, dynamic>> postWithFile(
    String path, {
    required MultipartFileData file,
    Map<String, dynamic>? fields,
  }) =>
      _multipart.postWithFile(path, file: file, fields: fields);

  static Future<Map<String, dynamic>> postWithMultipleFiles(
    String path, {
    required List<MultipartFileData> files,
    Map<String, dynamic>? fields,
  }) =>
      _multipart.postWithMultipleFiles(path, files: files, fields: fields);
}
