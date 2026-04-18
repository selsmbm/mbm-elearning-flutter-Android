import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class ApiDebugLogger {
  static const Set<String> _sensitiveHeaders = {
    'authorization',
    'api-key',
    'x-api-key',
    'cookie',
    'set-cookie',
  };

  static void logRequest({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
  }) {
    _printBlock([
      'API REQUEST',
      '$method $uri',
      'Headers: ${_prettyJson(_redactHeaders(headers ?? const {}))}',
      'Curl: ${_buildCurl(method: method, uri: uri, headers: headers, body: body)}',
      if (body != null) 'Body: ${_formatBody(body)}',
    ]);
  }

  static void logResponse({
    required String method,
    required Uri uri,
    required int statusCode,
    String? reasonPhrase,
    Map<String, String>? headers,
    String? body,
  }) {
    _printBlock([
      'API RESPONSE',
      '$method $uri',
      'Status: $statusCode${reasonPhrase == null || reasonPhrase.isEmpty ? '' : ' $reasonPhrase'}',
      'Headers: ${_prettyJson(headers ?? const {})}',
      'Body: ${body ?? ''}',
    ]);
  }

  static Future<String> logStreamedResponse({
    required String method,
    required Uri uri,
    required http.StreamedResponse response,
  }) async {
    final responseBody = await response.stream.bytesToString();
    logResponse(
      method: method,
      uri: uri,
      statusCode: response.statusCode,
      reasonPhrase: response.reasonPhrase,
      headers: response.headers,
      body: responseBody,
    );
    return responseBody;
  }

  static Map<String, String> _redactHeaders(Map<String, String> headers) {
    return headers.map((key, value) {
      if (_sensitiveHeaders.contains(key.toLowerCase())) {
        return MapEntry(key, '***REDACTED***');
      }
      return MapEntry(key, value);
    });
  }

  static String _buildCurl({
    required String method,
    required Uri uri,
    Map<String, String>? headers,
    Object? body,
  }) {
    final buffer = StringBuffer("curl -X $method '${_escapeShell(uri.toString())}'");
    final safeHeaders = _redactHeaders(headers ?? const {});
    for (final entry in safeHeaders.entries) {
      buffer.write(" -H '${_escapeShell('${entry.key}: ${entry.value}')}'");
    }
    if (body != null) {
      buffer.write(" --data '${_escapeShell(_encodeRequestBody(body))}'");
    }
    return buffer.toString();
  }

  static String _formatBody(Object body) {
    if (body is String) {
      return body;
    }
    if (body is Map || body is List) {
      return _prettyJson(body);
    }
    return body.toString();
  }

  static String _encodeRequestBody(Object body) {
    if (body is String) {
      return body;
    }
    if (body is Map) {
      return body.entries
          .map(
            (entry) =>
                '${Uri.encodeQueryComponent('${entry.key}')}=${Uri.encodeQueryComponent('${entry.value ?? ''}')}',
          )
          .join('&');
    }
    if (body is List) {
      return jsonEncode(body);
    }
    return body.toString();
  }

  static String _prettyJson(Object value) {
    try {
      return const JsonEncoder.withIndent('  ').convert(value);
    } catch (_) {
      return value.toString();
    }
  }

  static String _escapeShell(String value) {
    return value.replaceAll("'", r"'\''");
  }

  static void _printBlock(List<String> lines) {
    for (final line in lines) {
      for (final chunk in _chunkLine(line)) {
        debugPrintSynchronously('[API DEBUG] $chunk');
      }
    }
  }

  static Iterable<String> _chunkLine(String line, {int chunkSize = 800}) sync* {
    if (line.isEmpty) {
      yield '';
      return;
    }
    for (var i = 0; i < line.length; i += chunkSize) {
      final end = (i + chunkSize < line.length) ? i + chunkSize : line.length;
      yield line.substring(i, end);
    }
  }
}
