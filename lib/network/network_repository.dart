import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';

import 'dio/dio_client.dart';
import 'network_monitor.dart';
import 'network_response.dart';

class NetworkRepository {
  final dioClient = DioClient();
  final networkMonitor = NetworkMonitor();

  Future<NetworkResponse> request({
    required String method,
    required String url,
    Map<String, dynamic>? data,
    Map<String, dynamic>? queryParameters,
    FormData? formData,
    Map<String, String>? headers,
  }) async {
    if (!await networkMonitor.checkConnection()) {
      throw NetworkResponse(
        message: "No internet connection",
        data: null,
        success: false,
      );
    }

    final completer = Completer<NetworkResponse>();
    late NetworkResponse networkResponse;
    StreamSubscription? networkSubscription;

    networkSubscription = networkMonitor.onConnectivityChanged.listen(
      (hasConnection) {
        if (!hasConnection && !completer.isCompleted) {
          networkResponse = NetworkResponse(
            message: "Internet connection lost",
            data: null,
            failed: true,
            success: false,
          );
          completer.completeError(networkResponse);
        }
      },
    );

    try {
      final response = await dioClient.dio.request(
        url,
        data: formData ?? data,
        queryParameters: queryParameters,
        options: Options(
          method: method,
          headers: headers,
        ),
      );

      networkResponse = _handleResponse(response);
      completer.complete(networkResponse);
    } on DioException catch (e) {
      log("Caught in DIO CATCH!");
      if (!completer.isCompleted) {
        networkResponse = DioClient.handleDioError(e);
        networkResponse.failed = true;
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } on NetworkResponse catch (e) {
      log("Caught in NETWORK CATCH!");
      if (!completer.isCompleted) {
        networkResponse = e;
        networkResponse.failed = true;
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } catch (e) {
      if (!completer.isCompleted) {
        log("Caught in NORMAL CATCH!");
        networkResponse = NetworkResponse(
          message: "An unexpected error occurred",
          data: null,
          success: false,
          failed: true,
        );
        completer.completeError(networkResponse);
        return networkResponse;
      }
    } finally {
      await networkSubscription.cancel();
    }

    return networkResponse;
  }

  Future<NetworkResponse> get({
    required String url,
    Map<String, dynamic>? extraQuery,
  }) =>
      request(
        method: 'GET',
        url: url,
        queryParameters: extraQuery,
      );

  Future<NetworkResponse> post({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'POST',
        url: url,
        data: data,
      );

  // New method for multipart POST requests
  Future<NetworkResponse> postMultipart({
    required String url,
    required FormData formData,
    Map<String, String>? headers,
  }) =>
      request(
        method: 'POST',
        url: url,
        formData: formData,
        headers: headers,
      );


  // Helper method to create FormData with text fields + single/multiple files
  Future<FormData> createFormData({
    Map<String, dynamic>? fields,
    Map<String, File>? files,
    Map<String, dynamic>? multipleFiles, // 🔥 dynamic for Web/Mobile
  }) async {
    final formData = FormData();

    // ✅ Add text fields
    if (fields != null) {
      fields.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    // ✅ Add single files (always File)
    if (files != null) {
      for (final entry in files.entries) {
        formData.files.add(
          MapEntry(
            entry.key,
            await MultipartFile.fromFile(
              entry.value.path,
              filename: entry.value.path.split('/').last,
            ),
          ),
        );
      }
    }

    // ✅ Add multiple files (can be File or bytes depending on platform)
    if (multipleFiles != null) {
      for (final entry in multipleFiles.entries) {
        final value = entry.value;

        if (value is List<File>) {
          // 📱 Mobile/desktop path
          for (final file in value) {
            formData.files.add(
              MapEntry(
                entry.key,
                await MultipartFile.fromFile(
                  file.path,
                  filename: file.path.split('/').last,
                ),
              ),
            );
          }
        } else if (value is List<Map<String, dynamic>>) {
          // 🌐 Web path (bytes + filename)
          for (final item in value) {
            final bytes = item['bytes'] as Uint8List;
            final filename = item['filename'] as String;
            formData.files.add(
              MapEntry(
                entry.key,
                MultipartFile.fromBytes(bytes, filename: filename),
              ),
            );
          }
        }
      }
    }

    return formData;
  }

  Future<NetworkResponse> patch({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'PATCH',
        url: url,
        data: data,
      );

  Future<NetworkResponse> put({
    required String url,
    Map<String, dynamic>? data,
  }) =>
      request(
        method: 'PUT',
        url: url,
        data: data,
      );

  Future<NetworkResponse> delete({required String url,Map<String, dynamic>? data}) => request(
        method: 'DELETE',
        url: url,
        data: data
      );

  NetworkResponse _handleResponse(Response response) {
    final body = response.data;
    if (response.statusCode == 200 || response.statusCode == 201) {
      return NetworkResponse(
        data: body,
        success: body is Map && body["success"] == true,
        message: body is Map && body.containsKey("message")
            ? body["message"]
            : "",
      );
    }
    throw NetworkResponse(success: false, data: body);
  }
}