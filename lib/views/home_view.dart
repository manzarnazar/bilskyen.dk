import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../widgets/featured_vehicle_card.dart';
import '../widgets/recommended_cars_list.dart';
import '../widgets/sell_your_car_banner.dart';
import '../widgets/bottom_nav_bar.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VehicleController());

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Search Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/search');
                  },
                  child: AbsorbPointer(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'What are you looking for?',
                        hintStyle: TextStyle(
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                          fontSize: 16,
                        ),
                        filled: true,
                        fillColor: isDark ? AppColors.cardDark : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.gray400,
                            width: 1,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // Main Content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      // Featured Vehicle Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Featured Vehicle',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.textDark
                                    : AppColors.textLight,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                // Navigate to featured vehicle details
                                if (controller.featuredVehicle.value != null) {
                                  // Navigate to car details
                                }
                              },
                              child: Text(
                                'View Details',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Featured Vehicle Card
                      Obx(() {
                        final featuredVehicle = controller.featuredVehicle.value;
                        if (featuredVehicle != null) {
                          return FeaturedVehicleCard(vehicle: featuredVehicle);
                        }
                        return const SizedBox.shrink();
                      }),
                      const SizedBox(height: 8),
                      // Sponsored Text
                      Center(
                        child: Text(
                          'Sponsored by RevoLot Premium',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Sell Your Car Banner
                      const SellYourCarBanner(),
                      const SizedBox(height: 24),
                      // Recommended Private Cars Section
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Recently Added Cars',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Recommended Cars List
                      RecommendedCarsList(
                        vehicles: controller.recommendedVehicles,
                      ),
                      const SizedBox(height: 24),
                      // REVOLOT SECURE Text
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Text(
                            'REVOLOT SECURE',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.2,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 0,
          onTap: _handleNavTap,
        ),
      );
    });
  }

  static void _handleNavTap(int index) {
    switch (index) {
      case 0:
        // Already on home
        break;
      case 1:
        Get.toNamed('/favorites');
        break;
      case 2:
        Get.toNamed('/search');
        break;
      case 3:
        Get.toNamed('/messages');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }
}
