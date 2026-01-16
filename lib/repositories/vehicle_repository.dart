import '../models/vehicle_model.dart';
import '../models/api_response_model.dart';
import '../services/vehicle_api_service.dart';

class VehicleRepository {
  final VehicleApiService _apiService;

  VehicleRepository({VehicleApiService? apiService})
      : _apiService = apiService ?? VehicleApiService();

  Future<List<VehicleModel>> getAllVehicles() async {
    try {
      // Fetch first page with a large limit to get all vehicles
      final response = await _apiService.getVehicles(
        page: 1,
        limit: 1000, // Large limit to get all vehicles
      );
      return response.data.docs;
    } catch (e) {
      // Return empty list on error
      return [];
    }
  }

  Future<ApiResponse<PaginatedResponse<VehicleModel>>> getVehiclesPaginated({
    int page = 1,
    int limit = 15,
    int? categoryId,
    int? brandId,
    int? modelYearId,
    int? fuelTypeId,
    int? minPrice,
    int? maxPrice,
    String? search,
    String? sort,
  }) async {
    return await _apiService.getVehicles(
      page: page,
      limit: limit,
      categoryId: categoryId,
      brandId: brandId,
      modelYearId: modelYearId,
      fuelTypeId: fuelTypeId,
      minPrice: minPrice,
      maxPrice: maxPrice,
      search: search,
      sort: sort,
    );
  }

  Future<VehicleModel?> getVehicleById(int id) async {
    try {
      return await _apiService.getVehicleById(id);
    } catch (e) {
      return null;
    }
  }

  Future<List<VehicleModel>> searchVehicles(String query) async {
    try {
      final response = await _apiService.getVehicles(
        page: 1,
        limit: 100,
        search: query,
      );
      return response.data.docs;
    } catch (e) {
      return [];
    }
  }

  Future<void> toggleFavorite(int vehicleId) async {
    // Favorite functionality would be implemented here
    // This would require a separate API endpoint
  }
}

