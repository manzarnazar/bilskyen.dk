import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../widgets/car_card.dart';
import '../widgets/bottom_nav_bar.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      // For now, we'll show all vehicles as favorites (mock data)
      // In a real app, this would filter vehicles by favorite status
      final favoriteVehicles = controller.vehicles;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text(
            'Favorites',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Header Info
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.backgroundDark
                      : AppColors.backgroundLight,
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Saved Vehicles',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.gray800
                            : AppColors.gray200,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${favoriteVehicles.length}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Favorites List
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (favoriteVehicles.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.favorite_border,
                            size: 64,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No favorites yet',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start saving vehicles you like',
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              Get.offNamed('/home');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark
                                  ? Colors.white
                                  : Colors.black,
                              foregroundColor: isDark
                                  ? Colors.black
                                  : Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Browse Vehicles'),
                          ),
                        ],
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: favoriteVehicles.length,
                    itemBuilder: (context, index) {
                      return CarCard(vehicle: favoriteVehicles[index]);
                    },
                  );
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 1,
          onTap: _handleNavTap,
        ),
      );
    });
  }

  static void _handleNavTap(int index) {
    switch (index) {
      case 0:
        Get.offNamed('/home');
        break;
      case 1:
        // Already on favorites
        break;
      case 2:
        Get.snackbar(
          'Sell',
          'Sell your car page coming soon',
          snackPosition: SnackPosition.TOP,
        );
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

