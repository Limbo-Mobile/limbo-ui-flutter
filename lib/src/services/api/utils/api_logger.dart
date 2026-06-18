import 'dart:collection';
import 'package:dio/dio.dart';

class ApiLogger {
  static final Queue<String> _logBuffer = Queue();
  static const int _maxBufferSize = 100;

  static void _addToBuffer(String entry) {
    if (_logBuffer.length >= _maxBufferSize) {
      _logBuffer.removeFirst();
    }
    _logBuffer.addLast(entry);
  }

  static void logRequest(RequestOptions options) {
    final token = options.headers['Authorization']?.toString();
    final maskedToken = token != null ? _maskToken(token) : 'none';

    final buffer = StringBuffer()
      ..writeln('┌── 📤 REQUEST ──────────────────────────────')
      ..writeln('│ ${options.method} ${options.uri}')
      ..writeln('│ Token: $maskedToken');

    if (options.data != null) {
      buffer.writeln('│ Body: ${options.data}');
    }
    buffer.write('└────────────────────────────────────────────');

    final entry = buffer.toString();
    _addToBuffer(entry);
    // ignore: avoid_print
    print(entry);
  }

  static void logResponse(Response response) {
    final buffer = StringBuffer()
      ..writeln('┌── 📥 RESPONSE ─────────────────────────────')
      ..writeln('│ ${response.statusCode} ${response.requestOptions.uri}')
      ..writeln('│ Data: ${response.data}')
      ..write('└────────────────────────────────────────────');

    final entry = buffer.toString();
    _addToBuffer(entry);
    // ignore: avoid_print
    print(entry);
  }

  static void logError(DioException error) {
    final buffer = StringBuffer()
      ..writeln('┌── ❌ ERROR ─────────────────────────────────')
      ..writeln('│ ${error.requestOptions.method} ${error.requestOptions.uri}')
      ..writeln('│ Type: ${error.type}')
      ..writeln('│ Message: ${error.message}');

    if (error.response != null) {
      buffer.writeln('│ Status: ${error.response?.statusCode}');
      buffer.writeln('│ Data: ${error.response?.data}');
    }
    buffer.write('└────────────────────────────────────────────');

    final entry = buffer.toString();
    _addToBuffer(entry);
    // ignore: avoid_print
    print(entry);
  }

  static void logFormData(FormData formData) {
    final buffer = StringBuffer()
      ..writeln('┌── 📋 FORM DATA ─────────────────────────────')
      ..writeln('│ Fields: ${formData.fields}')
      ..writeln('│ Files: ${formData.files.map((f) => f.key).toList()}')
      ..write('└────────────────────────────────────────────');

    final entry = buffer.toString();
    _addToBuffer(entry);
    // ignore: avoid_print
    print(entry);
  }

  static void logException(Object error, StackTrace? stack, {String? context}) {
    final buffer = StringBuffer()
      ..writeln('┌── ⚠️ EXCEPTION ─────────────────────────────')
      ..writeln('│ Context: ${context ?? 'unknown'}')
      ..writeln('│ Error: $error');
    if (stack != null) {
      final lines = stack.toString().split('\n').take(4);
      for (final line in lines) {
        buffer.writeln('│ $line');
      }
    }
    buffer.write('└────────────────────────────────────────────');

    final entry = buffer.toString();
    _addToBuffer(entry);
    // ignore: avoid_print
    print(entry);
  }

  static List<String> getLogs() => _logBuffer.toList();

  static void clearLogs() => _logBuffer.clear();

  static String _maskToken(String token) {
    if (token.length <= 10) return '***';
    return '${token.substring(0, 6)}...${token.substring(token.length - 4)}';
  }
}
