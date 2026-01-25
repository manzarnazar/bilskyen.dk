import 'package:car_marketplace/config/api_config.dart';
import 'package:car_marketplace/network/dio/interceptors/network_interceptor.dart';
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
      },
      connectTimeout: const Duration(seconds: 40),
      receiveTimeout: const Duration(seconds: 50),
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
    if (error.response?.data != null) {
      final responseData = error.response!.data;
      if (responseData is Map<String, dynamic>) {
        message = responseData["message"] ?? "Unknown error occurred";
        data = responseData;
        success = responseData["success"] ?? false;
      }
    } else {
      switch (error.type) {
        case DioExceptionType.cancel:
          message = "Request to API server was cancelled";
          break;
        case DioExceptionType.connectionError:
          message = "Failed connection to API server";
        case DioExceptionType.connectionTimeout:
          message = "Connection timed out";
        case DioExceptionType.unknown:
          message = "A Server Error Occured!";
          break;
        case DioExceptionType.receiveTimeout:
          message = "Receive timeout in connection with API server";
          break;
        case DioExceptionType.badResponse:
          message =
              "Received invalid status code: ${error.response?.statusCode}";
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
    );
  }
}
