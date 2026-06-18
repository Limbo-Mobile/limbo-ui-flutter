import 'package:dio/dio.dart';
import 'interceptors/auth_interceptor.dart';
import 'interceptors/logging_interceptor.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;

  DioClient._internal({
    required String baseUrl,
    required Future<void> Function() onTokenExpired,
  }) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        sendTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.addAll([
      AuthInterceptor(onTokenExpired: onTokenExpired),
      LoggingInterceptor(),
    ]);
  }

  static DioClient init({
    required String baseUrl,
    required Future<void> Function() onTokenExpired,
  }) {
    _instance = DioClient._internal(
      baseUrl: baseUrl,
      onTokenExpired: onTokenExpired,
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
}
