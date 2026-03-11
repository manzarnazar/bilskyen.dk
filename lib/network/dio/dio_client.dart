import 'package:bilskyen/config/api_config.dart';
import 'package:bilskyen/network/dio/interceptors/network_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../network_response.dart';
import 'interceptors/retry_interceptor.dart';

class DioClient {
  DioClient() {
    _initializeDioClient();
  }
  static const int maxRetries = 2;
  static const int retryDelay = 1;

  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 50),
      followRedirects: false, // Don't follow redirects for API calls
      validateStatus: (status) {
        // Only treat 200-299 as success, don't follow redirects
        return status != null && status >= 200 && status < 300;
      },
    ),
  );

  void _initializeDioClient() {
    dio.interceptors.addAll([
      RetryInterceptor(
        dio: dio,
        options: RetryOptions(
          retries: maxRetries,
          retryInterval: const Duration(seconds: retryDelay),
          retryEvaluator: (error) async {
            if (error.response?.statusCode != null &&
                error.response!.statusCode! == 401) {
              // Get.offNamed(PrimaryRoute.onBoard);
              // appStorage.erase();
              return false;
            }
            if (error.type == DioExceptionType.connectionError ||
                error.type == DioExceptionType.connectionTimeout ||
                (error.response?.statusCode != null &&
                        error.response!.statusCode! >= 500) &&
                    error.requestOptions.method == "GET") {
              return true;
            }
            return false;
          },
        ),
      ),
      NetworkInterceptor(dioClient: dio),
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
        enabled: kDebugMode,
      )
    ]);
  }

  static NetworkResponse handleDioError(DioException error) {
    String message = "";
    dynamic data = "";
    bool success = false;
    
    // Handle 302 redirects (authentication issue)
    if (error.response?.statusCode == 302) {
      message = "Authentication required. Please login again.";
      data = {"error": "authentication_required", "status_code": 302};
      success = false;
      return NetworkResponse(
        message: message,
        data: data,
        success: success,
        failed: true,
      );
    }
    
    // Handle 401 Unauthorized
    if (error.response?.statusCode == 401) {
      message = "Unauthorized. Please login again.";
      data = error.response?.data ?? {"error": "unauthorized", "status_code": 401};
      success = false;
      return NetworkResponse(
        message: message,
        data: data,
        success: success,
        failed: true,
      );
    }

    // Handle 429 Too Many Requests (rate limit)
    if (error.response?.statusCode == 429) {
      message = "Too many attempts. Please try again in a minute.";
      data = error.response?.data ?? {"error": "rate_limit", "status_code": 429};
      success = false;
      return NetworkResponse(
        message: message,
        data: data,
        success: success,
        failed: true,
      );
    }

    if (error.response?.data != null) {
      final responseData = error.response!.data;
      if (responseData is Map<String, dynamic>) {
        message = responseData["message"] ?? "Unknown error occurred";
        data = responseData;
        success = responseData["success"] ?? false;
      } else if (responseData is String) {
        // Handle HTML responses (like redirect pages)
        if (responseData.contains('<!DOCTYPE html>') || 
            responseData.contains('Redirecting')) {
          message = "Authentication required. Please login again.";
          data = {"error": "authentication_required", "html_response": true};
        } else {
          message = responseData;
        }
      }
    } else {
      switch (error.type) {
        case DioExceptionType.cancel:
          message = "Request to API server was cancelled";
          break;
        case DioExceptionType.connectionError:
          message = "Failed connection to API server";
          break;
        case DioExceptionType.connectionTimeout:
          message = "Connection timed out";
          break;
        case DioExceptionType.unknown:
          message = "A Server Error Occurred!";
          break;
        case DioExceptionType.receiveTimeout:
          message = "Receive timeout in connection with API server";
          break;
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 302) {
            message = "Authentication required. Please login again.";
          } else {
            message = "Received invalid status code: $statusCode";
          }
          break;
        case DioExceptionType.sendTimeout:
          message = "Send timeout in connection with API server";
          break;
        case DioExceptionType.badCertificate:
          message = "Incorrect certificate";
          break;
      }
    }
    return NetworkResponse(
      message: message,
      data: data,
      success: success,
      failed: true,
    );
  }
}
