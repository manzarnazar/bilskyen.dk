import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../services/mock_lookup_service.dart';
import '../views/search_results_view.dart';
import '../widgets/bottom_nav_bar.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _minPriceController = TextEditingController();
  final TextEditingController _maxPriceController = TextEditingController();
  final TextEditingController _minModelYearController = TextEditingController();
  final TextEditingController _maxModelYearController = TextEditingController();
  final TextEditingController _minMileageController = TextEditingController();
  final TextEditingController _maxMileageController = TextEditingController();
  final TextEditingController _firstRegYearFromController = TextEditingController();
  final TextEditingController _firstRegYearToController = TextEditingController();
  final TextEditingController _sellerDistanceController = TextEditingController();
  final TextEditingController _horsepowerMinController = TextEditingController();
  final TextEditingController _accelerationMaxController = TextEditingController();
  final TextEditingController _batteryCapacityMinController = TextEditingController();
  final TextEditingController _rangeKmMinController = TextEditingController();
  final TextEditingController _co2MaxController = TextEditingController();
  final TextEditingController _ownershipTaxMinController = TextEditingController();
  final TextEditingController _ownershipTaxMaxController = TextEditingController();
  final TextEditingController _doorsMinController = TextEditingController();
  final TextEditingController _seatsMinController = TextEditingController();
  final TextEditingController _trunkVolumeMinController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final controller = Get.find<VehicleController>();
    _searchController.text = controller.searchQuery.value;
    // Initialize price controllers
    _minPriceController.text = controller.minPrice.value > 0 
        ? controller.minPrice.value.toString() 
        : '';
    _maxPriceController.text = controller.maxPrice.value > 0 
        ? controller.maxPrice.value.toString() 
        : '';
    // Auto-focus search field when screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _minPriceController.dispose();
    _maxPriceController.dispose();
    _minModelYearController.dispose();
    _maxModelYearController.dispose();
    _minMileageController.dispose();
    _maxMileageController.dispose();
    _firstRegYearFromController.dispose();
    _firstRegYearToController.dispose();
    _sellerDistanceController.dispose();
    _horsepowerMinController.dispose();
    _accelerationMaxController.dispose();
    _batteryCapacityMinController.dispose();
    _rangeKmMinController.dispose();
    _co2MaxController.dispose();
    _ownershipTaxMinController.dispose();
    _ownershipTaxMaxController.dispose();
    _doorsMinController.dispose();
    _seatsMinController.dispose();
    _trunkVolumeMinController.dispose();
    super.dispose();
  }

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
          title: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            autofocus: true,
            onChanged: (value) => controller.onSearchChanged(value),
            style: TextStyle(
              color: isDark ? AppColors.textDark : AppColors.textLight,
              fontSize: 16,
            ),
            decoration: InputDecoration(
              hintText: 'Search by brand, model...',
              hintStyle: TextStyle(
                color: isDark
                    ? AppColors.mutedDark
                    : AppColors.mutedLight,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
          ),
          actions: [
            if (_searchController.text.isNotEmpty)
              IconButton(
                icon: Icon(
                  Icons.clear_rounded,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
                onPressed: () {
                  _searchController.clear();
                  controller.onSearchChanged('');
                },
              ),
          ],
        ),
        body: Column(
          children: [
            // Filter Options Section - Fully Scrollable
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Filter Options',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            controller.clearAllFilters();
                            _searchController.clear();
                            _minPriceController.clear();
                            _maxPriceController.clear();
                            _minModelYearController.clear();
                            _maxModelYearController.clear();
                            _minMileageController.clear();
                            _maxMileageController.clear();
                            _firstRegYearFromController.clear();
                            _firstRegYearToController.clear();
                            _sellerDistanceController.clear();
                            _horsepowerMinController.clear();
                            _accelerationMaxController.clear();
                            _batteryCapacityMinController.clear();
                            _rangeKmMinController.clear();
                            _co2MaxController.clear();
                            _ownershipTaxMinController.clear();
                            _ownershipTaxMaxController.clear();
                            _doorsMinController.clear();
                            _seatsMinController.clear();
                            _trunkVolumeMinController.clear();
                          },
                          icon: Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                          label: Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    
                    // Listing Type at the top
                    _buildListingTypeSection(controller, isDark),
                    const SizedBox(height: 24),
                    
                    // Price Range
                    _buildPriceRangeSection(controller, isDark),
                    const SizedBox(height: 24),
                    
                    // Brand
                    _buildBrandSection(controller, isDark),
                    const SizedBox(height: 24),
                    
                    // Model
                    _buildModelSection(controller, isDark),
                    const SizedBox(height: 24),
                    
                    // Vehicle Type
                    _buildVehicleTypeSection(controller, isDark),
                    const SizedBox(height: 24),
                    
                    // Owner Tax
                    _buildOwnerTaxSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Basic Filters Section
                    _buildSectionHeading('Basic Filters', Icons.filter_list_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildModelYearRangeSection(controller, isDark),
                    const SizedBox(height: 20),
                    _buildMileageRangeSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Listing Details Section
                    _buildSectionHeading('Listing Details', Icons.description_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildCategorySection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildPriceTypeSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildConditionSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Vehicle Specs Section
                    _buildSectionHeading('Vehicle Specs', Icons.directions_car_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildBodyTypeSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildFuelTypeSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildTransmissionSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildDriveWheelsSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Registration Section
                    _buildSectionHeading('Registration', Icons.assignment_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildFirstRegistrationYearSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildSellerTypeSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildSalesTypeSection(controller, isDark),
                    const SizedBox(height: 16),
                    _buildSellerDistanceSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Performance Section
                    _buildSectionHeading('Performance', Icons.speed_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildPerformanceSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Battery & Charging Section
                    _buildSectionHeading('Battery & Charging (EV)', Icons.battery_charging_full_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildBatteryChargingSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Economy & Environment Section
                    _buildSectionHeading('Economy & Environment', Icons.eco_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildEconomyEnvironmentSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Physical Details Section
                    _buildSectionHeading('Physical Details', Icons.straighten_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildPhysicalDetailsSection(controller, isDark),
                    const SizedBox(height: 24),
                    _buildDivider(isDark),
                    const SizedBox(height: 24),
                    
                    // Equipment Section
                    _buildSectionHeading('Equipment', Icons.checklist_rounded, isDark),
                    const SizedBox(height: 16),
                    _buildEquipmentSection(controller, isDark),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
            ),
          ],
        ),
        // Bottom Navigation with Button
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Show Vehicles Button
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: isDark
                        ? AppColors.borderDark
                        : AppColors.borderLight,
                  ),
                ),
              ),
              child: SafeArea(
                top: false,
                child: Obx(() {
                  final count = controller.filteredVehicles.length;
                  return ElevatedButton(
                    onPressed: () {
                      // Navigate to search results screen with filters applied
                      Get.to(() => const SearchResultsView());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.white : Colors.black,
                      foregroundColor: isDark ? Colors.black : Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_car_rounded,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Show $count ${count == 1 ? 'Vehicle' : 'Vehicles'}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
            // Bottom Navigation Bar
            const BottomNavBar(
              currentIndex: 2,
              onTap: _handleNavTap,
            ),
          ],
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
        // Already on search
        break;
      case 3:
        Get.toNamed('/messages');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.textDark : AppColors.textLight,
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildPriceRangeSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRangeInput(
                label: 'kr Min',
                hint: '',
                controller: _minPriceController,
                isDark: isDark,
                onChanged: (value) {
                  final price = int.tryParse(value);
                  if (price != null && price >= 0) {
                    controller.setPriceRange(
                      price,
                      controller.maxPrice.value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'to',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRangeInput(
                label: 'kr',
                hint: '1000000',
                controller: _maxPriceController,
                isDark: isDark,
                onChanged: (value) {
                  final price = int.tryParse(value);
                  if (price != null && price >= 0) {
                    controller.setPriceRange(
                      controller.minPrice.value,
                      price,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          // Sync text fields when slider changes
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
          return RangeSlider(
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
          );
        }),
      ],
    );
  }

  Widget _buildBrandSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Brand',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            Get.toNamed('/brands-selection');
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final selectedBrandIds = controller.selectedBrandIds;
                    if (selectedBrandIds.isEmpty) {
                      return Text(
                        'All Makes',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      );
                    }
                    final brands = MockLookupService.getBrands();
                    final selectedBrands = brands
                        .where((brand) => selectedBrandIds.contains(brand.id))
                        .map((brand) => brand.name)
                        .toList();
                    
                    if (selectedBrands.length == 1) {
                      return Text(
                        selectedBrands.first,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      );
                    } else {
                      return Text(
                        '${selectedBrands.length} brands selected',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      );
                    }
                  }),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildModelSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Model',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            // TODO: Navigate to model selection
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'All Models',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark
                          ? AppColors.mutedDark
                          : AppColors.mutedLight,
                    ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleTypeSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Vehicle Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () {
            _showBodyTypeDialog(controller, isDark);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(() {
                    final selectedBodyTypeId = controller.selectedBodyTypeId.value;
                    if (selectedBodyTypeId == null) {
                      return Text(
                        'All Vehicle Types',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      );
                    }
                    final bodyTypes = MockLookupService.getBodyTypes();
                    final selectedBodyType = bodyTypes.firstWhere(
                      (bt) => bt.id == selectedBodyTypeId,
                      orElse: () => bodyTypes.first,
                    );
                    return Text(
                      selectedBodyType.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    );
                  }),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOwnerTaxSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Owner Tax',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildRangeInput(
                label: 'Min',
                hint: '',
                controller: _ownershipTaxMinController,
                isDark: isDark,
                onChanged: (value) {
                  final tax = int.tryParse(value);
                  if (tax != null && tax >= 0) {
                    controller.setEconomyFilters(
                      controller.co2Max.value,
                      controller.euroNorm.value,
                      controller.ownershipTaxMax.value,
                      controller.energyLabel.value,
                    );
                  }
                },
              ),
            ),
            const SizedBox(width: 12),
            Text(
              'to',
              style: TextStyle(
                fontSize: 14,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildRangeInput(
                label: '',
                hint: '100000',
                controller: _ownershipTaxMaxController,
                isDark: isDark,
                onChanged: (value) {
                  final tax = int.tryParse(value);
                  if (tax != null && tax >= 0) {
                    controller.setEconomyFilters(
                      controller.co2Max.value,
                      controller.euroNorm.value,
                      tax,
                      controller.energyLabel.value,
                    );
                  }
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Obx(() {
          final minTax = 0.0;
          final ownershipTaxMax = controller.ownershipTaxMax.value;
          final maxTax = ownershipTaxMax != null && ownershipTaxMax > 0 
              ? ownershipTaxMax.toDouble() 
              : 100000.0;
          return RangeSlider(
            values: RangeValues(minTax, maxTax),
            min: 0,
            max: 200000,
            divisions: 100,
            activeColor: isDark ? Colors.white : Colors.black,
            inactiveColor: isDark ? AppColors.gray700 : AppColors.gray300,
            onChanged: (values) {
              controller.setEconomyFilters(
                controller.co2Max.value,
                controller.euroNorm.value,
                values.end.toInt(),
                controller.energyLabel.value,
              );
            },
          );
        }),
      ],
    );
  }

  Widget _buildModelYearRangeSection(VehicleController controller, bool isDark) {
    final currentYear = DateTime.now().year;
    final minYear = 2000;

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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                label: 'From',
                hint: minYear.toString(),
                controller: _minModelYearController,
                isDark: isDark,
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year >= minYear && year <= currentYear) {
                    controller.setModelYearRange(
                      year,
                      controller.maxModelYear.value > 0
                          ? controller.maxModelYear.value
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
                controller: _maxModelYearController,
                isDark: isDark,
                onChanged: (value) {
                  final year = int.tryParse(value);
                  if (year != null && year >= minYear && year <= currentYear) {
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                label: 'Min (km)',
                hint: '0',
                controller: _minMileageController,
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
                controller: _maxMileageController,
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

  Widget _buildListingTypeSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Listing Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 12),
        Obx(() {
          final isPurchase = controller.listingType.value == 'purchase';
          final isLeasing = controller.listingType.value == 'leasing';
          
          return Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.setListingType(isPurchase ? null : 'purchase');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isPurchase
                          ? Colors.black
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Purchase',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isPurchase ? FontWeight.w600 : FontWeight.w500,
                          color: isPurchase ? Colors.white : (isDark ? AppColors.textDark : AppColors.textLight),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    controller.setListingType(isLeasing ? null : 'leasing');
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isLeasing
                          ? Colors.black
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Leasing',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isLeasing ? FontWeight.w600 : FontWeight.w500,
                          color: isLeasing ? Colors.white : (isDark ? AppColors.textDark : AppColors.textLight),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _buildCategorySection(VehicleController controller, bool isDark) {
    return InkWell(
      onTap: () {
        _showCategoryDialog(controller, isDark);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
          children: [
            Icon(
              Icons.category_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final selectedCategoryId = controller.selectedCategoryId.value;
                    if (selectedCategoryId == null) {
                      return Text(
                        'Select category',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      );
                    }
                    final categories = MockLookupService.getCategories();
                    final selectedCategory = categories.firstWhere(
                      (cat) => cat.id == selectedCategoryId,
                      orElse: () => categories.first,
                    );
                    return Text(
                      selectedCategory.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showCategoryDialog(VehicleController controller, bool isDark) {
    final categories = MockLookupService.getCategories();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return Obx(() {
                      final isSelected = controller.selectedCategoryId.value == category.id;
                      return ListTile(
                        title: Text(
                          category.name,
                          style: TextStyle(
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: isDark ? Colors.white : Colors.black,
                              )
                            : null,
                        selected: isSelected,
                        selectedTileColor: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                        onTap: () {
                          controller.setCategoryFilter(
                            isSelected ? null : category.id,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceTypeSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getPriceTypes();

    return _buildStringFilterSection(
      title: 'Price Type',
      icon: Icons.price_check_rounded,
      options: options,
      selectedValue: controller.priceType.value,
      onTap: (value) {
        controller.setPriceType(controller.priceType.value == value ? null : value);
      },
      isDark: isDark,
    );
  }

  Widget _buildConditionSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getConditions();

    return _buildStringFilterSection(
      title: 'Condition',
      icon: Icons.verified_rounded,
      options: options,
      selectedValue: controller.condition.value,
      onTap: (value) {
        controller.setCondition(controller.condition.value == value ? null : value);
      },
      isDark: isDark,
    );
  }

  Widget _buildBodyTypeSection(VehicleController controller, bool isDark) {
    return InkWell(
      onTap: () {
        _showBodyTypeDialog(controller, isDark);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
          children: [
            Icon(
              Icons.directions_car_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Body Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final selectedBodyTypeId = controller.selectedBodyTypeId.value;
                    if (selectedBodyTypeId == null) {
                      return Text(
                        'Select body type',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      );
                    }
                    final bodyTypes = MockLookupService.getBodyTypes();
                    final selectedBodyType = bodyTypes.firstWhere(
                      (bt) => bt.id == selectedBodyTypeId,
                      orElse: () => bodyTypes.first,
                    );
                    return Text(
                      selectedBodyType.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showBodyTypeDialog(VehicleController controller, bool isDark) {
    final bodyTypes = MockLookupService.getBodyTypes();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Body Type',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: bodyTypes.length,
                  itemBuilder: (context, index) {
                    final bodyType = bodyTypes[index];
                    return Obx(() {
                      final isSelected = controller.selectedBodyTypeId.value == bodyType.id;
                      return ListTile(
                        title: Text(
                          bodyType.name,
                          style: TextStyle(
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: isDark ? Colors.white : Colors.black,
                              )
                            : null,
                        selected: isSelected,
                        selectedTileColor: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                        onTap: () {
                          controller.setBodyTypeFilter(
                            isSelected ? null : bodyType.id,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFuelTypeSection(VehicleController controller, bool isDark) {
    return InkWell(
      onTap: () {
        _showFuelTypeDialog(controller, isDark);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
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
          children: [
            Icon(
              Icons.local_gas_station_rounded,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Fuel Type',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(() {
                    final selectedFuelTypeId = controller.selectedFuelTypeId.value;
                    if (selectedFuelTypeId == null) {
                      return Text(
                        'Select fuel type',
                        style: TextStyle(
                          fontSize: 14,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                        ),
                      );
                    }
                    final fuelTypes = MockLookupService.getFuelTypes();
                    final selectedFuelType = fuelTypes.firstWhere(
                      (ft) => ft.id == selectedFuelTypeId,
                      orElse: () => fuelTypes.first,
                    );
                    return Text(
                      selectedFuelType.name,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    );
                  }),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ],
        ),
      ),
    );
  }
  
  void _showFuelTypeDialog(VehicleController controller, bool isDark) {
    final fuelTypes = MockLookupService.getFuelTypes();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: isDark ? AppColors.cardDark : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Select Fuel Type',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: fuelTypes.length,
                  itemBuilder: (context, index) {
                    final fuelType = fuelTypes[index];
                    return Obx(() {
                      final isSelected = controller.selectedFuelTypeId.value == fuelType.id;
                      return ListTile(
                        title: Text(
                          fuelType.name,
                          style: TextStyle(
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(
                                Icons.check_circle_rounded,
                                color: isDark ? Colors.white : Colors.black,
                              )
                            : null,
                        selected: isSelected,
                        selectedTileColor: isDark
                            ? Colors.white.withOpacity(0.1)
                            : Colors.black.withOpacity(0.1),
                        onTap: () {
                          controller.setFuelTypeFilter(
                            isSelected ? null : fuelType.id,
                          );
                          Navigator.of(context).pop();
                        },
                      );
                    });
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTransmissionSection(VehicleController controller, bool isDark) {
    final options = ['manual', 'automatic'];

    return _buildStringFilterSection(
      title: 'Transmission',
      icon: Icons.settings_rounded,
      options: options,
      selectedValue: controller.selectedTransmission.value,
      onTap: (value) {
        controller.setTransmissionFilter(
          controller.selectedTransmission.value == value ? null : value,
        );
      },
      isDark: isDark,
    );
  }

  Widget _buildDriveWheelsSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getDriveWheels();

    return _buildStringFilterSection(
      title: 'Drive Wheels',
      icon: Icons.all_inclusive_rounded,
      options: options,
      selectedValue: controller.driveWheels.value,
      onTap: (value) {
        controller.setDriveWheels(controller.driveWheels.value == value ? null : value);
      },
      isDark: isDark,
    );
  }

  Widget _buildFirstRegistrationYearSection(VehicleController controller, bool isDark) {
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
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildNumberInput(
                label: 'From',
                hint: minYear.toString(),
                controller: _firstRegYearFromController,
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
                controller: _firstRegYearToController,
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

    return _buildStringFilterSection(
      title: 'Seller Type',
      icon: Icons.person_rounded,
      options: options,
      selectedValue: controller.sellerType.value,
      onTap: (value) {
        controller.setSellerType(controller.sellerType.value == value ? null : value);
      },
      isDark: isDark,
    );
  }

  Widget _buildSalesTypeSection(VehicleController controller, bool isDark) {
    final options = MockLookupService.getSalesTypes();

    return _buildStringFilterSection(
      title: 'Sales Type',
      icon: Icons.shopping_cart_rounded,
      options: options,
      selectedValue: controller.salesType.value,
      onTap: (value) {
        controller.setSalesType(controller.salesType.value == value ? null : value);
      },
      isDark: isDark,
    );
  }

  Widget _buildSellerDistanceSection(VehicleController controller, bool isDark) {
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
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Maximum distance (km)',
          hint: 'Enter distance',
          controller: _sellerDistanceController,
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
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Min Horsepower (HP)',
          hint: 'Enter minimum HP',
          controller: _horsepowerMinController,
          isDark: isDark,
          onChanged: (value) {
            final hp = int.tryParse(value);
            controller.setPerformanceFilters(
              hp,
              controller.accelerationMax.value,
            );
          },
        ),
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Max Acceleration (seconds)',
          hint: 'Enter max acceleration',
          controller: _accelerationMaxController,
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

  Widget _buildBatteryChargingSection(VehicleController controller, bool isDark) {
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
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Min Battery Capacity (kWh)',
          hint: 'Enter minimum capacity',
          controller: _batteryCapacityMinController,
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
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Min Range (km)',
          hint: 'Enter minimum range',
          controller: _rangeKmMinController,
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
        const SizedBox(height: 12),
        Text(
          'Charging Type',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
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

  Widget _buildEconomyEnvironmentSection(VehicleController controller, bool isDark) {
    final euroNorms = MockLookupService.getEuroNorms();
    final energyLabels = MockLookupService.getEnergyLabels();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberInput(
          label: 'Max CO2 (g/km)',
          hint: 'Enter maximum CO2',
          controller: _co2MaxController,
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
        const SizedBox(height: 16),
        Text(
          'Euro Norm',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
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
        const SizedBox(height: 16),
        Text(
          'Energy Label',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.textDark : AppColors.textLight,
          ),
        ),
        const SizedBox(height: 8),
        Obx(() => Wrap(
              spacing: 8,
              runSpacing: 8,
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

  Widget _buildPhysicalDetailsSection(VehicleController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildNumberInput(
          label: 'Min Doors',
          hint: 'Enter minimum doors',
          controller: _doorsMinController,
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
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Min Seats',
          hint: 'Enter minimum seats',
          controller: _seatsMinController,
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
        const SizedBox(height: 12),
        _buildNumberInput(
          label: 'Min Trunk Volume (L)',
          hint: 'Enter minimum volume',
          controller: _trunkVolumeMinController,
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

    return Obx(() => Wrap(
          spacing: 8,
          runSpacing: 8,
          children: equipment.map((eq) {
            final isSelected = controller.selectedEquipmentIds.contains(eq.id);
            return _buildFilterChip(
              label: eq.name,
              isSelected: isSelected,
              onTap: () {
                controller.toggleEquipment(eq.id);
              },
              isDark: isDark,
            );
          }).toList(),
        ));
  }

  Widget _buildStringFilterSection({
    required String title,
    required IconData icon,
    required List<String> options,
    required String? selectedValue,
    required Function(String) onTap,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return _buildFilterChip(
              label: option,
              isSelected: isSelected,
              onTap: () => onTap(option),
              isDark: isDark,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildRangeInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    required Function(String) onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      style: TextStyle(
        color: isDark ? AppColors.textDark : AppColors.textLight,
        fontSize: 14,
      ),
      decoration: InputDecoration(
        labelText: label.isNotEmpty ? label : null,
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          fontSize: 14,
        ),
        filled: true,
        fillColor: isDark ? AppColors.cardDark : Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: isDark ? Colors.white : Colors.black,
            width: 1,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        labelStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          fontSize: 12,
        ),
        isDense: true,
      ),
      onChanged: onChanged,
    );
  }

  Widget _buildNumberInput({
    required String label,
    required String hint,
    required TextEditingController controller,
    required bool isDark,
    required Function(String) onChanged,
    String? prefix,
  }) {
    return TextField(
      controller: controller,
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
        prefixText: prefix,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: TextStyle(
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          fontSize: 14,
        ),
      ),
      onChanged: onChanged,
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
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? AppColors.gray800 : AppColors.gray200),
          borderRadius: BorderRadius.circular(10),
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
                size: 16,
                color: isDark ? Colors.black : Colors.white,
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
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
