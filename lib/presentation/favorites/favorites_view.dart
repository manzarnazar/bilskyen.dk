import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/favorites_controller.dart';
import '../../main.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_card_shimmer.dart';

class FavoritesView extends StatelessWidget {
  const FavoritesView({super.key});

  static bool _isLoggedIn() {
    try {
      final token = appStorage.read('token');
      return token != null && token.toString().isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      // Not logged in: show login CTA in the tab
      if (!_isLoggedIn()) {
        return Scaffold(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          appBar: AppBar(
            backgroundColor: isDark
                ? AppColors.backgroundDark
                : AppColors.backgroundLight,
            surfaceTintColor: Colors.transparent,
            scrolledUnderElevation: 0,
            foregroundColor: AppColors.primary,
            elevation: 0,
            title: Text(
              l10n.navFavorites,
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: SafeArea(
            child: _buildLoginRequiredBody(context, isDark),
          ),
        );
      }

      final controller = Get.put(FavoritesController());

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
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
              l10n.favoritesCount(controller.vehicles.length),
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
              tooltip: l10n.arrangeTooltip,
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
                        child: Text(l10n.retry),
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
                      l10n.noFavoritesYet,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      l10n.startAddingFavorites,
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
                    checkFavoriteOnLoad: false,
                  ));
                },
              ),
            );
          }),
        ),
      );
    });
  }

  Widget _buildLoginRequiredBody(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isDark ? 'assets/images/logo_white.png' : 'assets/images/logo.png',
              height: 64,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 24),
            Text(
              l10n.signInToViewFavorites,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.signInToViewFavoritesSubtitle,
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Get.toNamed('/login'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(l10n.logIn),
            ),
          ],
        ),
      ),
    );
  }
}

