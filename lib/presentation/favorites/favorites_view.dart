import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_card_shimmer.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(FavoritesController());

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          foregroundColor: AppColors.primary,
          iconTheme: IconThemeData(
            color: AppColors.primary,
          ),
          elevation: 0,
          automaticallyImplyLeading: Navigator.canPop(context), // Show back button only if navigated
          title: Obx(() {
            if (controller.isLoading.value || controller.errorMessage.value.isNotEmpty) {
              return const SizedBox.shrink();
            }
            return Text(
              '${controller.vehicles.length} Favorites',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            );
          }),
          actions: [
            IconButton(
              icon: Obx(() => Icon(
                controller.isHorizontalLayout.value 
                    ? Icons.view_module 
                    : Icons.view_list,
              )),
              color: AppColors.primary,
              onPressed: () {
                controller.toggleLayout();
              },
              tooltip: 'Arrange',
            ),
          ],
        ),
        body: SafeArea(
          child: Obx(() {
            // Loading state - Show shimmer cards
            if (controller.isLoading.value) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: 4,
                itemBuilder: (context, index) {
                  return Obx(() => VehicleCardShimmer(
                    isDark: isDark,
                    isHorizontalLayout: controller.isHorizontalLayout.value,
                  ));
                },
              );
            }

            // Error state
            if (controller.errorMessage.value.isNotEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => controller.fetchFavorites(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.primaryForeground,
                        ),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Empty state
            if (controller.vehicles.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.favorite_border,
                      size: 64,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No favorites yet',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start adding vehicles to your favorites',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Success state - List of vehicles
            return RefreshIndicator(
              onRefresh: () => controller.refreshFavorites(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  return Obx(() => VehicleCard(
                    vehicle: controller.vehicles[index],
                    isDark: isDark,
                    isHorizontalLayout: controller.isHorizontalLayout.value,
                  ));
                },
              ),
            );
          }),
        ),
      );
    });
  }
}

