import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/vehicle_model.dart';
import '../repositories/vehicle_repository.dart';

class VehicleController extends GetxController {
  final VehicleRepository _vehicleRepository = VehicleRepository();

  final RxList<VehicleModel> vehicles = <VehicleModel>[].obs;
  final RxList<VehicleModel> filteredVehicles = <VehicleModel>[].obs;
  final RxList<VehicleModel> recommendedVehicles = <VehicleModel>[].obs;
  final Rxn<VehicleModel> featuredVehicle = Rxn<VehicleModel>();
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  
  // Single vehicle loading state
  final RxBool isLoadingVehicle = false.obs;
  final Rxn<VehicleModel> currentVehicle = Rxn<VehicleModel>();
  
  // Pagination state
  final RxInt currentPage = 1.obs;
  final RxBool hasMorePages = false.obs;
  final RxInt totalVehiclesCount = 0.obs;

  // Filter observables matching API structure
  // Basic Filters
  final RxInt minPrice = 0.obs;
  final RxInt maxPrice = 5000000.obs; // 5 million DKK
  final RxList<int> selectedBrandIds = <int>[].obs;
  final RxBool showPopularBrandsOnly = false.obs;
  final RxInt minModelYear = 0.obs;
  final RxInt maxModelYear = 0.obs;
  final RxInt minMileage = 0.obs;
  final RxInt maxMileage = 0.obs;
  
  // Listing Details
  final RxnString listingType = RxnString(); // 'purchase', 'leasing'
  final RxnInt selectedCategoryId = RxnInt();
  final RxnString priceType = RxnString(); // 'retail', 'without_tax', 'wholesale'
  final RxnString condition = RxnString(); // 'new', 'used', 'all'
  
  // Vehicle Specs
  final RxnInt selectedBodyTypeId = RxnInt();
  final RxnInt selectedFuelTypeId = RxnInt();
  final RxnString selectedTransmission = RxnString(); // 'manual', 'automatic'
  final RxnString driveWheels = RxnString(); // 'fwd', 'rwd', 'awd'
  
  // Registration
  final RxInt firstRegistrationYearFrom = 0.obs;
  final RxInt firstRegistrationYearTo = 0.obs;
  final RxnString sellerType = RxnString(); // 'dealer', 'private' (only private in Flutter)
  final RxnString salesType = RxnString(); // 'consignment', 'facilitated'
  final RxnInt sellerDistanceKm = RxnInt();
  
  // Performance
  final RxnInt horsepowerMin = RxnInt();
  final RxnDouble accelerationMax = RxnDouble();
  
  // Battery & Charging (EV)
  final RxnInt batteryCapacityMin = RxnInt();
  final RxnInt rangeKmMin = RxnInt();
  final RxnString chargingType = RxnString();
  
  // Economy & Environment
  final RxnInt co2Max = RxnInt();
  final RxnString euroNorm = RxnString();
  final RxnInt ownershipTaxMax = RxnInt();
  final RxnString energyLabel = RxnString();
  
  // Physical Details
  final RxnInt doorsMin = RxnInt();
  final RxnInt seatsMin = RxnInt();
  final RxnInt trunkVolumeMin = RxnInt();
  
  // Equipment
  final RxList<int> selectedEquipmentIds = <int>[].obs;

  // Sorting
  final RxString selectedSort = 'standard'.obs;

  // Double versions for RangeSlider compatibility
  double get minPriceDouble => minPrice.value.toDouble();
  double get maxPriceDouble => maxPrice.value.toDouble();
  
  void setPriceRangeDouble(double min, double max) {
    minPrice.value = min.toInt();
    maxPrice.value = max.toInt();
    _applyFilters();
  }
  
  // Legacy UI compatibility filters (kept for backward compatibility)
  final RxnString selectedMileage = RxnString();
  final RxnString selectedBodyType = RxnString();
  final RxnString selectedFuelType = RxnString();
  final RxMap<String, bool> selectedFeatures = <String, bool>{}.obs;

