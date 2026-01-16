import 'dart:convert';
import 'dart:developer' as developer;
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/api_response_model.dart';
import '../utils/token_storage.dart';

class ApiClient {
  final http.Client _client;
  bool _isRefreshing = false;
  
  ApiClient({http.Client? client}) : _client = client ?? http.Client() {
    // Debug: Verify ApiClient is instantiated with logging enabled
    print('[ApiClient] Initialized - API logging enabled');
  }
  
  // Helper method to sanitize headers for logging (hide sensitive info)
  Map<String, String> _sanitizeHeadersForLogging(Map<String, String> headers) {
    final sanitized = Map<String, String>.from(headers);
    if (sanitized.containsKey(ApiConfig.authorizationHeader)) {
      final authHeader = sanitized[ApiConfig.authorizationHeader]!;
      if (authHeader.startsWith('Bearer ')) {
        sanitized[ApiConfig.authorizationHeader] = 'Bearer ***HIDDEN***';
      } else {
        sanitized[ApiConfig.authorizationHeader] = '***HIDDEN***';
      }
    }
    return sanitized;
  }
  
  // Helper method to log request details
  void _logRequest({
    required String method,
    required String url,
    Map<String, String>? headers,
    dynamic body,
    Map<String, String>? queryParams,
  }) {
    // Simple direct print first for visibility
    print('\n[API REQUEST] $method $url');
    
    final logBuffer = StringBuffer();
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    logBuffer.writeln('🌐 API REQUEST');
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    logBuffer.writeln('Method: $method');
    logBuffer.writeln('URL: $url');
    
    if (queryParams != null && queryParams.isNotEmpty) {
      logBuffer.writeln('Query Params: ${queryParams.toString()}');
    }
    
    if (headers != null && headers.isNotEmpty) {
      final sanitizedHeaders = _sanitizeHeadersForLogging(headers);
      logBuffer.writeln('Headers:');
      sanitizedHeaders.forEach((key, value) {
        logBuffer.writeln('  $key: $value');
      });
    }
    
    if (body != null) {
      String bodyString;
      if (body is String) {
        try {
          // Try to pretty print JSON
          final jsonBody = json.decode(body);
          bodyString = const JsonEncoder.withIndent('  ').convert(jsonBody);
        } catch (e) {
          bodyString = body;
        }
      } else if (body is Map || body is List) {
        bodyString = const JsonEncoder.withIndent('  ').convert(body);
      } else {
        bodyString = body.toString();
      }
      logBuffer.writeln('Payload:');
      logBuffer.writeln(bodyString);
    }
    
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final logMessage = logBuffer.toString();
    print(logMessage);
    developer.log(logMessage, name: 'ApiClient');
  }
  
  // Helper method to log response details
  void _logResponse({
    required String method,
    required String url,
    required int statusCode,
    Map<String, String>? headers,
    String? body,
  }) {
    // Simple direct print first for visibility
    print('\n[API RESPONSE] $method $url - Status: $statusCode');
    
    final logBuffer = StringBuffer();
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    logBuffer.writeln('✅ API RESPONSE');
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    logBuffer.writeln('Method: $method');
    logBuffer.writeln('URL: $url');
    logBuffer.writeln('Status Code: $statusCode');
    
    if (headers != null && headers.isNotEmpty) {
      logBuffer.writeln('Headers:');
      headers.forEach((key, value) {
        logBuffer.writeln('  $key: $value');
      });
    }
    
    if (body != null && body.isNotEmpty) {
      try {
        // Try to pretty print JSON
        final jsonBody = json.decode(body);
        final prettyBody = const JsonEncoder.withIndent('  ').convert(jsonBody);
        logBuffer.writeln('Response Body:');
        logBuffer.writeln(prettyBody);
      } catch (e) {
        // Not JSON, log as-is but truncate if too long
        final truncatedBody = body.length > 1000 ? '${body.substring(0, 1000)}... (truncated)' : body;
        logBuffer.writeln('Response Body:');
        logBuffer.writeln(truncatedBody);
      }
    }
    
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final logMessage = logBuffer.toString();
    print(logMessage);
    developer.log(logMessage, name: 'ApiClient');
  }
  
  // Helper method to log errors
  void _logError({
    required String method,
    required String url,
    required dynamic error,
    int? statusCode,
  }) {
    // Simple direct print first for visibility
    print('\n[API ERROR] $method $url - Status: ${statusCode ?? "N/A"} - Error: $error');
    
    final logBuffer = StringBuffer();
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    logBuffer.writeln('❌ API ERROR');
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    logBuffer.writeln('Method: $method');
    logBuffer.writeln('URL: $url');
    if (statusCode != null) {
      logBuffer.writeln('Status Code: $statusCode');
    }
    logBuffer.writeln('Error: $error');
    logBuffer.writeln('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    final logMessage = logBuffer.toString();
    print(logMessage);
    developer.log(logMessage, name: 'ApiClient');
  }
  
  // Get default headers
  Map<String, String> _getHeaders({
    Map<String, String>? additionalHeaders,
    String? idempotencyKey,
    bool includeAuth = true,
  }) {
    final headers = <String, String>{
      ApiConfig.contentTypeHeader: ApiConfig.contentTypeJson,
      ApiConfig.acceptHeader: ApiConfig.acceptJson,
    };
    
    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }
    
    if (idempotencyKey != null) {
      headers[ApiConfig.idempotencyKeyHeader] = idempotencyKey;
    }
    
    return headers;
  }
  
