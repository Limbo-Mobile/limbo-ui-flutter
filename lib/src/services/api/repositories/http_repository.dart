import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/api_exception.dart';
import '../utils/api_error_handler.dart';
import '../utils/api_response_handler.dart';

class HttpRepository {
  final Dio _dio;
  final FlutterSecureStorage _storage;

  HttpRepository({
    required Dio dio,
    FlutterSecureStorage? storage,
  })  : _dio = dio,
        _storage = storage ?? const FlutterSecureStorage();

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? queryParameters,
    bool requiresAuth = true,
  }) async {
    try {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      final response = await _dio.get(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      final response = await _dio.post(path, data: body, options: options);
      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      final response = await _dio.put(path, data: body, options: options);
      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> patch(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      final response = await _dio.patch(path, data: body, options: options);
      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, dynamic>? body,
    bool requiresAuth = true,
  }) async {
    try {
      final options = await _buildOptions(requiresAuth: requiresAuth);
      final response = await _dio.delete(path, data: body, options: options);
      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  Future<Options> _buildOptions({bool requiresAuth = true}) async {
    final headers = <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _storage.read(key: 'token');
      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return Options(headers: headers);
  }
}
