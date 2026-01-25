import 'package:get/get.dart';
import '../models/vehicle_model/vehicle_model.dart';
import '../repositories/vehicle/vehicle_repository.dart';

class VehicleResultController extends GetxController {
  final VehicleRepository _vehicleRepository = VehicleRepository();
  
  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isHorizontalLayout = false.obs; // false = vertical (default), true = horizontal

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  /// Fetch vehicles from API
  Future<void> fetchVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await _vehicleRepository.getAllVehicles();
    
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

  /// Refresh vehicles list
  Future<void> refreshVehicles() async {
    await fetchVehicles();
  }

  /// Toggle between vertical and horizontal layout
  void toggleLayout() {
    isHorizontalLayout.value = !isHorizontalLayout.value;
  }
}
