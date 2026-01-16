import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/car_model.dart';
import '../repositories/car_repository.dart';
import '../services/mock_car_service.dart';

class HomeController extends GetxController {
  final CarRepository _carRepository = CarRepository();

  final RxList<CarModel> cars = <CarModel>[].obs;
  final RxList<CarModel> filteredCars = <CarModel>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  // Filter observables
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = 10000000.0.obs;
  final RxnString selectedMileage = RxnString();
  final RxnString selectedBodyType = RxnString();
  final RxnString selectedFuelType = RxnString();
  final RxnString selectedTransmission = RxnString();
  final RxMap<String, bool> selectedFeatures = <String, bool>{}.obs;
  
  final RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCars();
    // Default to light theme - theme is already set in main.dart
    isDarkMode.value = false;
  }

  Future<void> loadCars() async {
    isLoading.value = true;
    try {
      final loadedCars = await _carRepository.getAllCars();
      cars.value = loadedCars;
      filteredCars.value = loadedCars;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cars: $e',
        snackPosition: SnackPosition.TOP,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    _applyFilters();
  }

  void setMileageFilter(String? mileage) {
    selectedMileage.value = mileage;
  }

  void setBodyTypeFilter(String? bodyType) {
    selectedBodyType.value = bodyType;
  }

  void setFuelTypeFilter(String? fuelType) {
    selectedFuelType.value = fuelType;
  }

  void setTransmissionFilter(String? transmission) {
    selectedTransmission.value = transmission;
  }

  void toggleFeature(String feature) {
    selectedFeatures[feature] = !(selectedFeatures[feature] ?? false);
  }

  void clearAllFilters() {
    minPrice.value = 0.0;
    maxPrice.value = 10000000.0;
    selectedMileage.value = null;
    selectedBodyType.value = null;
    selectedFuelType.value = null;
    selectedTransmission.value = null;
    selectedFeatures.clear();
    searchQuery.value = '';
    _applyFilters();
  }

  void applyFilters() {
    _applyFilters();
  }

  void _applyFilters() {
    List<CarModel> result = List.from(cars);

    // Apply search
    if (searchQuery.value.isNotEmpty) {
      result = MockCarService.searchCars(result, searchQuery.value);
    }

    // Apply price filter
    result = result.where((car) {
      return car.price >= minPrice.value && car.price <= maxPrice.value;
    }).toList();

    // Apply mileage filter
    if (selectedMileage.value != null) {
      final mileageRanges = {
        'Under 10k': (0, 10000),
        '10k - 30k': (10000, 30000),
        '30k - 60k': (30000, 60000),
        '60k+': (60000, 999999999),
      };
      final range = mileageRanges[selectedMileage.value];
      if (range != null) {
        result = result.where((car) {
          return car.mileage >= range.$1 && car.mileage < range.$2;
        }).toList();
      }
    }

    // Apply fuel type filter
    if (selectedFuelType.value != null) {
      final fuelMap = {
        'Gasoline': 'Petrol',
        'Electric': 'Electric',
        'Hybrid': 'Hybrid',
      };
      final fuelValue = fuelMap[selectedFuelType.value] ?? selectedFuelType.value;
      result = result.where((car) => car.fuelType == fuelValue).toList();
    }

    // Apply transmission filter
    if (selectedTransmission.value != null) {
      result = result.where((car) => car.transmission == selectedTransmission.value).toList();
    }

    filteredCars.value = result;
  }

  Future<void> toggleFavorite(String carId) async {
    try {
      await _carRepository.toggleFavorite(carId);
      final index = cars.indexWhere((car) => car.id == carId);
      if (index != -1) {
        cars[index] = cars[index].copyWith(
          isFavorite: !cars[index].isFavorite,
        );
        _applyFilters();
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
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  int get totalCars => _carRepository.totalCars;

  // Get only first 10 cars for display
  List<CarModel> get displayedCars {
    return filteredCars.take(10).toList();
  }

  int get displayedCarsCount => displayedCars.length;
}

