import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/search_controller.dart';
import '../../controllers/vehicle_result_controller.dart';
import '../../services/constants_service.dart';
import '../widgets/vehicle_card.dart';
import '../widgets/vehicle_card_shimmer.dart';

class VehicleResultView extends StatelessWidget {
  const VehicleResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(VehicleResultController());
    final searchController = Get.isRegistered<SearchViewController>()
        ? Get.find<SearchViewController>()
        : Get.put(SearchViewController(), permanent: true);
    final constantsService = Get.find<ConstantsService>();
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final sortOptions = _buildSortOptions(
        l10n,
        constantsService.getConstants()?.vehicleSortKeys ?? const [],
      );

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
            if (controller.isLoading.value ||
                controller.errorMessage.value.isNotEmpty) {
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
              icon: const Icon(Icons.swap_vert),
              color: AppColors.primary,
              onPressed: () => _showSortBottomSheet(
                context: context,
                l10n: l10n,
                isDark: isDark,
                sortOptions: sortOptions,
                selectedSort: searchController.sort.value,
                onSelected: (sortValue) async {
                  searchController.sort.value = sortValue;
                  await controller.fetchVehicles();
                },
              ),
              tooltip: l10n.sortTooltip,
            ),
            IconButton(
              icon: Obx(
                () => Icon(
                  controller.isHorizontalLayout.value
                      ? Icons.view_module
                      : Icons.view_list,
                ),
              ),
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
                  return Obx(
                    () => VehicleCardShimmer(
                      isDark: isDark,
                      isHorizontalLayout: controller.isHorizontalLayout.value,
                    ),
                  );
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
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        controller.errorMessage.value,
                        style: TextStyle(
                          fontSize: 16,
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
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
                      Icons.search_off,
                      size: 64,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.noResultsFound,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
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
                  return Obx(
                    () => InkWell(
                      onTap: () => Get.toNamed('/vehicle-detail/${vehicle.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: VehicleCard(
                        vehicle: vehicle,
                        isDark: isDark,
                        isHorizontalLayout: controller.isHorizontalLayout.value,
                        checkFavoriteOnLoad: false,
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      );
    });
  }

  static List<_SortOption> _buildSortOptions(
    AppLocalizations l10n,
    List<String> backendSortKeys,
  ) {
    final options = <_SortOption>[
      _SortOption(value: null, label: l10n.sortDefault),
    ];

    final seen = <String>{};
    for (final raw in backendSortKeys) {
      final key = raw.trim();
      if (key.isEmpty || seen.contains(key)) continue;
      seen.add(key);
      options.add(_SortOption(value: key, label: _sortLabelForKey(l10n, key)));
    }

    // Fallback aliases for older API responses that omit `vehicle_sort_keys`.
    if (options.length == 1) {
      for (final key in _legacyWebsiteSortKeys) {
        options.add(
          _SortOption(value: key, label: _sortLabelForKey(l10n, key)),
        );
      }
    }

    return options;
  }

  static const List<String> _legacyWebsiteSortKeys = <String>[
    'best_match',
    'standard',
    'price_asc',
    'price_desc',
    'date_desc',
    'date_asc',
    'year_desc',
    'year_asc',
    'mileage_desc',
    'mileage_asc',
    'fuel_efficiency_desc',
    'fuel_efficiency_asc',
    'range_desc',
    'range_asc',
    'battery_desc',
    'battery_asc',
    'brand_asc',
    'brand_desc',
    'engine_power_desc',
    'engine_power_asc',
    'towing_weight_desc',
    'towing_weight_asc',
    'top_speed_desc',
    'top_speed_asc',
    'ownership_tax_desc',
    'ownership_tax_asc',
    'first_reg_desc',
    'first_reg_asc',
    'distance_desc',
    'distance_asc',
  ];

  static String _sortLabelForKey(AppLocalizations l10n, String key) {
    switch (key) {
      case 'best_match':
        return l10n.sortBestMatch;
      case 'standard':
        return l10n.sortStandard;
      case 'distance_desc':
        return l10n.sortDistanceDesc;
      case 'distance_asc':
        return l10n.sortDistanceAsc;
    }

    final match = RegExp(r'^(.+)_(asc|desc)$').firstMatch(key);
    if (match == null) {
      return _titleCase(key.replaceAll('_', ' '));
    }

    final column = match.group(1) ?? '';
    final direction = match.group(2) ?? '';
    final columnLabel = _columnLabel(l10n, column);
    final directionLabel = direction == 'asc'
        ? l10n.sortDirectionAsc
        : l10n.sortDirectionDesc;
    return '$columnLabel - $directionLabel';
  }

  static String _columnLabel(AppLocalizations l10n, String column) {
    switch (column) {
      case 'created_at':
        return l10n.sortColumnCreatedAt;
      case 'published_at':
        return l10n.sortColumnPublishedAt;
      case 'price':
        return l10n.sortColumnPrice;
      case 'model_year':
        return l10n.sortColumnModelYear;
      case 'km_driven':
        return l10n.sortColumnMileage;
      case 'km_per_liter':
        return l10n.sortColumnKmPerLiter;
      case 'fuel_efficiency':
        return l10n.sortColumnFuelEfficiency;
      case 'range_km':
        return l10n.sortColumnRange;
      case 'battery_capacity':
        return l10n.sortColumnBatteryCapacity;
      case 'brand_id':
        return l10n.sortColumnBrand;
      case 'engine_power_hp':
      case 'engine_power_kw':
        return l10n.sortColumnEnginePower;
      case 'max_speed':
        return l10n.sortColumnTopSpeed;
      case 'towing_weight':
        return l10n.sortColumnTowingWeight;
      case 'calculated_ownership_tax':
        return l10n.sortColumnOwnershipTax;
      case 'first_registration_date':
        return l10n.sortColumnFirstRegistration;
      case 'first_registration_year':
        return l10n.sortColumnFirstRegistrationYear;
      default:
        return _titleCase(column.replaceAll('_', ' '));
    }
  }

  static String _titleCase(String value) {
    final parts = value.split(RegExp(r'\s+')).where((part) => part.isNotEmpty);
    return parts
        .map((part) => part[0].toUpperCase() + part.substring(1))
        .join(' ');
  }

  Future<void> _showSortBottomSheet({
    required BuildContext context,
    required AppLocalizations l10n,
    required bool isDark,
    required List<_SortOption> sortOptions,
    required String? selectedSort,
    required Future<void> Function(String? sortValue) onSelected,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(
                  l10n.sortBy,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: sortOptions.length,
                  itemBuilder: (context, index) {
                    final option = sortOptions[index];
                    final isSelected =
                        option.value == selectedSort ||
                        (option.value == null &&
                            (selectedSort == null || selectedSort.isEmpty));
                    return ListTile(
                      title: Text(option.label),
                      trailing: isSelected
                          ? Icon(Icons.check, color: AppColors.primary)
                          : null,
                      onTap: () async {
                        Navigator.of(context).pop();
                        await onSelected(option.value);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SortOption {
  const _SortOption({required this.value, required this.label});

  final String? value;
  final String label;
}
