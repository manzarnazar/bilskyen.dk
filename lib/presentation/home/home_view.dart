import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/app_controller/main_navigation_controller.dart';
import 'featured_vehicle_card.dart';
import 'sell_your_car_banner.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());
    final isDark = Theme.of(context).brightness == Brightness.dark;

      return SafeArea(
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
                  Get.find<MainNavigationController>().changeTab(2, focusSearch: true); // Switch to search tab and focus
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
                          
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Featured Vehicle Section with Loading/Error States
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const SizedBox(
                          height: 280,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      
                      if (controller.errorMessage.value.isNotEmpty) {
                        return SizedBox(
                          height: 280,
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                controller.errorMessage.value,
                                style: TextStyle(
                                  color: isDark
                                      ? AppColors.textDark
                                      : AppColors.textLight,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        );
                      }
                      
                      if (controller.featuredVehicles.isEmpty) {
                        return const SizedBox(
                          height: 280,
                          child: Center(
                            child: Text('No featured vehicles available'),
                          ),
                        );
                      }
                      
                      return Column(
                        children: [
                          // Featured Vehicle Slider
                          SizedBox(
                            height: 280,
                            child: PageView.builder(
                              controller: controller.pageController,
                              onPageChanged: controller.onPageChanged,
                              itemCount: controller.featuredVehicles.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8),
                                  child: FeaturedVehicleCard(
                                    vehicle: controller.featuredVehicles[index],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 12),
                          // Page Indicators
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              controller.featuredVehicles.length,
                              (index) => Container(
                                width: 8,
                                height: 8,
                                margin: const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: controller.currentPage.value == index
                                      ? (isDark ? Colors.white : Colors.black)
                                      : (isDark
                                          ? AppColors.mutedDark
                                          : AppColors.mutedLight),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                    const SizedBox(height: 8),
                    // Sponsored Text
                    Center(
                      child: Text(
                        'Sponsored by Bilskyen Premium',
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
                   
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  }
}
