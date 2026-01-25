import 'package:get/get.dart';
import '../models/vehicle_detail_model/vehicle_detail_model.dart';
import '../repositories/vehicle/vehicle_repository.dart';

class VehicleDetailController extends GetxController {
  final VehicleRepository _vehicleRepository = VehicleRepository();
  
  final Rx<VehicleDetailModel?> vehicleDetail = Rx<VehicleDetailModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    final vehicleId = Get.parameters['id'];
    if (vehicleId != null) {
      fetchVehicleDetail(int.parse(vehicleId));
    }
  }

  /// Fetch vehicle detail from API
  Future<void> fetchVehicleDetail(int vehicleId) async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await _vehicleRepository.getVehicleDetail(vehicleId);
    
    result.fold(
      (error) {
        errorMessage.value = error;
        vehicleDetail.value = null;
      },
      (detail) {
        vehicleDetail.value = detail;
      },
    );
    
    isLoading.value = false;
  }
}
