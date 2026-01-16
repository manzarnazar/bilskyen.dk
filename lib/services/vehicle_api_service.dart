import '../config/api_config.dart';
import '../models/vehicle_model.dart';
import '../models/api_response_model.dart';
import '../services/api_client.dart';

class VehicleApiService {
  final ApiClient _apiClient;

  VehicleApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  /// Get vehicles with pagination and filters
  /// 
  /// Query parameters supported:
  /// - page: Page number (default: 1)
  /// - limit: Items per page (default: 15)
  /// - search: Search query
  /// - fuel_type_id: Filter by fuel type
  /// - category_id: Filter by category
  /// - brand_id: Filter by brand
  /// - model_year_id: Filter by model year
  /// - min_price: Minimum price filter
  /// - max_price: Maximum price filter
  /// - sort: Sort order (e.g., 'price_asc', 'price_desc', 'date_desc', etc.)
  Future<ApiResponse<PaginatedResponse<VehicleModel>>> getVehicles({
    int page = 1,
    int limit = 15,
    String? search,
    int? fuelTypeId,
    int? categoryId,
    int? brandId,
    int? modelYearId,
    int? minPrice,
    int? maxPrice,
    String? sort,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };

      if (search != null && search.isNotEmpty) {
        queryParams['search'] = search;
      }
      if (fuelTypeId != null) {
        queryParams['fuel_type_id'] = fuelTypeId.toString();
      }
      if (categoryId != null) {
        queryParams['category_id'] = categoryId.toString();
      }
      if (brandId != null) {
        queryParams['brand_id'] = brandId.toString();
      }
      if (modelYearId != null) {
        queryParams['model_year_id'] = modelYearId.toString();
      }
      if (minPrice != null) {
        queryParams['min_price'] = minPrice.toString();
      }
      if (maxPrice != null) {
        queryParams['max_price'] = maxPrice.toString();
      }
      if (sort != null && sort.isNotEmpty && sort != 'standard') {
        queryParams['sort'] = sort;
      }

      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConfig.vehicles,
        queryParams: queryParams,
        includeAuth: false, // Public endpoint
        fromJson: (json) => json as Map<String, dynamic>,
      );

      // Parse paginated response
      final paginatedData = PaginatedResponse<VehicleModel>.fromJson(
        response,
        (json) => VehicleModel.fromJson(json as Map<String, dynamic>),
      );

      return ApiResponse<PaginatedResponse<VehicleModel>>(
        data: paginatedData,
      );
    } catch (e) {
      if (e is ApiException) {
        rethrow;
      }
      throw ApiException(
        message: 'Failed to fetch vehicles: ${e.toString()}',
        statusCode: 0,
      );
    }
  }

  /// Get a single vehicle by ID
  Future<VehicleModel?> getVehicleById(int id) async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '${ApiConfig.vehicles}/$id',
        includeAuth: false, // Public endpoint
        fromJson: (json) => json as Map<String, dynamic>,
      );

      return VehicleModel.fromJson(response);
    } catch (e) {
      if (e is ApiException) {
        if (e.statusCode == 404) {
          return null;
        }
        rethrow;
      }
      throw ApiException(
        message: 'Failed to fetch vehicle: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
}

