import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/vehicle_result_controller.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_card_shimmer.dart';

class VehicleResultView extends StatelessWidget {
  const VehicleResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(VehicleResultController());
    final l10n = AppLocalizations.of(context)!;

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
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            color: AppColors.primary,
            onPressed: () => Get.back(),
          ),
          title: Obx(() {
            if (controller.isLoading.value || controller.errorMessage.value.isNotEmpty) {
              return const SizedBox.shrink();
            }
            return Text(
              l10n.advertisementsCount(controller.vehicles.length),
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
                        onPressed: () => controller.fetchVehicles(),
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
                      Icons.search_off,
                      size: 64,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No vehicles found',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              );
            }

            // Success state - List of vehicles
            return RefreshIndicator(
              onRefresh: () => controller.refreshVehicles(),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: controller.vehicles.length,
                itemBuilder: (context, index) {
                  final vehicle = controller.vehicles[index];
                  return Obx(() => InkWell(
                    onTap: () => Get.toNamed('/vehicle-detail/${vehicle.id}'),
                    borderRadius: BorderRadius.circular(12),
                    child: VehicleCard(
                      vehicle: vehicle,
                      isDark: isDark,
                      isHorizontalLayout: controller.isHorizontalLayout.value,
                      checkFavoriteOnLoad: false,
                    ),
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
