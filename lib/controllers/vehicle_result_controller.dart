import 'package:get/get.dart';
import '../models/vehicle_model/vehicle_model.dart';
import '../repositories/vehicle/vehicle_repository.dart';
import 'search_controller.dart' as search_controller;

class VehicleResultController extends GetxController {
  final VehicleRepository _vehicleRepository = VehicleRepository();

  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isHorizontalLayout = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchVehicles();
  }

  /// Fetch vehicles from API with current filters from SearchViewController (or none if not registered).
  Future<void> fetchVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';

    final queryParams = _getFiltersFromSearchController();
    final result = await _vehicleRepository.getAllVehicles(
      queryParameters: queryParams?.isNotEmpty == true ? queryParams : null,
    );

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

  /// Use filters from SearchViewController so result screen always uses latest filter state (e.g. when opening filters from result screen).
  Map<String, dynamic>? _getFiltersFromSearchController() {
    if (Get.isRegistered<search_controller.SearchViewController>()) {
      final c = Get.find<search_controller.SearchViewController>();
      final map = c.buildFilterMap();
      return map.isNotEmpty ? map : null;
    }
    return null;
  }

  /// Refresh vehicles list (keeps current filters).
  Future<void> refreshVehicles() async {
    await fetchVehicles();
  }

  /// Toggle between vertical and horizontal layout.
  void toggleLayout() {
    isHorizontalLayout.value = !isHorizontalLayout.value;
  }
}
