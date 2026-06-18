import 'package:dio/dio.dart';
import '../models/api_exception.dart';
import '../models/multipart_file_data.dart';
import '../utils/api_error_handler.dart';
import '../utils/api_logger.dart';
import '../utils/api_response_handler.dart';

class MultipartRepository {
  final Dio _dio;

  MultipartRepository({required Dio dio}) : _dio = dio;

  Future<Map<String, dynamic>> postWithFile(
    String path, {
    required MultipartFileData file,
    Map<String, dynamic>? fields,
  }) async {
    try {
      final formData = FormData();

      if (fields != null) {
        _addFieldsRecursively(formData, fields, '');
      }

      formData.files.add(
        MapEntry(
          file.fieldName,
          await MultipartFile.fromFile(file.filePath),
        ),
      );

      ApiLogger.logFormData(formData);

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': null}),
      );

      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> postWithMultipleFiles(
    String path, {
    required List<MultipartFileData> files,
    Map<String, dynamic>? fields,
  }) async {
    try {
      final formData = FormData();

      if (fields != null) {
        _addFieldsRecursively(formData, fields, '');
      }

      for (final file in files) {
        formData.files.add(
          MapEntry(
            file.fieldName,
            await MultipartFile.fromFile(file.filePath),
          ),
        );
      }

      ApiLogger.logFormData(formData);

      final response = await _dio.post(
        path,
        data: formData,
        options: Options(headers: {'Content-Type': null}),
      );

      return ApiResponseHandler.handle(response.data, response.statusCode!);
    } on DioException catch (e) {
      throw ApiErrorHandler.handle(e);
    } on ApiException {
      rethrow;
    }
  }

  void _addFieldsRecursively(
    FormData formData,
    Map<String, dynamic> fields,
    String prefix,
  ) {
    for (final entry in fields.entries) {
      final key = prefix.isEmpty ? entry.key : '$prefix[${entry.key}]';
      final value = entry.value;

      if (value is Map<String, dynamic>) {
        _addFieldsRecursively(formData, value, key);
      } else if (value is List) {
        for (int i = 0; i < value.length; i++) {
          final listKey = '$key[$i]';
          if (value[i] is Map<String, dynamic>) {
            _addFieldsRecursively(formData, value[i] as Map<String, dynamic>, listKey);
          } else {
            formData.fields.add(MapEntry(listKey, value[i].toString()));
          }
        }
      } else if (value != null) {
        formData.fields.add(MapEntry(key, value.toString()));
      }
    }
  }
}
