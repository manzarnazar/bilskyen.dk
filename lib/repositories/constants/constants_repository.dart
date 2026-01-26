import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:car_marketplace/config/api_config.dart';
import 'package:car_marketplace/main.dart';
import 'package:car_marketplace/models/constants_model/constants_model.dart';
import 'package:car_marketplace/network/network_repository.dart';

class ConstantsRepository {
  final networkRepository = NetworkRepository();

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
}
