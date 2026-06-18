import 'package:dio/dio.dart';
import '../models/api_exception.dart';

class ApiErrorHandler {
  static ApiException handle(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return ApiException(
          'Tiempo de conexión agotado. Verifica tu conexión a internet.',
          isNetworkError: true,
        );
      case DioExceptionType.sendTimeout:
        return ApiException(
          'Tiempo de envío agotado. Inténtalo de nuevo.',
          isNetworkError: true,
        );
      case DioExceptionType.receiveTimeout:
        return ApiException(
          'Tiempo de respuesta agotado. Inténtalo de nuevo.',
          isNetworkError: true,
        );
      case DioExceptionType.badCertificate:
        return ApiException(
          'Certificado inválido. Contacta al soporte.',
          isNetworkError: true,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        final data = error.response?.data;

        if (statusCode == 422 && data != null) {
          final errors = _extractValidationErrors(data);
          return ApiException(errors, statusCode: statusCode);
        }

        return ApiException(
          _messageFromStatus(statusCode),
          statusCode: statusCode,
        );
      case DioExceptionType.cancel:
        return ApiException('Solicitud cancelada.');
      case DioExceptionType.connectionError:
        return ApiException(
          'Sin conexión a internet. Verifica tu red.',
          isNetworkError: true,
        );
      case DioExceptionType.unknown:
        return ApiException(
          'Error inesperado. Inténtalo de nuevo.',
          isNetworkError: true,
        );
    }
  }

  static String _messageFromStatus(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Solicitud incorrecta.';
      case 401:
        return 'No autorizado. Inicia sesión nuevamente.';
      case 403:
        return 'Acceso denegado.';
      case 404:
        return 'Recurso no encontrado.';
      case 409:
        return 'Conflicto con el estado actual.';
      case 500:
        return 'Error interno del servidor.';
      case 503:
        return 'Servicio no disponible. Inténtalo más tarde.';
      default:
        return 'Error del servidor (${statusCode ?? "desconocido"}).';
    }
  }

  static String _extractValidationErrors(dynamic data) {
    try {
      if (data is Map<String, dynamic> && data.containsKey('errors')) {
        final errors = data['errors'] as Map<String, dynamic>;
        return errors.values
            .expand((e) => e is List ? e.map((v) => v.toString()) : [e.toString()])
            .join('\n');
      }
      if (data is Map<String, dynamic> && data.containsKey('message')) {
        return data['message'].toString();
      }
    } catch (_) {}
    return 'Error de validación.';
  }
}
