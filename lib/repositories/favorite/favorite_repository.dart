import 'package:dartz/dartz.dart';
import 'package:car_marketplace/config/api_config.dart';
import 'package:car_marketplace/network/network_repository.dart';

class FavoriteRepository {
  final networkRepository = NetworkRepository();

  /// Check if a vehicle is favorited
  Future<Either<String, bool>> checkFavorite(int vehicleId) async {
    try {
      final response = await networkRepository.get(
        url: ApiConfig.favoritesCheck(vehicleId),
      );

      if (!response.failed && response.success && response.data != null) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          final isFavorited = data['is_favorited'] as bool? ?? false;
          return right(isFavorited);
        }
      }
      return left(response.message.isNotEmpty ? response.message : 'Failed to check favorite status');
    } catch (e) {
      return left('Error checking favorite: ${e.toString()}');
    }
  }

  /// Add a vehicle to favorites
  Future<Either<String, bool>> addFavorite(int vehicleId) async {
    try {
      final response = await networkRepository.post(
        url: ApiConfig.favorites,
        data: {'vehicle_id': vehicleId},
      );

      if (!response.failed && response.success) {
        return right(true);
      }
      return left(response.message.isNotEmpty ? response.message : 'Failed to add favorite');
    } catch (e) {
      return left('Error adding favorite: ${e.toString()}');
    }
  }

  /// Remove a vehicle from favorites
  Future<Either<String, bool>> removeFavorite(int vehicleId) async {
    try {
      final response = await networkRepository.post(
        url: ApiConfig.favoritesDelete(vehicleId),
        data: {},
      );

      if (!response.failed && response.success) {
        return right(true);
      }
      return left(response.message.isNotEmpty ? response.message : 'Failed to remove favorite');
    } catch (e) {
      return left('Error removing favorite: ${e.toString()}');
    }
  }

  /// Toggle favorite status (add if not favorited, remove if favorited)
  Future<Either<String, bool>> toggleFavorite(int vehicleId, bool isCurrentlyFavorited) async {
    if (isCurrentlyFavorited) {
      return await removeFavorite(vehicleId);
    } else {
      return await addFavorite(vehicleId);
    }
  }

  /// Check favorite status for multiple vehicles at once
  Future<Either<String, Map<int, bool>>> checkBatch(List<int> vehicleIds) async {
    if (vehicleIds.isEmpty) {
      return right({});
    }

    try {
      final response = await networkRepository.post(
        url: ApiConfig.favoritesCheckBatch,
        data: {'vehicle_ids': vehicleIds},
      );

      if (!response.failed && response.success && response.data != null) {
        final data = response.data['data'];
        if (data is Map<String, dynamic>) {
          // Convert string keys to int keys
          final favoritesMap = <int, bool>{};
          data.forEach((key, value) {
            final vehicleId = int.tryParse(key);
            if (vehicleId != null && value is bool) {
              favoritesMap[vehicleId] = value;
            }
          });
          return right(favoritesMap);
        }
      }
      return left(response.message.isNotEmpty ? response.message : 'Failed to check batch favorites');
    } catch (e) {
      return left('Error checking batch favorites: ${e.toString()}');
    }
  }
}