  final RxBool isDarkMode = false.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    loadVehicles();
    loadFeaturedVehicle();
    loadRecommendedVehicles();
    themeMode.value = ThemeMode.system;
    _updateDarkModeFromTheme();
  }

  void _updateDarkModeFromTheme() {
    // Update isDarkMode based on current theme mode for backward compatibility
    if (themeMode.value == ThemeMode.dark) {
      isDarkMode.value = true;
    } else if (themeMode.value == ThemeMode.light) {
      isDarkMode.value = false;
    } else {
      // System mode - check system preference
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
    }
  }

  Future<void> loadVehicles({bool reset = true}) async {
    if (reset) {
      currentPage.value = 1;
      vehicles.clear();
      filteredVehicles.clear();
    }
    
    isLoading.value = true;
    try {
      final response = await _vehicleRepository.getVehiclesPaginated(
        page: currentPage.value,
        limit: 15,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        fuelTypeId: selectedFuelTypeId.value,
        categoryId: selectedCategoryId.value,
        brandId: selectedBrandIds.isNotEmpty ? selectedBrandIds.first : null,
        modelYearId: minModelYear.value > 0 ? minModelYear.value : null,
        minPrice: minPrice.value > 0 ? minPrice.value : null,
        maxPrice: maxPrice.value < 5000000 ? maxPrice.value : null,
        sort: selectedSort.value != 'standard' ? selectedSort.value : null,
      );
      
      if (reset) {
        vehicles.value = response.data.docs;
        filteredVehicles.value = response.data.docs;
      } else {
        vehicles.addAll(response.data.docs);
        filteredVehicles.addAll(response.data.docs);
      }
      
      hasMorePages.value = response.data.hasNextPage;
      totalVehiclesCount.value = response.data.totalDocs ?? 0;
    } catch (e) {
      print(e);
      Get.snackbar(
        'Error',
        'Failed to load vehicles: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> loadMoreVehicles() async {
    if (!hasMorePages.value || isLoading.value) return;
    
    currentPage.value++;
    await loadVehicles(reset: false);
  }

  Future<void> loadFeaturedVehicle() async {
    try {
      // Get the first vehicle sorted by price descending as featured
      final response = await _vehicleRepository.getVehiclesPaginated(
        page: 1,
        limit: 1,
        sort: 'price_desc',
      );
      
      if (response.data.docs.isNotEmpty) {
        featuredVehicle.value = response.data.docs.first;
      }
    } catch (e) {
      print('Failed to load featured vehicle: $e');
    }
  }

  Future<void> loadRecommendedVehicles() async {
    try {
      // Get recommended private cars (limit to 10)
      final response = await _vehicleRepository.getVehiclesPaginated(
        page: 1,
        limit: 10,
        sort: 'date_desc',
      );
      
      recommendedVehicles.value = response.data.docs;
    } catch (e) {
      print('Failed to load recommended vehicles: $e');
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  // Filter setter methods
  void setPriceRange(int min, int max) {
    minPrice.value = min;
    maxPrice.value = max;
    _applyFilters();
  }
  
  void setBrandFilter(int? brandId) {
    if (brandId == null) {
      selectedBrandIds.clear();
    } else {
      if (selectedBrandIds.contains(brandId)) {
        selectedBrandIds.remove(brandId);
      } else {
        selectedBrandIds.add(brandId);
      }
    }
    _applyFilters();
  }
  
  void toggleBrand(int brandId) {
    if (selectedBrandIds.contains(brandId)) {
      selectedBrandIds.remove(brandId);
    } else {
      selectedBrandIds.add(brandId);
    }
    _applyFilters();
  }
  
  void clearBrands() {
    selectedBrandIds.clear();
    _applyFilters();
  }
  
  void setPopularBrandsOnly(bool value) {
    showPopularBrandsOnly.value = value;
    _applyFilters();
  }
  
  void setModelYearRange(int min, int max) {
    minModelYear.value = min;
    maxModelYear.value = max;
    _applyFilters();
  }
  
  void setMileageRange(int min, int max) {
    minMileage.value = min;
    maxMileage.value = max;
    _applyFilters();
  }
  
  void setListingType(String? type) {
    listingType.value = type;
    _applyFilters();
  }
  
  void setCategoryFilter(int? categoryId) {
    selectedCategoryId.value = categoryId;
    _applyFilters();
  }
  
  void setPriceType(String? type) {
    priceType.value = type;
    _applyFilters();
  }
  
  void setCondition(String? cond) {
    condition.value = cond;
    _applyFilters();
  }
  
  void setBodyTypeFilter(int? bodyTypeId) {
    selectedBodyTypeId.value = bodyTypeId;
    _applyFilters();
  }
  
  void setFuelTypeFilter(int? fuelTypeId) {
    selectedFuelTypeId.value = fuelTypeId;
    _applyFilters();
  }
  
  void setTransmissionFilter(String? transmission) {
    selectedTransmission.value = transmission;
    _applyFilters();
  }
  
  void setDriveWheels(String? wheels) {
    driveWheels.value = wheels;
    _applyFilters();
  }
  
  void setFirstRegistrationYearRange(int from, int to) {
    firstRegistrationYearFrom.value = from;
    firstRegistrationYearTo.value = to;
    _applyFilters();
  }
  
  void setSellerType(String? type) {
    sellerType.value = type;
    _applyFilters();
  }
  
  void setSalesType(String? type) {
    salesType.value = type;
    _applyFilters();
  }
  
  void setSellerDistance(int? distance) {
    sellerDistanceKm.value = distance;
    _applyFilters();
  }
  
  void setPerformanceFilters(int? hpMin, double? accelMax) {
    horsepowerMin.value = hpMin;
    accelerationMax.value = accelMax;
    _applyFilters();
  }
  
  void setBatteryChargingFilters(int? batteryMin, int? rangeMin, String? charging) {
    batteryCapacityMin.value = batteryMin;
    rangeKmMin.value = rangeMin;
    chargingType.value = charging;
    _applyFilters();
  }
  
  void setEconomyFilters(int? co2, String? euro, int? taxMax, String? energy) {
    co2Max.value = co2;
    euroNorm.value = euro;
    ownershipTaxMax.value = taxMax;
    energyLabel.value = energy;
    _applyFilters();
  }
  
  void setPhysicalDetailsFilters(int? doors, int? seats, int? trunk) {
    doorsMin.value = doors;
    seatsMin.value = seats;
    trunkVolumeMin.value = trunk;
    _applyFilters();
  }
  
  void toggleEquipment(int equipmentId) {
    if (selectedEquipmentIds.contains(equipmentId)) {
      selectedEquipmentIds.remove(equipmentId);
    } else {
      selectedEquipmentIds.add(equipmentId);
    }
    _applyFilters();
  }
  
  void clearEquipment() {
    selectedEquipmentIds.clear();
    _applyFilters();
  }

  // Sorting methods
  void setSort(String sort) {
    selectedSort.value = sort;
    _applyFilters();
  }

  // UI compatibility methods for filter bottom sheet
  void applyFilters() {
    _applyFilters();
  }

  // Legacy methods (kept for backward compatibility)
  void setModelYearFilter(int? modelYearId) {
    if (modelYearId != null) {
      minModelYear.value = modelYearId;
      maxModelYear.value = modelYearId;
    }
    _applyFilters();
  }

  // Overload for string-based fuel type (UI compatibility)
  void setFuelTypeFilterString(String? fuelType) {
    selectedFuelType.value = fuelType;
    _applyFilters();
  }

  void setMileageFilter(String? mileage) {
    selectedMileage.value = mileage;
    _applyFilters();
  }

  void setBodyTypeFilterString(String? bodyType) {
    selectedBodyType.value = bodyType;
    _applyFilters();
  }

  void toggleFeature(String feature) {
    selectedFeatures[feature] = !(selectedFeatures[feature] ?? false);
    _applyFilters();
  }

  void clearAllFilters() {
    // Basic Filters
    minPrice.value = 0;
    maxPrice.value = 5000000;
    selectedBrandIds.clear();
    showPopularBrandsOnly.value = false;
    minModelYear.value = 0;
    maxModelYear.value = 0;
    minMileage.value = 0;
    maxMileage.value = 0;
    
    // Listing Details
    listingType.value = null;
    selectedCategoryId.value = null;
    priceType.value = null;
    condition.value = null;
    
    // Vehicle Specs
    selectedBodyTypeId.value = null;
    selectedFuelTypeId.value = null;
    selectedTransmission.value = null;
    driveWheels.value = null;
    
    // Registration
    firstRegistrationYearFrom.value = 0;
    firstRegistrationYearTo.value = 0;
    sellerType.value = null;
    salesType.value = null;
    sellerDistanceKm.value = null;
    
    // Performance
    horsepowerMin.value = null;
    accelerationMax.value = null;
    
    // Battery & Charging
    batteryCapacityMin.value = null;
    rangeKmMin.value = null;
    chargingType.value = null;
    
    // Economy & Environment
    co2Max.value = null;
    euroNorm.value = null;
    ownershipTaxMax.value = null;
    energyLabel.value = null;
    
    // Physical Details
    doorsMin.value = null;
    seatsMin.value = null;
    trunkVolumeMin.value = null;
    
    // Equipment
    selectedEquipmentIds.clear();
    
    // Legacy
    searchQuery.value = '';
    selectedMileage.value = null;
    selectedBodyType.value = null;
    selectedFuelType.value = null;
    selectedFeatures.clear();
    
    // Sorting
    selectedSort.value = 'standard';
    
    _applyFilters();
  }

  void _applyFilters() {
    // Reload vehicles from API with current filters
    loadVehicles(reset: true);
  }

  Future<void> toggleFavorite(int vehicleId) async {
    try {
      await _vehicleRepository.toggleFavorite(vehicleId);
      final index = vehicles.indexWhere((v) => v.id == vehicleId);
      if (index != -1) {
        // Note: Favorite functionality would need to be added to VehicleModel
        // For now, just reload vehicles
        await loadVehicles();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update favorite: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void toggleTheme() {
    // Legacy method - cycles through themes
    if (themeMode.value == ThemeMode.system) {
      themeMode.value = ThemeMode.light;
    } else if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
    setThemeMode(themeMode.value);
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    _updateDarkModeFromTheme();
  }

  int get totalVehicles => totalVehiclesCount.value;

  // Get vehicles for display (with pagination support)
  List<VehicleModel> getDisplayedVehicles({int limit = 10, int offset = 0}) {
    return filteredVehicles.skip(offset).take(limit).toList();
  }

  /// Load a single vehicle by ID
  /// Returns the vehicle if successful, null if not found
  Future<VehicleModel?> loadVehicleById(int id) async {
    isLoadingVehicle.value = true;
    currentVehicle.value = null;
    
    try {
      final vehicle = await _vehicleRepository.getVehicleById(id);
      currentVehicle.value = vehicle;
      
      if (vehicle == null) {
        Get.snackbar(
          'Not Found',
          'Vehicle not found',
          snackPosition: SnackPosition.TOP,
        );
      }
      
      return vehicle;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load vehicle: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
      );
      return null;
    } finally {
      isLoadingVehicle.value = false;
    }
  }
}

