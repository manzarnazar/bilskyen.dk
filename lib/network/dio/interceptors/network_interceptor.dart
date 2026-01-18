import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import '../../../main.dart';
class NetworkInterceptor extends dio.Interceptor {
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
  void onError(dio.DioException err, dio.ErrorInterceptorHandler handler) {
    // Handle 401 Unauthorized - token expired or invalid
    if (err.response?.statusCode == 401) {
      _handleUnauthorized();
    }
    
    return handler.next(err);
  }

  void _handleUnauthorized() {
    
    appStorage.remove('token');
    appStorage.remove('refreshToken');
    
    // Get.offNamed(PrimaryRoute.login);
    
    
    Get.snackbar(
      'Session Expired',
      'Please login again',
      
    );
  }
}
