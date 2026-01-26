import 'package:get/get.dart';
import 'package:car_marketplace/repositories/favorite/favorite_repository.dart';
import 'package:car_marketplace/main.dart';

class FavoriteController extends GetxController {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  
  // Cache favorite status for vehicles: vehicleId -> isFavorite
  final RxMap<int, bool> _favoriteCache = <int, bool>{}.obs;
  
  // Track vehicles currently being checked/updated - use map for better reactivity
  final RxMap<int, bool> _loadingVehicles = <int, bool>{}.obs;

  /// Check if a vehicle is favorited (from cache or API)
  bool isFavorite(int vehicleId) {
    return _favoriteCache[vehicleId] ?? false;
  }

  /// Check if a vehicle is currently being loaded/updated
  bool isLoading(int vehicleId) {
    return _loadingVehicles[vehicleId] == true;
  }

  /// Check favorite status for a single vehicle from API
  Future<void> checkFavoriteStatus(int vehicleId) async {
    // Don't check if user is not logged in
    if (!isLoggedIn) {
      return;
    }

    // Skip if already loading
    if (_loadingVehicles[vehicleId] == true) {
      return;
    }

    // Skip if already cached
    if (_favoriteCache.containsKey(vehicleId)) {
      return;
    }

    _loadingVehicles[vehicleId] = true;

    try {
      final result = await _favoriteRepository.checkFavorite(vehicleId);

      result.fold(
        (error) {
          // On error, default to false (not favorited) and cache it
          _favoriteCache[vehicleId] = false;
        },
        (isFavorited) {
          _favoriteCache[vehicleId] = isFavorited;
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      _favoriteCache[vehicleId] = false;
    } finally {
      // Always remove from loading map, even if there's an error
      _loadingVehicles.remove(vehicleId);
    }
  }

  /// Check favorite status for multiple vehicles at once
  Future<void> checkBatchFavorites(List<int> vehicleIds) async {
    // Don't check if user is not logged in
    if (!isLoggedIn) {
      return;
    }

    if (vehicleIds.isEmpty) {
      return;
    }

    // Filter out vehicles that are already cached
    final uncachedIds = vehicleIds.where((id) => !_favoriteCache.containsKey(id)).toList();
    
    if (uncachedIds.isEmpty) {
      return;
    }

    try {
      final result = await _favoriteRepository.checkBatch(uncachedIds);

      result.fold(
        (error) {
          // On error, set all to false
          for (final id in uncachedIds) {
            _favoriteCache[id] = false;
          }
        },
        (favoritesMap) {
          // Update cache with batch results
          for (final id in uncachedIds) {
            _favoriteCache[id] = favoritesMap[id] ?? false;
          }
        },
      );
    } catch (e) {
      // Handle any unexpected errors - set all to false
      for (final id in uncachedIds) {
        _favoriteCache[id] = false;
      }
    }
  }

  /// Toggle favorite status for a vehicle
  Future<void> toggleFavorite(int vehicleId) async {
    // Don't toggle if user is not logged in
    if (!isLoggedIn) {
      Get.snackbar(
        'Error',
        'Please login to add favorites',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
      return;
    }

    // Skip if already loading
    if (_loadingVehicles[vehicleId] == true) {
      return;
    }

    // Get current status (default to false if not cached)
    final currentStatus = _favoriteCache[vehicleId] ?? false;

    // Optimistic update - update UI immediately
    _favoriteCache[vehicleId] = !currentStatus;
    _loadingVehicles[vehicleId] = true;

    try {
      final result = await _favoriteRepository.toggleFavorite(vehicleId, currentStatus);

      result.fold(
        (error) {
          // Revert optimistic update on error
          _favoriteCache[vehicleId] = currentStatus;
          Get.snackbar(
            'Error',
            'Failed to update favorite: $error',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Get.theme.colorScheme.error,
            colorText: Get.theme.colorScheme.onError,
          );
        },
        (success) {
          // Success - keep the updated status
          // Optionally show a success message
          // final newStatus = !currentStatus;
          // if (newStatus) {
          //   Get.snackbar(
          //     'Success',
          //     'Added to favorites',
          //     snackPosition: SnackPosition.TOP,
          //     duration: const Duration(seconds: 1),
          //   );
          // } else {
          //   Get.snackbar(
          //     'Success',
          //     'Removed from favorites',
          //     snackPosition: SnackPosition.TOP,
          //     duration: const Duration(seconds: 1),
          //   );
          // }
        },
      );
    } catch (e) {
      // Handle any unexpected errors
      _favoriteCache[vehicleId] = currentStatus;
      Get.snackbar(
        'Error',
        'An unexpected error occurred',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      // Always remove from loading map, even if there's an error
      _loadingVehicles.remove(vehicleId);
    }
  }

  /// Clear favorite cache (useful on logout)
  void clearCache() {
    _favoriteCache.clear();
    _loadingVehicles.clear();
  }

  /// Check if user is logged in
  bool get isLoggedIn {
    final token = appStorage.read('token');
    return token != null && token.toString().isNotEmpty;
  }
}
