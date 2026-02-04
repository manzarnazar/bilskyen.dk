import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../config/api_config.dart';
import '../../models/sell_vehicle_model/vehicle_lookup_response_model.dart';
import '../../models/sell_vehicle_model/reference_data_model.dart';
import '../../models/sell_vehicle_model/sell_vehicle_request_model.dart';
import '../../models/sell_vehicle_model/plan_model.dart';
import '../../network/network_repository.dart';

class SellVehicleRepository {
  final networkRepository = NetworkRepository();

  /// Get vehicle by registration (license plate)
  Future<Either<String, VehicleLookupResponseModel>> getVehicleByRegistration(
      String registration) async {
    final response = await networkRepository.post(
      url: ApiConfig.nummerpladeVehicleByRegistration,
      data: {
        'registration': registration,
        'advanced': true,
      },
    );

    if (!response.failed && response.success) {
      try {
        // Handle nested response structure: data.data.data or data.data
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          if (responseData['data'] is Map &&
              responseData['data'].containsKey('data')) {
            responseData = responseData['data']['data'];
          } else if (responseData['data'] is Map) {
            responseData = responseData['data'];
          }
        }

        final vehicleData = VehicleLookupResponseModel.fromJson(
            responseData as Map<String, dynamic>);
        return right(vehicleData);
      } catch (e) {
        return left('Failed to parse vehicle data: ${e.toString()}');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch vehicle information');
  }

  /// Get colors reference data
  Future<Either<String, List<ColorModel>>> getColors() async {
    final response = await networkRepository.get(
      url: ApiConfig.nummerpladeReferenceColors,
    );

    if (!response.failed && response.success) {
      try {
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          responseData = responseData['data'];
        }

        final colorsList = responseData as List<dynamic>;
        final colors = colorsList
            .map((e) => ColorModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(colors);
      } catch (e) {
        return left('Failed to parse colors: ${e.toString()}');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch colors');
  }

  /// Get equipment reference data
  Future<Either<String, List<EquipmentModel>>> getEquipment() async {
    final response = await networkRepository.get(
      url: ApiConfig.nummerpladeReferenceEquipment,
    );

    if (!response.failed && response.success) {
      try {
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          responseData = responseData['data'];
        }

        final equipmentList = responseData as List<dynamic>;
        final equipment = equipmentList
            .map((e) => EquipmentModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(equipment);
      } catch (e) {
        return left('Failed to parse equipment: ${e.toString()}');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch equipment');
  }

  /// Get variants reference data
  Future<Either<String, List<VariantModel>>> getVariants() async {
    final response = await networkRepository.get(
      url: ApiConfig.variants,
    );

    if (!response.failed && response.success) {
      try {
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          responseData = responseData['data'];
        }

        final variantsList = responseData as List<dynamic>;
        final variants = variantsList
            .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(variants);
      } catch (e) {
        return left('Failed to parse variants: ${e.toString()}');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch variants');
  }

  /// Get euronorms reference data
  Future<Either<String, List<EuronomModel>>> getEuronorms() async {
    final response = await networkRepository.get(
      url: ApiConfig.euronorms,
    );

    if (!response.failed && response.success) {
      try {
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          responseData = responseData['data'];
        }

        final euronormsList = responseData as List<dynamic>;
        final euronorms = euronormsList
            .map((e) => EuronomModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(euronorms);
      } catch (e) {
        return left('Failed to parse euronorms: ${e.toString()}');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch euronorms');
  }

  /// Get locations reference data (if available via API)
  Future<Either<String, List<LocationModel>>> getLocations() async {
    // Note: Locations might need to be fetched from internal API
    // For now, return empty list
    return right([]);
  }

  /// Get plans reference data (if available via API)
  Future<Either<String, List<PlanModel>>> getPlans() async {
    // Note: Plans need to be fetched from internal API
    // For now, return empty list
    return right([]);
  }

  /// Submit vehicle listing with images
  Future<Either<String, Map<String, dynamic>>> submitVehicleListing({
    required SellVehicleRequestModel requestData,
    required List<File> images,
  }) async {
    try {
      // Create FormData
      final formData = await networkRepository.createFormData(
        fields: requestData.toJson(),
        multipleFiles: {
          'images[]': images,
        },
      );

      final response = await networkRepository.postMultipart(
        url: ApiConfig.sellYourCar,
        formData: formData,
      );

      // Handle authentication errors (302 redirect or 401)
      if (response.failed) {
        // Check if it's an authentication error
        if (response.data is Map) {
          final responseData = response.data as Map<String, dynamic>;
          if (responseData.containsKey('status_code')) {
            final statusCode = responseData['status_code'];
            if (statusCode == 302 || statusCode == 401) {
              return left(
                'Authentication required. Please login again to submit your vehicle listing.',
              );
            }
          }
          if (responseData.containsKey('error') &&
              responseData['error'] == 'authentication_required') {
            return left(
              'Authentication required. Please login again to submit your vehicle listing.',
            );
          }
        }
        // Check response message for authentication hints
        if (response.message.contains('Authentication') ||
            response.message.contains('login')) {
          return left(
            'Authentication required. Please login again to submit your vehicle listing.',
          );
        }
      }

      if (!response.failed && response.success) {
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          responseData = responseData['data'];
        }
        return right(responseData as Map<String, dynamic>);
      }

      // Handle validation errors (422 status code) or failed responses
      final errorMessages = <String>[];
      
      // Check for Laravel validation errors format: { "errors": { "field": ["message1", "message2"] } }
      if (response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;
        
        if (responseData.containsKey('errors') && responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((field, value) {
            if (value is List) {
              // Multiple error messages for the same field
              for (var errorMsg in value) {
                // Convert snake_case field names to readable format
                final readableField = _formatFieldName(field);
                errorMessages.add('$readableField: $errorMsg');
              }
            } else if (value is String) {
              // Single error message
              final readableField = _formatFieldName(field);
              errorMessages.add('$readableField: $value');
            } else {
              // Fallback for other types
              final readableField = _formatFieldName(field);
              errorMessages.add('$readableField: $value');
            }
          });
        }
        
        // Also check for 'message' field (Laravel sometimes uses this for general errors)
        if (responseData.containsKey('message')) {
          final message = responseData['message'];
          if (message is String && message.isNotEmpty) {
            // Only add if we don't have field-specific errors, or as additional context
            if (errorMessages.isEmpty) {
              errorMessages.add(message);
            }
          }
        }
      }
      
      // Return formatted error messages if we have any
      if (errorMessages.isNotEmpty) {
        return left(errorMessages.join('\n'));
      }

      // Fallback to response message
      return left(response.message.isNotEmpty
          ? response.message
          : 'Failed to submit vehicle listing');
    } catch (e) {
      return left('Error submitting listing: ${e.toString()}');
    }
  }

  /// Formats field names from snake_case to readable format
  /// Example: 'fuel_type_id' -> 'Fuel Type', 'first_registration_date' -> 'First Registration Date'
  String _formatFieldName(String fieldName) {
    return fieldName
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
