import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:car_marketplace/config/api_config.dart';
import 'package:car_marketplace/models/vehicle_model/vehicle_model.dart';
import 'package:car_marketplace/models/vehicle_detail_model/vehicle_detail_model.dart';
import 'package:car_marketplace/network/network_repository.dart';

class VehicleRepository {
  final networkRepository = NetworkRepository();

  /// Get featured vehicles
  Future<Either<String, List<VehicleModel>>> getFeaturedVehicles() async {
    final response = await networkRepository.get(
      url: ApiConfig.featuredVehicles,
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>;
      final vehiclesList = data['vehicles'] as List<dynamic>;
      final vehicles = vehiclesList
          .map((vehicleJson) => VehicleModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList();
      return right(vehicles);
    }
    return left(response.message);
  }

  /// Get all vehicles, optionally with filter query parameters.
  /// [queryParameters] keys should match backend VehicleController::index (e.g. search, condition_id, price_from, price_to, brand_id, model_id, category_id, mileage_from, mileage_to, year_from, year_to, fuel_type_id, gear_type_id, body_type_id, sales_type_id, equipment_ids, euronorm). List values are sent as repeated query params for Laravel.
  Future<Either<String, List<VehicleModel>>> getAllVehicles({
    Map<String, dynamic>? queryParameters,
  }) async {
    Map<String, dynamic>? extraQuery = queryParameters;
    if (extraQuery != null && extraQuery.isNotEmpty) {
      extraQuery = Map<String, dynamic>.from(extraQuery);
      extraQuery.putIfAbsent('page', () => 1);
      extraQuery.putIfAbsent('limit', () => 15);
      extraQuery = _buildQueryParams(extraQuery);
    }
    final response = await networkRepository.get(
      url: ApiConfig.vehicles,
      extraQuery: extraQuery,
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>;
      final vehiclesList = data['docs'] as List<dynamic>;
      final vehicles = vehiclesList
          .map((vehicleJson) => VehicleModel.fromJson(vehicleJson as Map<String, dynamic>))
          .toList();
      return right(vehicles);
    }
    return left(response.message);
  }

  /// Convert filter map to query map. List values become ListParam for Dio so Laravel receives array params (key=1&key=2).
  static Map<String, dynamic> _buildQueryParams(Map<String, dynamic> map) {
    final result = <String, dynamic>{};
    for (final entry in map.entries) {
      if (entry.value is List) {
        result[entry.key] = ListParam(entry.value as List, ListFormat.multi);
      } else {
        result[entry.key] = entry.value;
      }
    }
    return result;
  }

  /// Get vehicle detail by ID
  Future<Either<String, VehicleDetailModel>> getVehicleDetail(int id) async {
    final response = await networkRepository.get(
      url: ApiConfig.vehicleDetail(id),
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>;
      final vehicleDetail = VehicleDetailModel.fromJson(data);
      return right(vehicleDetail);
    }
    return left(response.message);
  }

  /// Create lead (e.g. for WhatsApp click) - requires auth
  Future<Either<String, Map<String, dynamic>>> createLead(int vehicleId, String category) async {
    final response = await networkRepository.post(
      url: ApiConfig.vehicleLeads(vehicleId),
      data: {'category': category},
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return right(data);
    }
    return left(response.message.isNotEmpty ? response.message : 'Failed to create lead');
  }

  /// Submit enquiry form - requires auth
  Future<Either<String, Map<String, dynamic>>> submitEnquiry(int vehicleId, {required String name, required String message}) async {
    final response = await networkRepository.post(
      url: ApiConfig.vehicleEnquiries(vehicleId),
      data: {'name': name, 'message': message},
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return right(data);
    }
    return left(response.message.isNotEmpty ? response.message : 'Failed to submit enquiry');
  }

  /// Submit test drive request - requires auth
  Future<Either<String, Map<String, dynamic>>> submitTestDrive(int vehicleId, {required String name, required String message}) async {
    final response = await networkRepository.post(
      url: ApiConfig.vehicleTestDrive(vehicleId),
      data: {'name': name, 'message': message},
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return right(data);
    }
    return left(response.message.isNotEmpty ? response.message : 'Failed to submit test drive request');
  }

  /// Submit price negotiation - requires auth
  Future<Either<String, Map<String, dynamic>>> submitPriceNegotiation(int vehicleId, {required String name, required String message}) async {
    final response = await networkRepository.post(
      url: ApiConfig.vehiclePriceNegotiation(vehicleId),
      data: {'name': name, 'message': message},
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>? ?? {};
      return right(data);
    }
    return left(response.message.isNotEmpty ? response.message : 'Failed to submit price negotiation');
  }
}

