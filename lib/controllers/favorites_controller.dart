import 'package:get/get.dart';
import '../models/vehicle_model/vehicle_model.dart';
import '../repositories/favorite/favorite_repository.dart';

class FavoritesController extends GetxController {
  final FavoriteRepository _favoriteRepository = FavoriteRepository();
  
  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isHorizontalLayout = true.obs; // false = vertical, true = horizontal (default)

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  /// Fetch favorites from API
  Future<void> fetchFavorites() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await _favoriteRepository.getFavorites();
    
    result.fold(
      (error) {
        errorMessage.value = error;
        vehicles.clear();
      },
      (vehiclesList) {
        vehicles.value = vehiclesList;
      },
    );
    
    isLoading.value = false;
  }

  /// Refresh favorites list
  Future<void> refreshFavorites() async {
    await fetchFavorites();
  }

  /// Toggle between vertical and horizontal layout
  void toggleLayout() {
    isHorizontalLayout.value = !isHorizontalLayout.value;
  }

  /// Remove a vehicle from favorites list (when user unfavorites it)
  void removeVehicle(int vehicleId) {
    vehicles.removeWhere((vehicle) => vehicle.id == vehicleId);
  }
}
