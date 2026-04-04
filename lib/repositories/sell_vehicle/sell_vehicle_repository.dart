import 'dart:io';
import 'package:dartz/dartz.dart';
import '../../config/api_config.dart';
import '../../models/constants_model/constants_model.dart';
import '../../models/sell_vehicle_model/vehicle_lookup_response_model.dart';
import '../../models/sell_vehicle_model/reference_data_model.dart';
import '../../models/sell_vehicle_model/sell_vehicle_request_model.dart';
import '../../models/sell_vehicle_model/plan_model.dart';
import '../../network/network_repository.dart';

class SellVehicleRepository {
  final networkRepository = NetworkRepository();

  Map<String, dynamic>? _unwrapDataMap(dynamic responseData) {
    if (responseData is! Map) return null;
    final root = responseData as Map<String, dynamic>;
    if (root.containsKey('data') && root['data'] is Map<String, dynamic>) {
      return root['data'] as Map<String, dynamic>;
    }
    return root;
  }

  /// POST /dmr/vehicle-by-registration — local DMR dataset (no Nummerplade).
  Future<Either<String, VehicleLookupResponseModel>> getVehicleByRegistration(
      String registration) async {
    final response = await networkRepository.post(
      url: ApiConfig.dmrVehicleByRegistration,
      data: {
        'registration': registration,
      },
    );

    if (!response.failed && response.success) {
      try {
        dynamic responseData = response.data;
        if (responseData is Map && responseData.containsKey('data')) {
          if (responseData['data'] is Map &&
              (responseData['data'] as Map).containsKey('data')) {
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

  /// GET /dmr/manual-brands
  Future<Either<String, List<LookupItem>>> searchManualBrands({
    String? search,
    int limit = 500,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    final response = await networkRepository.get(
      url: ApiConfig.dmrManualBrands,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      try {
        final data = _unwrapDataMap(response.data);
        final items = (data?['items'] as List<dynamic>? ?? [])
            .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(items);
      } catch (e) {
        return left('Failed to parse brands: $e');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch brands');
  }

  /// GET /dmr/manual-models?brand_id=
  Future<Either<String, List<ModelItem>>> searchManualModels({
    required int brandId,
    String? search,
    int limit = 500,
  }) async {
    final query = <String, dynamic>{
      'brand_id': brandId,
      'limit': limit,
    };
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    final response = await networkRepository.get(
      url: ApiConfig.dmrManualModels,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      try {
        final data = _unwrapDataMap(response.data);
        final items = (data?['items'] as List<dynamic>? ?? [])
            .map((e) => ModelItem.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(items);
      } catch (e) {
        return left('Failed to parse models: $e');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch models');
  }

  /// GET /dmr/manual-fuel-types
  Future<Either<String, List<LookupItem>>> searchManualFuelTypes({
    String? search,
    int limit = 10,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    final response = await networkRepository.get(
      url: ApiConfig.dmrManualFuelTypes,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      try {
        final data = _unwrapDataMap(response.data);
        final items = (data?['items'] as List<dynamic>? ?? [])
            .map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(items);
      } catch (e) {
        return left('Failed to parse fuel types: $e');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch fuel types');
  }

  /// POST /dmr/vehicle-by-manual — resolves `dmr_fact_vehicle_id` for manual selections.
  Future<Either<String, int>> resolveDmrFactVehicleIdByManual({
    required int manualBrandId,
    required int manualModelId,
    required int manualModelYearId,
    required int manualFuelTypeId,
  }) async {
    final response = await networkRepository.post(
      url: ApiConfig.dmrVehicleByManual,
      data: {
        'manual_brand_id': manualBrandId,
        'manual_model_id': manualModelId,
        'manual_model_year_id': manualModelYearId,
        'manual_fuel_type_id': manualFuelTypeId,
      },
    );
    if (!response.failed && response.success) {
      try {
        final data = _unwrapDataMap(response.data);
        final id = data?['dmr_fact_vehicle_id'];
        if (id == null) return left('No DMR vehicle id in response');
        return right((id as num).toInt());
      } catch (e) {
        return left('Failed to parse manual resolve: $e');
      }
    }
    String msg = response.message.isNotEmpty
        ? response.message
        : 'No matching vehicle was found for the selected manual values.';
    if (response.data is Map) {
      final m = response.data as Map<String, dynamic>;
      if (m['message'] is String && (m['message'] as String).isNotEmpty) {
        msg = m['message'] as String;
      }
    }
    return left(msg);
  }

  /// GET /variants — scoped to DMR `model_id` (same as web `reloadVariantsFromApi`).
  Future<Either<String, List<VariantModel>>> searchVariants({
    required int modelId,
    String? search,
    int limit = 25,
  }) async {
    final query = <String, dynamic>{
      'model_ids': modelId.toString(),
      'limit': limit,
    };
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    final response = await networkRepository.get(
      url: ApiConfig.variants,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      try {
        final data = _unwrapDataMap(response.data);
        final items = (data?['items'] as List<dynamic>? ?? [])
            .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(items);
      } catch (e) {
        return left('Failed to parse variants: $e');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to fetch variants');
  }

  /// Colors from public `/constants` (DMR colours), not Nummerplade.
  Future<Either<String, List<ColorModel>>> getColors() async {
    final response = await networkRepository.get(
      url: ApiConfig.constants,
    );

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>?;
        final colorsList = data?['colors'] as List<dynamic>? ?? [];
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

  /// Equipment from public `/constants`.
  Future<Either<String, List<EquipmentModel>>> getEquipment() async {
    final response = await networkRepository.get(
      url: ApiConfig.constants,
    );

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>?;
        final equipmentList = data?['equipments'] as List<dynamic>? ?? [];
        final equipment = equipmentList
            .map((e) => _equipmentFromConstantsJson(e as Map<String, dynamic>))
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

  static EquipmentModel _equipmentFromConstantsJson(Map<String, dynamic> json) {
    final typeId = json['equipment_type_id'];
    return EquipmentModel(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      equipmentTypeId: typeId == null ? null : (typeId as num).toInt(),
    );
  }

  /// Full variant list (optional; prefer [searchVariants] with `model_id`).
  Future<Either<String, List<VariantModel>>> getVariants() async {
    final response = await networkRepository.get(
      url: ApiConfig.variants,
      extraQuery: const {'limit': 500},
    );

    if (!response.failed && response.success) {
      try {
        final data = _unwrapDataMap(response.data);
        final items = (data?['items'] as List<dynamic>? ?? [])
            .map((e) => VariantModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(items);
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
        if (responseData is Map && responseData.containsKey('items')) {
          responseData = responseData['items'];
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
    return right([]);
  }

  /// Get plans reference data (if available via API)
  Future<Either<String, List<PlanModel>>> getPlans() async {
    return right([]);
  }

  /// Submit vehicle listing with images
  Future<Either<String, Map<String, dynamic>>> submitVehicleListing({
    required SellVehicleRequestModel requestData,
    required List<File> images,
  }) async {
    try {
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

      if (response.failed) {
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

      final errorMessages = <String>[];

      if (response.data is Map) {
        final responseData = response.data as Map<String, dynamic>;

        if (responseData.containsKey('errors') && responseData['errors'] is Map) {
          final errors = responseData['errors'] as Map<String, dynamic>;
          errors.forEach((field, value) {
            if (value is List) {
              for (var errorMsg in value) {
                final readableField = _formatFieldName(field);
                errorMessages.add('$readableField: $errorMsg');
              }
            } else if (value is String) {
              final readableField = _formatFieldName(field);
              errorMessages.add('$readableField: $value');
            } else {
              final readableField = _formatFieldName(field);
              errorMessages.add('$readableField: $value');
            }
          });
        }

        if (responseData.containsKey('message')) {
          final message = responseData['message'];
          if (message is String && message.isNotEmpty) {
            if (errorMessages.isEmpty) {
              errorMessages.add(message);
            }
          }
        }
      }

      if (errorMessages.isNotEmpty) {
        return left(errorMessages.join('\n'));
      }

      return left(response.message.isNotEmpty
          ? response.message
          : 'Failed to submit vehicle listing');
    } catch (e) {
      return left('Error submitting listing: ${e.toString()}');
    }
  }

  String _formatFieldName(String fieldName) {
    return fieldName
        .split('_')
        .map((word) => word.isEmpty
            ? word
            : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }
}
