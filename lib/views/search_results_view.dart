import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../widgets/car_card.dart';
import '../widgets/sort_bottom_sheet.dart';
import '../widgets/bottom_nav_bar.dart';

class SearchResultsView extends StatefulWidget {
  const SearchResultsView({super.key});

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_rounded,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            onPressed: () => Get.back(),
          ),
          title: Obx(() {
            final count = controller.filteredVehicles.length;
            return Row(
              children: [
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'advertisements',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                ),
              ],
            );
          }),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Obx(() {
                final sortLabel = _getSortLabel(controller.selectedSort.value);
                return IconButton(
                  icon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.sort,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        sortLabel,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      isDismissible: true,
                      enableDrag: true,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) => const SortBottomSheet(),
                    );
                  },
                );
              }),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final displayedVehicles = controller.filteredVehicles;

          if (displayedVehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search_off,
                    size: 64,
                    color: isDark
                        ? AppColors.mutedDark
                        : AppColors.mutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No vehicles found',
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
                    'Try adjusting your search or filters',
                    style: TextStyle(
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: displayedVehicles.length,
            itemBuilder: (context, index) {
              return CarCard(vehicle: displayedVehicles[index]);
            },
          );
        }),
        bottomNavigationBar: const BottomNavBar(
          currentIndex: 2,
          onTap: _handleNavTap,
        ),
      );
    });
  }

  static void _handleNavTap(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed('/home');
        break;
      case 1:
        Get.toNamed('/favorites');
        break;
      case 2:
        // Already on search results
        break;
      case 3:
        Get.toNamed('/messages');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }

  static String _getSortLabel(String sortValue) {
    switch (sortValue) {
      case 'price_asc':
        return 'Price ↑';
      case 'price_desc':
        return 'Price ↓';
      case 'date_desc':
        return 'Date ↓';
      case 'date_asc':
        return 'Date ↑';
      case 'year_desc':
        return 'Year ↓';
      case 'year_asc':
        return 'Year ↑';
      case 'mileage_desc':
        return 'Mileage ↓';
      case 'mileage_asc':
        return 'Mileage ↑';
      case 'fuel_efficiency_desc':
        return 'Km/l ↓';
      case 'fuel_efficiency_asc':
        return 'Km/l ↑';
      case 'range_desc':
        return 'Range ↓';
      default:
        return 'Sort';
    }
  }
}

