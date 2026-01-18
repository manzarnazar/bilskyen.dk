import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final PageController pageController = PageController();
  final RxInt currentPage = 0.obs;
  Timer? _timer;

  // Hardcoded featured vehicles
  final List<Map<String, dynamic>> featuredVehicles = [
    {
      'id': 1,
      'title': 'Tesla Model 3',
      'price': 350000,
      'brandName': 'Tesla',
      'modelYearName': '2023',
      'fuelTypeName': 'Electric',
      'categoryName': 'Passenger car',
      'mileage': null,
    },
    {
      'id': 2,
      'title': 'BMW 3 Series',
      'price': 450000,
      'mileage': 25000,
      'brandName': 'BMW',
      'modelYearName': '2022',
      'fuelTypeName': 'Petrol',
      'categoryName': 'Passenger car',
    },
  ];

  @override
  void onInit() {
    super.onInit();
    _startAutoSlide();
  }

  @override
  void onClose() {
    _timer?.cancel();
    pageController.dispose();
    super.onClose();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
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
