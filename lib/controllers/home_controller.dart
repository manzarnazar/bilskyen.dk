import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/vehicle_model/vehicle_model.dart';
import '../repositories/vehicle/vehicle_repository.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _timer;
  
  final VehicleRepository _vehicleRepository = VehicleRepository();
  
  final RxList<VehicleModel> featuredVehicles = <VehicleModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchFeaturedVehicles();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  /// Fetch featured vehicles from API
  Future<void> fetchFeaturedVehicles() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    final result = await _vehicleRepository.getFeaturedVehicles();
    
    result.fold(
      (error) {
        errorMessage.value = error;
        featuredVehicles.clear();
      },
      (vehicles) {
        featuredVehicles.value = vehicles;
        if (vehicles.isNotEmpty) {
          _startAutoSlide();
        }
      },
    );
    
    isLoading.value = false;
  }

  void _startAutoSlide() {
    _timer?.cancel(); // Cancel existing timer if any
    if (featuredVehicles.isEmpty) return;
    
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (featuredVehicles.isEmpty) {
        timer.cancel();
        return;
      }
      
      if (currentPage.value < featuredVehicles.length - 1) {
        currentPage.value++;
      } else {
        currentPage.value = 0;
      }
      
      if (pageController.hasClients) {
        pageController.animateToPage(
          currentPage.value,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void onPageChanged(int index) {
    currentPage.value = index;
  }
}
