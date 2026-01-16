import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../services/mock_lookup_service.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late DraggableScrollableController _draggableController;
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    _draggableController.addListener(() {
      if (_draggableController.size <= 0.15) {
        Navigator.of(context).pop();
      }
    });
    
    // Initialize price controllers with current values
    final vehicleController = Get.find<VehicleController>();
    _minPriceController.text = vehicleController.minPrice.value > 0 
        ? vehicleController.minPrice.value.toString() 
        : '';
    _maxPriceController.text = vehicleController.maxPrice.value > 0 
        ? vehicleController.maxPrice.value.toString() 
        : '';
  }

  @override
  void dispose() {
    _draggableController.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return DraggableScrollableSheet(
        controller: _draggableController,
        initialChildSize: 0.9,
        minChildSize: 0.3,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.gray600 : AppColors.gray400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.tune_rounded,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'Filters',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () => controller.clearAllFilters(),
                        icon: Icon(
                          Icons.refresh_rounded,
                          size: 18,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                        label: Text(
                          'Clear All',
                          style: TextStyle(
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Basic Filters
                        _buildSectionHeading('Basic Filters', Icons.filter_list_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildPriceRangeSection(controller, isDark),
                        const SizedBox(height: 24),
                        _buildMakeSection(controller, isDark),
                        const SizedBox(height: 24),
                        _buildModelYearRangeSection(controller, isDark),
                        const SizedBox(height: 24),
                        _buildMileageRangeSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Listing Details
                        _buildSectionHeading('Listing Details', Icons.description_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildListingTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildCategorySection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildPriceTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildConditionSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Vehicle Specs
                        _buildSectionHeading('Vehicle Specs', Icons.directions_car_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildBodyTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildFuelTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildGearTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildDriveWheelsSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Registration
                        _buildSectionHeading('Registration', Icons.assignment_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildFirstRegistrationYearSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildSellerTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildSalesTypeSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildSellerDistanceSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Performance
                        _buildSectionHeading('Performance', Icons.speed_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildPerformanceSection(controller, isDark),
                        const SizedBox(height: 20),
                        _buildBatteryChargingSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Economy & Environment
                        _buildSectionHeading('Economy & Environment', Icons.eco_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildEconomyEnvironmentSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Physical Details
                        _buildSectionHeading('Physical Details', Icons.straighten_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildPhysicalDetailsSection(controller, isDark),
                        const SizedBox(height: 32),
                        _buildDivider(isDark),
                        const SizedBox(height: 32),
                        // Equipment
                        _buildSectionHeading('Equipment', Icons.checklist_rounded, isDark),
                        const SizedBox(height: 20),
                        _buildEquipmentSection(controller, isDark),
                        const SizedBox(height: 100), // Space for bottom buttons
                      ],
                    ),
                  ),
                ),
                // Bottom Buttons
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    border: Border(
                      top: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => controller.clearAllFilters(),
                            icon: const Icon(Icons.refresh_rounded, size: 20),
                            label: const Text(
                              'Reset',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: isDark
                                    ? AppColors.borderDark
                                    : AppColors.borderLight,
                                width: 1.5,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              controller.applyFilters();
                              Get.back();
                            },
                            icon: const Icon(Icons.check_rounded, size: 20),
                            label: const Text(
                              'Apply Filters',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: isDark ? Colors.white : Colors.black,
                              foregroundColor: isDark ? Colors.black : Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
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
          );
        },
      );
    });
  }

  Widget _buildDivider(bool isDark) {
    return Divider(
      height: 1,
      thickness: 1,
      color: isDark ? AppColors.borderDark : AppColors.borderLight,
    );
  }

  Widget _buildSectionHeading(String title, IconData icon, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.gray800
                : AppColors.gray200,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 20,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textDark : AppColors.textLight,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(VehicleController controller, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray900 : AppColors.gray200,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.attach_money_rounded,
                size: 18,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
              const SizedBox(width: 8),
              Text(
                'Price Range',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildPriceInput(
                  label: 'Min',
                  controller: _minPriceController,
                  isDark: isDark,
                  onChanged: (value) {
                    if (value != null && value >= 0) {
                      controller.setPriceRange(
                        value,
                        controller.maxPrice.value,
                      );
                    }
                  },
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 24,
                height: 1,
                color: isDark ? AppColors.gray600 : AppColors.gray300,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildPriceInput(
                  label: 'Max',
                  controller: _maxPriceController,
                  isDark: isDark,
                  onChanged: (value) {
                    if (value != null && value >= 0) {
                      controller.setPriceRange(
                        controller.minPrice.value,
                        value,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // Sync text fields when slider changes
          Obx(() {
            final minPrice = controller.minPrice.value;
            final maxPrice = controller.maxPrice.value;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                if (_minPriceController.text != minPrice.toString()) {
                  _minPriceController.text = minPrice > 0 ? minPrice.toString() : '';
                }
                if (_maxPriceController.text != maxPrice.toString()) {
                  _maxPriceController.text = maxPrice > 0 ? maxPrice.toString() : '';
                }
              }
            });
            return const SizedBox.shrink();
          }),
          const SizedBox(height: 16),
          Obx(
            () => RangeSlider(
              values: RangeValues(
                controller.minPriceDouble,
                controller.maxPriceDouble,
              ),
              min: 0,
              max: 5000000,
              divisions: 100,
              activeColor: isDark ? Colors.white : Colors.black,
              inactiveColor: isDark ? AppColors.gray700 : AppColors.gray300,
              onChanged: (values) {
                controller.setPriceRangeDouble(values.start, values.end);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceInput({
    required String label,
    required TextEditingController controller,
    required bool isDark,
    required Function(int?) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: isDark ? AppColors.textDark : AppColors.textLight,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          fontSize: 12,
        ),
        hintText: '0',
        hintStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
        ),
        prefixText: 'kr. ',
        prefixStyle: TextStyle(
          color: isDark ? AppColors.textDark : AppColors.textLight,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        filled: true,
        fillColor: isDark ? AppColors.backgroundDark : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
      onChanged: (text) {
        final parsedValue = int.tryParse(text);
        if (parsedValue != null && parsedValue >= 0) {
          onChanged(parsedValue);
        } else if (text.isEmpty) {
          onChanged(0);
        }
      },
    );
  }

  Widget _buildMakeSection(VehicleController controller, bool isDark) {
    final brands = MockLookupService.getBrands();
    final popularBrands = MockLookupService.getPopularBrands();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.branding_watermark_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Make',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.gray900 : AppColors.gray200,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Obx(() => SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Row(
                  children: [
                    Icon(
                      Icons.star_rounded,
                      size: 18,
                      color: controller.showPopularBrandsOnly.value
                          ? Colors.amber
                          : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Popular brands only',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
                value: controller.showPopularBrandsOnly.value,
                onChanged: (value) => controller.setPopularBrandsOnly(value),
                activeColor: isDark ? Colors.white : Colors.black,
              )),
        ),
        const SizedBox(height: 16),
        Obx(() {
          final displayBrands = controller.showPopularBrandsOnly.value
              ? popularBrands
              : brands;
          return Wrap(
            spacing: 10,
            runSpacing: 10,
            children: displayBrands.map((brand) {
              final isSelected = controller.selectedBrandIds.contains(brand.id);
              return _buildFilterChip(
                label: brand.name,
                isSelected: isSelected,
                onTap: () {
                  controller.toggleBrand(brand.id);
                },
                isDark: isDark,
              );
            }).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildModelYearRangeSection(VehicleController controller, bool isDark) {
    final currentYear = DateTime.now().year;
    final minYear = 2000;
    final maxYear = currentYear;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Model Year',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                label: 'From',
                hint: minYear.toString(),
                isDark: isDark,
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year >= minYear && year <= maxYear) {
                    controller.setModelYearRange(
                      year,
                      controller.maxModelYear.value > 0
                          ? controller.maxModelYear.value
                          : maxYear,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 1,
              color: isDark ? AppColors.gray600 : AppColors.gray300,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberInput(
                label: 'To',
                hint: maxYear.toString(),
                isDark: isDark,
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year >= minYear && year <= maxYear) {
                    controller.setModelYearRange(
                      controller.minModelYear.value > 0
                          ? controller.minModelYear.value
                          : minYear,
                      year,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMileageRangeSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.speed_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Mileage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                label: 'Min (km)',
                hint: '0',
                isDark: isDark,
                onChanged: (value) {
                  final mileage = int.tryParse(value);
                  if (mileage != null && mileage >= 0) {
                    controller.setMileageRange(
                      mileage,
                      controller.maxMileage.value > 0
                          ? controller.maxMileage.value
                          : 1000000,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 1,
              color: isDark ? AppColors.gray600 : AppColors.gray300,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberInput(
                label: 'Max (km)',
                hint: '1,000,000',
                isDark: isDark,
                onChanged: (value) {
                  final mileage = int.tryParse(value);
                  if (mileage != null && mileage >= 0) {
                    controller.setMileageRange(
                      controller.minMileage.value > 0
                          ? controller.minMileage.value
                          : 0,
                      mileage,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNumberInput({
    required String label,
    required String hint,
    required bool isDark,
    required Function(String) onChanged,
  }) {
    return TextField(
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: isDark ? AppColors.textDark : AppColors.textLight,
        fontSize: 16,
      ),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
        ),
        filled: true,
        fillColor: isDark ? AppColors.backgroundDark : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          fontSize: 14,
        ),
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildListingTypeSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getListingTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.sell_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Listing Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.listingType.value == option;
                return _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setListingType(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildCategorySection(VehicleController controller, bool isDark) {
    final categories = MockLookupService.getCategories();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.category_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: categories.map((category) {
                final isSelected =
                    controller.selectedCategoryId.value == category.id;
                return _buildFilterChip(
                  label: category.name,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setCategoryFilter(isSelected ? null : category.id);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildPriceTypeSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getPriceTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.price_check_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Price Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.priceType.value == option;
                return _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setPriceType(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildConditionSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getConditions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.verified_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Condition',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.condition.value == option;
                return _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setCondition(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildBodyTypeSection(VehicleController controller, bool isDark) {
    final bodyTypes = MockLookupService.getBodyTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.directions_car_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Body Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: bodyTypes.map((bodyType) {
                final isSelected =
                    controller.selectedBodyTypeId.value == bodyType.id;
                return _buildFilterChip(
                  label: bodyType.name,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setBodyTypeFilter(isSelected ? null : bodyType.id);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildFuelTypeSection(VehicleController controller, bool isDark) {
    final fuelTypes = MockLookupService.getFuelTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.local_gas_station_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Fuel Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: fuelTypes.map((fuelType) {
                final isSelected =
                    controller.selectedFuelTypeId.value == fuelType.id;
                return _buildFilterChip(
                  label: fuelType.name,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setFuelTypeFilter(isSelected ? null : fuelType.id);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildGearTypeSection(VehicleController controller, bool isDark) {
    final options = ['manual', 'automatic'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.settings_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Gear Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.selectedTransmission.value == option;
                return _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setTransmissionFilter(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildDriveWheelsSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getDriveWheels();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.all_inclusive_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Drive Wheels',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.driveWheels.value == option;
                return _buildFilterChip(
                  label: option.toUpperCase(),
                  isSelected: isSelected,
                  onTap: () {
                    controller.setDriveWheels(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildFirstRegistrationYearSection(
      VehicleController controller, bool isDark) {
    final currentYear = DateTime.now().year;
    final minYear = 1990;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.event_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'First Registration Year',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                label: 'From',
                hint: minYear.toString(),
                isDark: isDark,
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year >= minYear && year <= currentYear) {
                    controller.setFirstRegistrationYearRange(
                      year,
                      controller.firstRegistrationYearTo.value > 0
                          ? controller.firstRegistrationYearTo.value
                          : currentYear,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 24,
              height: 1,
              color: isDark ? AppColors.gray600 : AppColors.gray300,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildNumberInput(
                label: 'To',
                hint: currentYear.toString(),
                isDark: isDark,
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year >= minYear && year <= currentYear) {
                    controller.setFirstRegistrationYearRange(
                      controller.firstRegistrationYearFrom.value > 0
                          ? controller.firstRegistrationYearFrom.value
                          : minYear,
                      year,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSellerTypeSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getSellerTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.person_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Seller Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.sellerType.value == option;
                return _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setSellerType(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildSalesTypeSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getSalesTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.shopping_cart_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Sales Type',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: options.map((option) {
                final isSelected = controller.salesType.value == option;
                return _buildFilterChip(
                  label: option,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setSalesType(isSelected ? null : option);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildSellerDistanceSection(
      VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.location_on_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Seller Distance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Maximum distance (km)',
          hint: 'Enter distance',
          isDark: isDark,
          onChanged: (value) {
            final distance = int.tryParse(value);
            controller.setSellerDistance(distance);
          },
        ),
      ],
    );
  }

  Widget _buildPerformanceSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.speed_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Performance',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Min Horsepower (HP)',
          hint: 'Enter minimum HP',
          isDark: isDark,
          onChanged: (value) {
            final hp = int.tryParse(value);
            controller.setPerformanceFilters(
              hp,
              controller.accelerationMax.value,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Max Acceleration (seconds)',
          hint: 'Enter max acceleration',
          isDark: isDark,
          onChanged: (value) {
            final accel = double.tryParse(value);
            controller.setPerformanceFilters(
              controller.horsepowerMin.value,
              accel,
            );
          },
        ),
      ],
    );
  }

  Widget _buildBatteryChargingSection(
      VehicleController controller, bool isDark) {
    final chargingTypes = MockLookupService.getChargingTypes();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.battery_charging_full_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              'Battery & Charging (EV)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Min Battery Capacity (kWh)',
          hint: 'Enter minimum capacity',
          isDark: isDark,
          onChanged: (value) {
            final capacity = int.tryParse(value);
            controller.setBatteryChargingFilters(
              capacity,
              controller.rangeKmMin.value,
              controller.chargingType.value,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Min Range (km)',
          hint: 'Enter minimum range',
          isDark: isDark,
          onChanged: (value) {
            final range = int.tryParse(value);
            controller.setBatteryChargingFilters(
              controller.batteryCapacityMin.value,
              range,
              controller.chargingType.value,
            );
          },
        ),
        const SizedBox(height: 16),
        Text(
          'Charging Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: chargingTypes.map((type) {
                final isSelected = controller.chargingType.value == type;
                return _buildFilterChip(
                  label: type,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setBatteryChargingFilters(
                      controller.batteryCapacityMin.value,
                      controller.rangeKmMin.value,
                      isSelected ? null : type,
                    );
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildEconomyEnvironmentSection(
      VehicleController controller, bool isDark) {
    final euroNorms = MockLookupService.getEuroNorms();
    final energyLabels = MockLookupService.getEnergyLabels();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberInput(
          label: 'Max CO2 (g/km)',
          hint: 'Enter maximum CO2',
          isDark: isDark,
          onChanged: (value) {
            final co2 = int.tryParse(value);
            controller.setEconomyFilters(
              co2,
              controller.euroNorm.value,
              controller.ownershipTaxMax.value,
              controller.energyLabel.value,
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Euro Norm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: euroNorms.map((norm) {
                final isSelected = controller.euroNorm.value == norm;
                return _buildFilterChip(
                  label: norm,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setEconomyFilters(
                      controller.co2Max.value,
                      isSelected ? null : norm,
                      controller.ownershipTaxMax.value,
                      controller.energyLabel.value,
                    );
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
        const SizedBox(height: 20),
        _buildNumberInput(
          label: 'Max Ownership Tax (DKK)',
          hint: 'Enter maximum tax',
          isDark: isDark,
          onChanged: (value) {
            final tax = int.tryParse(value);
            controller.setEconomyFilters(
              controller.co2Max.value,
              controller.euroNorm.value,
              tax,
              controller.energyLabel.value,
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          'Energy Label',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: energyLabels.map((label) {
                final isSelected = controller.energyLabel.value == label;
                return _buildFilterChip(
                  label: label,
                  isSelected: isSelected,
                  onTap: () {
                    controller.setEconomyFilters(
                      controller.co2Max.value,
                      controller.euroNorm.value,
                      controller.ownershipTaxMax.value,
                      isSelected ? null : label,
                    );
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }

  Widget _buildPhysicalDetailsSection(
      VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberInput(
          label: 'Min Doors',
          hint: 'Enter minimum doors',
          isDark: isDark,
          onChanged: (value) {
            final doors = int.tryParse(value);
            controller.setPhysicalDetailsFilters(
              doors,
              controller.seatsMin.value,
              controller.trunkVolumeMin.value,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Min Seats',
          hint: 'Enter minimum seats',
          isDark: isDark,
          onChanged: (value) {
            final seats = int.tryParse(value);
            controller.setPhysicalDetailsFilters(
              controller.doorsMin.value,
              seats,
              controller.trunkVolumeMin.value,
            );
          },
        ),
        const SizedBox(height: 16),
        _buildNumberInput(
          label: 'Min Trunk Volume (L)',
          hint: 'Enter minimum volume',
          isDark: isDark,
          onChanged: (value) {
            final volume = int.tryParse(value);
            controller.setPhysicalDetailsFilters(
              controller.doorsMin.value,
              controller.seatsMin.value,
              volume,
            );
          },
        ),
      ],
    );
  }

  Widget _buildEquipmentSection(VehicleController controller, bool isDark) {
    final equipment = MockLookupService.getEquipment();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(() => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: equipment.map((eq) {
                final isSelected =
                    controller.selectedEquipmentIds.contains(eq.id);
                return _buildFilterChip(
                  label: eq.name,
                  isSelected: isSelected,
                  onTap: () {
                    controller.toggleEquipment(eq.id);
                  },
                  isDark: isDark,
                );
              }).toList(),
            )),
      ],
    );
  }


  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isDark,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? AppColors.gray800 : AppColors.gray200),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isSelected) ...[
              Icon(
                Icons.check_rounded,
                size: 18,
                color: isDark ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected
                    ? (isDark ? Colors.black : Colors.white)
                    : (isDark ? AppColors.textDark : AppColors.textLight),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