  // Add authorization header
  Future<Map<String, String>> _addAuthHeader(Map<String, String> headers) async {
    if (headers.containsKey(ApiConfig.authorizationHeader)) {
      return headers;
    }
    
    final token = await TokenStorage.getAccessToken();
    if (token != null) {
      headers[ApiConfig.authorizationHeader] = 'Bearer $token';
    }
    
    return headers;
  }
  
  // Parse response
  T _parseResponse<T>(http.Response response, T Function(dynamic) fromJson, {String? method, String? url}) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      final jsonData = json.decode(response.body);
      
      // Log successful response
      if (method != null && url != null) {
        _logResponse(
          method: method,
          url: url,
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
      }
      
      return ApiResponse.fromJson(jsonData, fromJson).data;
    } else {
      // Log error response
      if (method != null && url != null) {
        _logResponse(
          method: method,
          url: url,
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
      }
      throw _parseError(response);
    }
  }
  
  // Parse error response
  Exception _parseError(http.Response response) {
    try {
      final jsonData = json.decode(response.body);
      final errorResponse = ErrorResponse.fromJson(jsonData);
      return ApiException(
        message: errorResponse.message,
        statusCode: response.statusCode,
        errors: errorResponse.errors,
      );
    } catch (e) {
      return ApiException(
        message: 'Request failed with status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }
  
  // Handle 401 with token refresh
  Future<http.Response> _handleAuthError(
    Future<http.Response> Function() request,
  ) async {
    final response = await request();
    
    if (response.statusCode == 401 && !_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshUrl = '${ApiConfig.apiBaseUrl}${ApiConfig.authRefresh}';
        
        // Log token refresh attempt
        print('🔄 [ApiClient] Attempting token refresh...');
        developer.log('🔄 Attempting token refresh...', name: 'ApiClient');
        
        // Attempt to refresh token
        final refreshResponse = await _client.post(
          Uri.parse(refreshUrl),
          headers: _getHeaders(includeAuth: false),
        );
        
        // Log refresh response
        _logResponse(
          method: 'POST (Token Refresh)',
          url: refreshUrl,
          statusCode: refreshResponse.statusCode,
          headers: refreshResponse.headers,
          body: refreshResponse.body,
        );
        
        if (refreshResponse.statusCode == 200) {
          final jsonData = json.decode(refreshResponse.body);
          final data = jsonData['data'] as Map<String, dynamic>;
          final newToken = data['access_token'] as String;
          await TokenStorage.saveAccessToken(newToken);
          
          print('✅ [ApiClient] Token refreshed successfully');
          developer.log('✅ Token refreshed successfully', name: 'ApiClient');
          
          // Retry original request
          return await request();
        } else {
          // Refresh failed, clear tokens
          await TokenStorage.clearTokens();
          throw ApiException(
            message: 'Session expired. Please login again.',
            statusCode: 401,
          );
        }
      } finally {
        _isRefreshing = false;
      }
    }
    
    return response;
  }
  
  // GET request
  Future<T> get<T>(
    String endpoint, {
    Map<String, String>? queryParams,
    Map<String, String>? headers,
    String? idempotencyKey,
    T Function(dynamic)? fromJson,
    bool includeAuth = true,
  }) async {
    var uri = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
    
    try {
      if (queryParams != null && queryParams.isNotEmpty) {
        uri = uri.replace(queryParameters: queryParams);
      }
      
      var requestHeaders = _getHeaders(
        additionalHeaders: headers,
        idempotencyKey: idempotencyKey,
        includeAuth: includeAuth,
      );
      
      if (includeAuth) {
        requestHeaders = await _addAuthHeader(requestHeaders);
      }
      
      // Log request
      _logRequest(
        method: 'GET',
        url: uri.toString(),
        headers: requestHeaders,
        queryParams: queryParams,
      );
      
      final response = await _handleAuthError(() async {
        return await _client.get(uri, headers: requestHeaders).timeout(
          ApiConfig.requestTimeout,
        );
      });
      
      if (fromJson != null) {
        return _parseResponse<T>(response, fromJson, method: 'GET', url: uri.toString());
      } else {
        final jsonData = json.decode(response.body);
        
        // Log successful response
        _logResponse(
          method: 'GET',
          url: uri.toString(),
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
        
        return jsonData['data'] as T;
      }
    } catch (e) {
      // Log error
      _logError(
        method: 'GET',
        url: uri.toString(),
        error: e,
        statusCode: e is ApiException ? e.statusCode : null,
      );
      
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // POST request
  Future<T> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    String? idempotencyKey,
    T Function(dynamic)? fromJson,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
    
    try {
      var requestHeaders = _getHeaders(
        additionalHeaders: headers,
        idempotencyKey: idempotencyKey,
        includeAuth: includeAuth,
      );
      
      if (includeAuth) {
        requestHeaders = await _addAuthHeader(requestHeaders);
      }
      
      final encodedBody = body != null ? json.encode(body) : null;
      
      // Log request
      _logRequest(
        method: 'POST',
        url: uri.toString(),
        headers: requestHeaders,
        body: encodedBody,
      );
      
      final response = await _handleAuthError(() async {
        return await _client.post(
          uri,
          headers: requestHeaders,
          body: encodedBody,
        ).timeout(ApiConfig.requestTimeout);
      });
      
      if (fromJson != null) {
        return _parseResponse<T>(response, fromJson, method: 'POST', url: uri.toString());
      } else {
        final jsonData = json.decode(response.body);
        
        // Log successful response
        _logResponse(
          method: 'POST',
          url: uri.toString(),
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
        
        return jsonData['data'] as T;
      }
    } catch (e) {
      // Log error
      _logError(
        method: 'POST',
        url: uri.toString(),
        error: e,
        statusCode: e is ApiException ? e.statusCode : null,
      );
      
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // PUT request
  Future<T> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
    
    try {
      var requestHeaders = _getHeaders(
        additionalHeaders: headers,
        includeAuth: includeAuth,
      );
      
      if (includeAuth) {
        requestHeaders = await _addAuthHeader(requestHeaders);
      }
      
      final encodedBody = body != null ? json.encode(body) : null;
      
      // Log request
      _logRequest(
        method: 'PUT',
        url: uri.toString(),
        headers: requestHeaders,
        body: encodedBody,
      );
      
      final response = await _handleAuthError(() async {
        return await _client.put(
          uri,
          headers: requestHeaders,
          body: encodedBody,
        ).timeout(ApiConfig.requestTimeout);
      });
      
      if (fromJson != null) {
        return _parseResponse<T>(response, fromJson, method: 'PUT', url: uri.toString());
      } else {
        final jsonData = json.decode(response.body);
        
        // Log successful response
        _logResponse(
          method: 'PUT',
          url: uri.toString(),
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
        
        return jsonData['data'] as T;
      }
    } catch (e) {
      // Log error
      _logError(
        method: 'PUT',
        url: uri.toString(),
        error: e,
        statusCode: e is ApiException ? e.statusCode : null,
      );
      
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // DELETE request
  Future<T> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(dynamic)? fromJson,
    bool includeAuth = true,
  }) async {
    final uri = Uri.parse('${ApiConfig.apiBaseUrl}$endpoint');
    
    try {
      var requestHeaders = _getHeaders(
        additionalHeaders: headers,
        includeAuth: includeAuth,
      );
      
      if (includeAuth) {
        requestHeaders = await _addAuthHeader(requestHeaders);
      }
      
      // Log request
      _logRequest(
        method: 'DELETE',
        url: uri.toString(),
        headers: requestHeaders,
      );
      
      final response = await _handleAuthError(() async {
        return await _client.delete(
          uri,
          headers: requestHeaders,
        ).timeout(ApiConfig.requestTimeout);
      });
      
      if (fromJson != null) {
        return _parseResponse<T>(response, fromJson, method: 'DELETE', url: uri.toString());
      } else {
        final jsonData = json.decode(response.body);
        
        // Log successful response
        _logResponse(
          method: 'DELETE',
          url: uri.toString(),
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
        
        return jsonData['data'] as T;
      }
    } catch (e) {
      // Log error
      _logError(
        method: 'DELETE',
        url: uri.toString(),
        error: e,
        statusCode: e is ApiException ? e.statusCode : null,
      );
      
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Network error: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

// Custom exception for API errors
class ApiException implements Exception {
  final String message;
  final int statusCode;
  final Map<String, List<String>>? errors;
  
  ApiException({
    required this.message,
    required this.statusCode,
    this.errors,
  });
  
  @override
  String toString() => message;
  
  // Get first error message for a field
  String? getFieldError(String field) {
    if (errors == null) return null;
    final fieldErrors = errors![field];
    if (fieldErrors == null || fieldErrors.isEmpty) return null;
    return fieldErrors.first;
  }
  
  // Get all error messages as a single string
  String getAllErrors() {
    if (errors == null) return message;
    final allErrors = <String>[];
    errors!.forEach((field, messages) {
      allErrors.addAll(messages);
    });
    return allErrors.join('\n');
  }
}

