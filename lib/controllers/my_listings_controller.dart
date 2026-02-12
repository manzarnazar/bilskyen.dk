import 'package:get/get.dart';
import '../models/vehicle_model/vehicle_model.dart';
import '../models/seller/seller_statistics_model.dart';
import '../repositories/seller/seller_repository.dart';

/// Backend VehicleListStatus: 1=Draft, 2=Published, 3=Sold, 4=Archived
class VehicleListStatus {
  static const int draft = 1;
  static const int published = 2;
  static const int sold = 3;
  static const int archived = 4;
}

class MyListingsController extends GetxController {
  final SellerRepository _repo = SellerRepository();

  final Rx<SellerStatisticsModel?> statistics = Rx<SellerStatisticsModel?>(null);
  final RxBool isLoadingStats = true.obs;
  final RxString statsError = ''.obs;

  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  final RxBool isLoadingVehicles = true.obs;
  final RxString vehiclesError = ''.obs;
  final RxInt currentPage = 1.obs;
  final RxBool hasNextPage = false.obs;
  final RxInt totalDocs = 0.obs;

  /// null = All, else VehicleListStatus.*
  final Rx<int?> selectedStatusFilter = Rx<int?>(null);

  @override
  void onInit() {
    super.onInit();
    loadStatistics();
    loadVehicles(reset: true);
  }

  Future<void> loadStatistics() async {
    isLoadingStats.value = true;
    statsError.value = '';
    final result = await _repo.getStatistics();
    result.fold(
      (err) {
        statsError.value = err;
        statistics.value = null;
      },
      (data) {
        statistics.value = data;
        statsError.value = '';
      },
    );
    isLoadingStats.value = false;
  }

  Future<void> loadVehicles({bool reset = false}) async {
    if (reset) {
      currentPage.value = 1;
      vehicles.clear();
    }
    isLoadingVehicles.value = true;
    vehiclesError.value = '';
    final page = reset ? 1 : currentPage.value;
    final result = await _repo.getVehicles(
      page: page,
      limit: 15,
      vehicleListStatusId: selectedStatusFilter.value,
    );
    result.fold(
      (err) {
        vehiclesError.value = err;
        if (reset) vehicles.clear();
      },
      (data) {
        if (reset) {
          vehicles.assignAll(data.vehicles);
        } else {
          vehicles.addAll(data.vehicles);
        }
        currentPage.value = data.page;
        hasNextPage.value = data.hasNextPage;
        totalDocs.value = data.totalDocs;
        vehiclesError.value = '';
      },
    );
    isLoadingVehicles.value = false;
  }

  void setStatusFilter(int? statusId) {
    selectedStatusFilter.value = statusId;
    loadVehicles(reset: true);
  }

  @override
  Future<void> refresh() async {
    await loadStatistics();
    await loadVehicles(reset: true);
  }

  Future<void> loadMore() async {
    if (isLoadingVehicles.value || !hasNextPage.value) return;
    currentPage.value = currentPage.value + 1;
    await loadVehicles(reset: false);
  }

  Future<bool> updateVehicleStatus(int vehicleId, int statusId) async {
    final result = await _repo.updateVehicleStatus(vehicleId, statusId);
    return result.fold(
      (err) {
        Get.snackbar('Error', err, snackPosition: SnackPosition.TOP);
        return false;
      },
      (_) {
        Get.snackbar('Success', 'Status updated', snackPosition: SnackPosition.TOP);
        refresh();
        return true;
      },
    );
  }

  Future<bool> deleteVehicle(int vehicleId) async {
    final result = await _repo.deleteVehicle(vehicleId);
    return result.fold(
      (err) {
        Get.snackbar('Error', err, snackPosition: SnackPosition.TOP);
        return false;
      },
      (_) {
        Get.snackbar('Success', 'Vehicle deleted', snackPosition: SnackPosition.TOP);
        refresh();
        return true;
      },
    );
  }
}
