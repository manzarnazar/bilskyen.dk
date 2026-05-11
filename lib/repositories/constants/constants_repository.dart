import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:bilskyen/config/api_config.dart';
import 'package:bilskyen/main.dart';
import 'package:bilskyen/models/constants_model/constants_model.dart';
import 'package:bilskyen/network/network_repository.dart';

class ConstantsRepository {
  final networkRepository = NetworkRepository();

  Either<String, List<T>> _parseLookupItems<T>(
    dynamic responseData,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    try {
      final root = responseData as Map<String, dynamic>;
      final data = root['data'] as Map<String, dynamic>?;
      final items = (data?['items'] as List<dynamic>? ?? <dynamic>[])
          .map((e) => fromJson(e as Map<String, dynamic>))
          .toList();
      return right(items);
    } catch (e) {
      return left('Failed to parse lookup response: $e');
    }
  }

  /// Fetch all constants from the API
  Future<Either<String, ConstantsModel>> getConstants() async {
    final response = await networkRepository.get(
      url: ApiConfig.constants,
    );

    if (!response.failed && response.success) {
      try {
        final data = response.data['data'] as Map<String, dynamic>;
        final constants = ConstantsModel.fromJson(data);
        
        // Save constants to storage for offline access
        appStorage.write('constants', jsonEncode(constants.toJson()));
        
        return right(constants);
      } catch (e) {
        return left('Failed to parse constants data: $e');
      }
    }
    return left(response.message);
  }

  /// Get constants from local storage
  ConstantsModel? getCachedConstants() {
    try {
      final constantsJson = appStorage.read('constants');
      if (constantsJson != null) {
        final data = jsonDecode(constantsJson.toString()) as Map<String, dynamic>;
        return ConstantsModel.fromJson(data);
      }
    } catch (e) {
      // Ignore errors when reading cached data
    }
    return null;
  }

  Future<Either<String, List<LookupItem>>> searchBrands({
    String? search,
    int limit = 25,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }

    final response = await networkRepository.get(
      url: ApiConfig.brands,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      return _parseLookupItems(response.data, LookupItem.fromJson);
    }
    return left(response.message);
  }

  Future<Either<String, List<ModelItem>>> searchModels({
    String? search,
    List<int> brandIds = const [],
    int limit = 25,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (brandIds.isNotEmpty) {
      query['brand_ids'] = brandIds.join(',');
    }

    final response = await networkRepository.get(
      url: ApiConfig.models,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      return _parseLookupItems(response.data, ModelItem.fromJson);
    }
    return left(response.message);
  }

  Future<Either<String, List<ModelItem>>> searchListingModels({
    String? search,
    List<int> brandIds = const [],
    int limit = 25,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (brandIds.isNotEmpty) {
      query['brand_ids'] = brandIds.join(',');
    }

    final response = await networkRepository.get(
      url: ApiConfig.listingModels,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      return _parseLookupItems(response.data, ModelItem.fromJson);
    }
    return left(response.message);
  }

  Future<Either<String, List<VariantItem>>> searchVariants({
    String? search,
    List<int> modelIds = const [],
    int limit = 25,
  }) async {
    final query = <String, dynamic>{'limit': limit};
    if (search != null && search.trim().isNotEmpty) {
      query['search'] = search.trim();
    }
    if (modelIds.isNotEmpty) {
      query['model_ids'] = modelIds.join(',');
    }

    final response = await networkRepository.get(
      url: ApiConfig.variants,
      extraQuery: query,
    );
    if (!response.failed && response.success) {
      return _parseLookupItems(response.data, VariantItem.fromJson);
    }
    return left(response.message);
  }
}
