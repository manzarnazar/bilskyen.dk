import 'package:dartz/dartz.dart';
import 'package:bilskyen/config/api_config.dart';
import 'package:bilskyen/models/vehicle_model/vehicle_model.dart';
import 'package:bilskyen/models/seller/inquiry_model.dart';
import 'package:bilskyen/models/seller/seller_statistics_model.dart';
import 'package:bilskyen/network/network_repository.dart';

class SellerVehiclesResult {
  final List<VehicleModel> vehicles;
  final int page;
  final bool hasNextPage;
  final int totalDocs;

  SellerVehiclesResult({
    required this.vehicles,
    required this.page,
    required this.hasNextPage,
    required this.totalDocs,
  });
}

class SellerInquiriesResult {
  final List<InquiryModel> inquiries;
  final int page;
  final bool hasNextPage;
  final int totalDocs;

  SellerInquiriesResult({
    required this.inquiries,
    required this.page,
    required this.hasNextPage,
    required this.totalDocs,
  });
}

class SellerRepository {
  final _network = NetworkRepository();

  Future<Either<String, SellerVehiclesResult>> getVehicles({
    int page = 1,
    int limit = 15,
    int? vehicleListStatusId,
    String? search,
    String sort = 'created_at_desc',
  }) async {
    final query = <String, dynamic>{
      'page': page,
      'limit': limit,
      'sort': sort,
    };
    if (vehicleListStatusId != null) {
      // API field name was updated to `list_status_id`.
      query['list_status_id'] = vehicleListStatusId;
    }
    if (search != null && search.isNotEmpty) {
      query['search'] = search;
    }

    final response = await _network.get(
      url: ApiConfig.sellerVehicles,
      extraQuery: query,
    );

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>;
        final docs = data['docs'] as List<dynamic>;
        final vehicles = docs
            .map((e) => VehicleModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(SellerVehiclesResult(
          vehicles: vehicles,
          page: data['page'] as int? ?? page,
          hasNextPage: data['hasNextPage'] as bool? ?? false,
          totalDocs: data['totalDocs'] as int? ?? vehicles.length,
        ));
      } catch (e) {
        return left('Failed to parse vehicles: $e');
      }
    }
    return left(
        response.message.isNotEmpty ? response.message : 'Failed to load vehicles');
  }

  Future<Either<String, Map<String, dynamic>>> getVehicle(int id) async {
    final response = await _network.get(url: ApiConfig.sellerVehicle(id));

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>?;
        if (data == null) return left('No vehicle data');
        return right(data);
      } catch (e) {
        return left('Failed to parse vehicle: $e');
      }
    }
    return left(
        response.message.isNotEmpty ? response.message : 'Failed to load vehicle');
  }

  Future<Either<String, Map<String, dynamic>>> updateVehicle(
    int id,
    Map<String, dynamic> body,
  ) async {
    final response = await _network.put(
      url: ApiConfig.sellerUpdateVehicle(id),
      data: body,
    );

    if (!response.failed && response.success) {
      try {
        final raw = response.data;
        if (raw is Map<String, dynamic>) {
          final data = raw['data'];
          if (data is Map<String, dynamic>) {
            return right(data);
          }
          if (data == null) {
            return right(<String, dynamic>{});
          }
        }
        return right(<String, dynamic>{});
      } catch (e) {
        return left('Failed to parse response: $e');
      }
    }
    return left(
        response.message.isNotEmpty ? response.message : 'Failed to update vehicle');
  }

  Future<Either<String, void>> updateVehicleStatus(
    int id,
    int vehicleListStatusId,
  ) async {
    final response = await _network.patch(
      url: ApiConfig.sellerVehicleStatus(id),
      // API field name was updated to `list_status_id`.
      data: {'list_status_id': vehicleListStatusId},
    );

    if (!response.failed && response.success) {
      return right(null);
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to update status');
  }

  Future<Either<String, void>> deleteVehicle(int id) async {
    final response = await _network.delete(url: ApiConfig.sellerDeleteVehicle(id));

    if (!response.failed && response.success) {
      return right(null);
    }
    return left(
        response.message.isNotEmpty ? response.message : 'Failed to delete vehicle');
  }

  Future<Either<String, SellerInquiriesResult>> getInquiries({
    int page = 1,
    int limit = 15,
    int? vehicleId,
  }) async {
    final query = <String, dynamic>{'page': page, 'limit': limit};
    if (vehicleId != null) query['vehicle_id'] = vehicleId;

    final response = await _network.get(
      url: ApiConfig.sellerInquiries,
      extraQuery: query,
    );

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>;
        final docs = data['docs'] as List<dynamic>;
        final inquiries = docs
            .map((e) => InquiryModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return right(SellerInquiriesResult(
          inquiries: inquiries,
          page: data['page'] as int? ?? page,
          hasNextPage: data['hasNextPage'] as bool? ?? false,
          totalDocs: data['totalDocs'] as int? ?? inquiries.length,
        ));
      } catch (e) {
        return left('Failed to parse inquiries: $e');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to load inquiries');
  }

  Future<Either<String, InquiryModel>> getInquiry(int id) async {
    final response = await _network.get(url: ApiConfig.sellerInquiry(id));

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>;
        return right(InquiryModel.fromJson(data));
      } catch (e) {
        return left('Failed to parse inquiry: $e');
      }
    }
    return left(
        response.message.isNotEmpty ? response.message : 'Failed to load inquiry');
  }

  Future<Either<String, SellerStatisticsModel>> getStatistics() async {
    final response = await _network.get(url: ApiConfig.sellerStatistics);

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>;
        return right(SellerStatisticsModel.fromJson(data));
      } catch (e) {
        return left('Failed to parse statistics: $e');
      }
    }
    return left(response.message.isNotEmpty
        ? response.message
        : 'Failed to load statistics');
  }
}
