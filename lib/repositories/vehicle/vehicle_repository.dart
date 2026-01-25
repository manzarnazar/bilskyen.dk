import 'package:dartz/dartz.dart';
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

  /// Get all vehicles
  Future<Either<String, List<VehicleModel>>> getAllVehicles() async {
    final response = await networkRepository.get(
      url: ApiConfig.vehicles,
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
}

