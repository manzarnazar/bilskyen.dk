import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../main.dart';
import '../../../config/api_config.dart';

class NetworkInterceptor extends dio.Interceptor {
  final dio.Dio dioClient;
  bool _isRefreshing = false;

  NetworkInterceptor({required this.dioClient});

  @override
  void onResponse(dio.Response response, dio.ResponseInterceptorHandler handler) {
    final body = response.data;
    if (body != null) {
      final data = body['data'];
      if (data != null && data is Map<String, dynamic>) {
        // Handle access_token (snake_case) from backend API
        final accessToken = data["access_token"] ?? data["accessToken"];
        if (accessToken != null && accessToken is String) {
          appStorage.write('token', accessToken);
        }
        // Refresh token is stored in HttpOnly cookie by backend, no need to store here
        final refreshToken = data["refresh_token"] ?? data["refreshToken"];
        if (refreshToken != null && refreshToken is String) {
          appStorage.write('refreshToken', refreshToken);
        }
      }
    }
    return handler.next(response);
  }

  @override
  void onRequest(dio.RequestOptions options, dio.RequestInterceptorHandler handler) {
    final token = appStorage.read("token")?.toString() ?? "";
    if (token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    return handler.next(options);
  }

  @override
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) async {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      final requestPath = err.requestOptions.path;
      
      // Don't refresh token if 401 is from login or refresh endpoints
      if (_isLoginOrRefreshEndpoint(requestPath)) {
        _handleUnauthorized(_isLoginOrRefreshEndpoint(requestPath));
        return handler.next(err);
      }

      // If already refreshing, wait and then retry
      if (_isRefreshing) {
        // Wait a bit for refresh to complete, then retry
        await Future.delayed(const Duration(milliseconds: 500));
        final token = appStorage.read("token")?.toString() ?? "";
        if (token.isNotEmpty) {
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          try {
            final response = await dioClient.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: dio.Options(
                method: err.requestOptions.method,
                headers: err.requestOptions.headers,
              ),
            );
            return handler.resolve(response);
          } catch (e) {
            if (e is dio.DioException) {
              return handler.next(e);
            }
            return handler.next(err);
          }
        }
        return handler.next(err);
      }

      // Attempt to refresh token
      _isRefreshing = true;
      
      try {
        final refreshed = await _refreshToken();
        
        if (refreshed) {
          // Retry the original request with new token
          final token = appStorage.read("token")?.toString() ?? "";
          err.requestOptions.headers['Authorization'] = 'Bearer $token';
          
          // Retry the original request
          try {
            final response = await dioClient.request(
              err.requestOptions.path,
              data: err.requestOptions.data,
              queryParameters: err.requestOptions.queryParameters,
              options: dio.Options(
                method: err.requestOptions.method,
                headers: err.requestOptions.headers,
              ),
            );
            return handler.resolve(response);
          } catch (e) {
            if (e is dio.DioException) {
              return handler.next(e);
            }
            return handler.next(err);
          }
        } else {
          // Refresh failed, handle unauthorized
          _handleUnauthorized(_isLoginOrRefreshEndpoint(err.requestOptions.path));
          return handler.next(err);
        }
      } finally {
        _isRefreshing = false;
      }
    }
    
    return handler.next(err);
  }

  bool _isLoginOrRefreshEndpoint(String path) {
    // Check if the path ends with login or refresh endpoints
    // This ensures we match the exact endpoints, not just any path containing these strings
    return path.endsWith(ApiConfig.authLogin) || 
           path.endsWith(ApiConfig.authRefresh) ||
           path.contains('/${ApiConfig.authLogin}') ||
           path.contains('/${ApiConfig.authRefresh}');
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = appStorage.read("refreshToken")?.toString();
      
      // If no refresh token, can't refresh
      if (refreshToken == null || refreshToken.isEmpty) {
        return false;
      }

      final response = await dioClient.post(
        ApiConfig.authRefresh,
        data: {},
        options: dio.Options(
          headers: {
            // Refresh token might be in cookie, but we can also send it if needed
            // The backend should handle it via HttpOnly cookie
          },
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.data;
        if (body != null) {
          final data = body['data'];
          if (data != null && data is Map<String, dynamic>) {
            final accessToken = data["access_token"] ?? data["accessToken"];
            if (accessToken != null && accessToken is String) {
              appStorage.write('token', accessToken);
              return true;
            }
          }
        }
      }
      return false;
    } catch (e) {
      // Refresh failed
      return false;
    }
  }

  void _handleUnauthorized(bool isLoginOrRefreshEndpoint) {
    appStorage.remove('token');
    appStorage.remove('refreshToken');
    
    // Get.offNamed(PrimaryRoute.login);
    
    if(!isLoginOrRefreshEndpoint){

    Get.snackbar(
      'Session Expired',
      'Please login again',
    );
    }
  }
}
