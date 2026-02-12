import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/search_controller.dart' as search_controller;
import '../../controllers/vehicle_result_controller.dart';
import '../../models/constants_model/constants_model.dart';
import '../../services/constants_service.dart';

class SearchView extends StatefulWidget {
  /// When true, "Search Vehicles" will pop and refetch results instead of navigating to result screen.
  final bool fromResultScreen;

  const SearchView({super.key, this.fromResultScreen = false});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  late final search_controller.SearchViewController searchController;

  late final TextEditingController _priceFromController;
  late final TextEditingController _priceToController;
  late final TextEditingController _mileageFromController;
  late final TextEditingController _mileageToController;
  late final TextEditingController _yearFromController;
  late final TextEditingController _yearToController;
  late final TextEditingController _ownershipTaxFromController;
  late final TextEditingController _ownershipTaxToController;
  late final TextEditingController _firstRegYearFromController;
  late final TextEditingController _firstRegYearToController;
  late final TextEditingController _enginePowerFromController;
  late final TextEditingController _enginePowerToController;
  late final TextEditingController _batteryFromController;
  late final TextEditingController _batteryToController;
  late final TextEditingController _rangeKmFromController;
  late final TextEditingController _rangeKmToController;
  late final TextEditingController _sellerDistanceController;
  late final TextEditingController _doorsMinController;
  late final TextEditingController _seatsMinController;

  @override
  void initState() {
    super.initState();
    if (Get.isRegistered<search_controller.SearchViewController>()) {
      searchController = Get.find<search_controller.SearchViewController>();
    } else {
      searchController = Get.put(search_controller.SearchViewController());
    }
    searchController.ensureConstantsLoaded();
    _priceFromController = TextEditingController(text: _formatPrice(searchController.priceFrom.value));
    _priceToController = TextEditingController(text: _formatPrice(searchController.priceTo.value));
    _mileageFromController = TextEditingController(text: _formatMileage(searchController.mileageFrom.value));
    _mileageToController = TextEditingController(text: _formatMileage(searchController.mileageTo.value));
    _yearFromController = TextEditingController(text: _formatYear(searchController.yearFrom.value));
    _yearToController = TextEditingController(text: _formatYear(searchController.yearTo.value));
    _ownershipTaxFromController = TextEditingController();
    _ownershipTaxToController = TextEditingController();
    _firstRegYearFromController = TextEditingController();
    _firstRegYearToController = TextEditingController();
    _enginePowerFromController = TextEditingController();
    _enginePowerToController = TextEditingController();
    _batteryFromController = TextEditingController();
    _batteryToController = TextEditingController();
    _rangeKmFromController = TextEditingController();
    _rangeKmToController = TextEditingController();
    _sellerDistanceController = TextEditingController();
    _doorsMinController = TextEditingController();
    _seatsMinController = TextEditingController();
  }

  String _formatPrice(double v) => v > 0 && v < 1000000 ? v.toInt().toString() : '';
  String _formatMileage(double v) => v > 0 && v < 500000 ? v.toInt().toString() : '';
  String _formatYear(int v) => v > 1975 && v < DateTime.now().year + 1 ? v.toString() : '';

  @override
  void dispose() {
    _priceFromController.dispose();
    _priceToController.dispose();
    _mileageFromController.dispose();
    _mileageToController.dispose();
    _yearFromController.dispose();
    _yearToController.dispose();
    _ownershipTaxFromController.dispose();
    _ownershipTaxToController.dispose();
    _firstRegYearFromController.dispose();
    _firstRegYearToController.dispose();
    _enginePowerFromController.dispose();
    _enginePowerToController.dispose();
    _batteryFromController.dispose();
    _batteryToController.dispose();
    _rangeKmFromController.dispose();
    _rangeKmToController.dispose();
    _sellerDistanceController.dispose();
    _doorsMinController.dispose();
    _seatsMinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final constants = Get.find<ConstantsService>().getConstants();

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        // appBar: AppBar(
        //   backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        //   elevation: 0,
        //   title: Text(
        //     'Search Vehicles',
        //     style: TextStyle(
        //       color: isDark ? AppColors.textDark : AppColors.textLight,
        //       fontSize: 18,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        // ),
        body: SafeArea(
          child: constants == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        'Loading filters...',
                        style: TextStyle(
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    _searchBar(isDark),
                    Expanded(
                      child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      children: [
                        _conditionSection(isDark),
                        _listingTypeSection(isDark),
                        _priceRangeSection(isDark),
                        _vehicleDetailsSection(isDark),
                        _odometerSection(isDark),
                        _modelYearSection(isDark),
                        _ownershipTaxSection(isDark),
                        _driveWheelsSection(isDark),
                        _firstRegistrationYearSection(isDark),
                        _sellerDistanceSection(isDark),
                        _horsepowerSection(isDark),
                        _batteryCapacitySection(isDark),
                        _rangeKmSection(isDark),
                        _chargingTypeSection(isDark),
                        _doorsSeatsSection(isDark),
                        _filterChipSection(isDark, 'Fuel type', searchController.fuelTypeIds, Get.find<ConstantsService>().getFuelTypes()),
                        _filterChipSection(isDark, 'Gear type', searchController.gearTypeIds, Get.find<ConstantsService>().getGearTypes()),
                        _filterChipSection(isDark, 'Sales type', searchController.salesTypeIds, Get.find<ConstantsService>().getSalesTypes()),
                        _filterChipSection(isDark, 'Price type', searchController.priceTypeIds, Get.find<ConstantsService>().getPriceTypes()),
                        _filterChipSection(isDark, 'Conditions', searchController.conditionIds, Get.find<ConstantsService>().getConditions()),
                        _filterChipSection(isDark, 'Body types', searchController.bodyTypeIds, Get.find<ConstantsService>().getBodyTypes()),
                        _filterChipSection(isDark, 'Euronorms', searchController.euronormIds, Get.find<ConstantsService>().getEuronorms()),
                        _equipmentSection(isDark),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _actionButtons(isDark),
                    ),
                  ),
                ],
              ),
        ),
      );
    });
  }

  Widget _searchBar(bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: searchController.searchTextController,
        focusNode: searchController.searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Search for brands, models, equipment or keywords...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            fontSize: 14,
          ),
          filled: true,
          fillColor: isDark ? AppColors.cardDark : Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.gray400, width: 1),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          prefixIcon: Icon(Icons.search, color: isDark ? AppColors.mutedDark : AppColors.mutedLight, size: 24),
        ),
      ),
    );
  }

  Widget _filterSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _conditionSection(bool isDark) {
    final conditions = Get.find<ConstantsService>().getConditions();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Condition', isDark),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _segmentChip(isDark, 'All', null, () => searchController.conditionId.value = null),
              ...conditions.map((c) => _segmentChip(
                    isDark,
                    c.name,
                    searchController.conditionId.value == c.id ? c.id : null,
                    () => searchController.conditionId.value = c.id,
                  )),
            ],
          ),
        ],
      );
    });
  }

  Widget _segmentChip(bool isDark, String label, int? selectedId, VoidCallback onTap) {
    return Obx(() {
      final sel = label == 'All' ? searchController.conditionId.value == null : selectedId == searchController.conditionId.value;
      return FilterChip(
        label: Text(label),
        selected: sel,
        onSelected: (_) => onTap(),
        selectedColor: AppColors.primary.withValues(alpha: 0.3),
        checkmarkColor: AppColors.primary,
        labelStyle: TextStyle(
          color: sel ? AppColors.primary : (isDark ? AppColors.textDark : AppColors.textLight),
          fontWeight: sel ? FontWeight.w600 : FontWeight.normal,
        ),
      );
    });
  }

  Widget _listingTypeSection(bool isDark) {
    final allTypes = Get.find<ConstantsService>().getListingTypes();
    final types = allTypes.where((t) => t.name == 'Purchase' || t.name == 'Leasing').toList();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Listing type', isDark),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: types.map((t) {
              final selected = searchController.listingTypeIds.contains(t.id);
              return FilterChip(
                label: Text(t.name),
                selected: selected,
                onSelected: (_) {
                  if (selected) {
                    searchController.listingTypeIds.remove(t.id);
                  } else {
                    searchController.listingTypeIds.add(t.id);
                  }
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.3),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _priceRangeSection(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Price (kr)', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.priceFrom.value = n.toDouble();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Text('-', style: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight)),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _priceToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.priceTo.value = n.toDouble();
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RangeSlider(
              values: RangeValues(searchController.priceFrom.value.clamp(0, 1000000), searchController.priceTo.value.clamp(0, 1000000)),
              min: 0,
              max: 1000000,
              divisions: 100,
              onChanged: (v) {
                searchController.priceFrom.value = v.start;
                searchController.priceTo.value = v.end;
                _priceFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
                _priceToController.text = v.end < 1000000 ? v.end.toInt().toString() : '';
              },
            ),
          ),
        ],
      );
    });
  }

  Widget _vehicleDetailsSection(bool isDark) {
    final cs = Get.find<ConstantsService>();
    final brands = cs.getBrands();
    final categories = cs.getCategories();
    return Obx(() {
      final brandId = searchController.brandId.value;
      final models = brandId != null ? cs.getModelsByBrandId(brandId) : <ModelItem>[];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Vehicle details', isDark),
          DropdownButtonFormField<int?>(
            value: searchController.brandId.value,
            decoration: InputDecoration(
              labelText: 'Brand',
              labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('All'),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('All')),
              ...brands.map((b) => DropdownMenuItem<int?>(value: b.id, child: Text(b.name))),
            ],
            onChanged: (v) {
              searchController.brandId.value = v;
              searchController.modelId.value = null;
            },
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            value: searchController.modelId.value,
            decoration: InputDecoration(
              labelText: 'Model',
              labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: Text(brandId == null ? 'Select brand first' : 'All'),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('All')),
              ...models.map((m) => DropdownMenuItem<int?>(value: m.id, child: Text(m.name))),
            ],
            onChanged: brandId == null ? null : (v) => searchController.modelId.value = v,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<int?>(
            value: searchController.categoryId.value,
            decoration: InputDecoration(
              labelText: 'Body style / Category',
              labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('All'),
            items: [
              const DropdownMenuItem<int?>(value: null, child: Text('All')),
              ...categories.map((c) => DropdownMenuItem<int?>(value: c.id, child: Text(c.name))),
            ],
            onChanged: (v) => searchController.categoryId.value = v,
          ),
        ],
      );
    });
  }

  Widget _odometerSection(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Odometer (km)', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _mileageFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.mileageFrom.value = n.toDouble();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _mileageToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.mileageTo.value = n.toDouble();
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(searchController.mileageFrom.value.clamp(0, 500000), searchController.mileageTo.value.clamp(0, 500000)),
            min: 0,
            max: 500000,
            divisions: 50,
            onChanged: (v) {
              searchController.mileageFrom.value = v.start;
              searchController.mileageTo.value = v.end;
              _mileageFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
              _mileageToController.text = v.end < 500000 ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _modelYearSection(bool isDark) {
    final currentYear = DateTime.now().year + 1;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Model year', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _yearFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'From',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.yearFrom.value = n.clamp(1975, currentYear);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _yearToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'To',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.yearTo.value = n.clamp(1975, currentYear);
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              searchController.yearFrom.value.toDouble().clamp(1975, currentYear.toDouble()),
              searchController.yearTo.value.toDouble().clamp(1975, currentYear.toDouble()),
            ),
            min: 1975,
            max: currentYear.toDouble(),
            divisions: currentYear - 1975,
            onChanged: (v) {
              searchController.yearFrom.value = v.start.toInt();
              searchController.yearTo.value = v.end.toInt();
              _yearFromController.text = v.start > 1975 ? v.start.toInt().toString() : '';
              _yearToController.text = v.end < currentYear ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _ownershipTaxSection(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Owner tax', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _ownershipTaxFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.ownershipTaxFrom.value = n.toDouble();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _ownershipTaxToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.ownershipTaxTo.value = n.toDouble();
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              searchController.ownershipTaxFrom.value.clamp(0, 100000),
              searchController.ownershipTaxTo.value.clamp(0, 100000),
            ),
            min: 0,
            max: 100000,
            divisions: 100,
            onChanged: (v) {
              searchController.ownershipTaxFrom.value = v.start;
              searchController.ownershipTaxTo.value = v.end;
              _ownershipTaxFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
              _ownershipTaxToController.text = v.end < 100000 ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _driveWheelsSection(bool isDark) {
    const options = ['fwd', 'rwd', 'awd'];
    const labels = ['FWD', 'RWD', 'AWD'];
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Drive wheels', isDark),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: List.generate(3, (i) {
              final value = options[i];
              final selected = searchController.driveAxles.contains(value);
              return FilterChip(
                label: Text(labels[i]),
                selected: selected,
                onSelected: (_) {
                  if (selected) {
                    searchController.driveAxles.remove(value);
                  } else {
                    searchController.driveAxles.add(value);
                  }
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.3),
                checkmarkColor: AppColors.primary,
              );
            }),
          ),
        ],
      );
    });
  }

  Widget _firstRegistrationYearSection(bool isDark) {
    final currentYear = DateTime.now().year + 1;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('First registration year', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _firstRegYearFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'From',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.firstRegYearFrom.value = n.clamp(1975, currentYear);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _firstRegYearToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'To',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.firstRegYearTo.value = n.clamp(1975, currentYear);
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              searchController.firstRegYearFrom.value.toDouble().clamp(1975, currentYear.toDouble()),
              searchController.firstRegYearTo.value.toDouble().clamp(1975, currentYear.toDouble()),
            ),
            min: 1975,
            max: currentYear.toDouble(),
            divisions: currentYear - 1975,
            onChanged: (v) {
              searchController.firstRegYearFrom.value = v.start.toInt();
              searchController.firstRegYearTo.value = v.end.toInt();
              _firstRegYearFromController.text = v.start > 1975 ? v.start.toInt().toString() : '';
              _firstRegYearToController.text = v.end < currentYear ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _sellerDistanceSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _filterSectionTitle('Seller distance (km)', isDark),
        TextFormField(
          controller: _sellerDistanceController,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(
            hintText: 'Distance in km',
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          onChanged: (v) {
            final n = int.tryParse(v);
            if (n != null) searchController.sellerDistanceKm.value = n.clamp(0, 10000);
          },
        ),
      ],
    );
  }

  Widget _horsepowerSection(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Horsepower (hp)', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _enginePowerFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.enginePowerFrom.value = n.toDouble();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _enginePowerToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.enginePowerTo.value = n.toDouble();
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              searchController.enginePowerFrom.value.clamp(0, 1000),
              searchController.enginePowerTo.value.clamp(0, 1000),
            ),
            min: 0,
            max: 1000,
            divisions: 100,
            onChanged: (v) {
              searchController.enginePowerFrom.value = v.start;
              searchController.enginePowerTo.value = v.end;
              _enginePowerFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
              _enginePowerToController.text = v.end < 1000 ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _batteryCapacitySection(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Battery capacity (kWh)', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _batteryFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.batteryCapacityFrom.value = n.toDouble();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _batteryToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.batteryCapacityTo.value = n.toDouble();
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              searchController.batteryCapacityFrom.value.clamp(0, 200),
              searchController.batteryCapacityTo.value.clamp(0, 200),
            ),
            min: 0,
            max: 200,
            divisions: 50,
            onChanged: (v) {
              searchController.batteryCapacityFrom.value = v.start;
              searchController.batteryCapacityTo.value = v.end;
              _batteryFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
              _batteryToController.text = v.end < 200 ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _rangeKmSection(bool isDark) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Range (km)', isDark),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _rangeKmFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Min',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.rangeKmFrom.value = n.toDouble();
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _rangeKmToController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: 'Max',
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.rangeKmTo.value = n.toDouble();
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(
              searchController.rangeKmFrom.value.clamp(0, 1000),
              searchController.rangeKmTo.value.clamp(0, 1000),
            ),
            min: 0,
            max: 1000,
            divisions: 50,
            onChanged: (v) {
              searchController.rangeKmFrom.value = v.start;
              searchController.rangeKmTo.value = v.end;
              _rangeKmFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
              _rangeKmToController.text = v.end < 1000 ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }

  Widget _chargingTypeSection(bool isDark) {
    return Obx(() {
      const options = ['AC', 'DC', 'AC/DC'];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle('Charging type', isDark),
          DropdownButtonFormField<String?>(
            value: searchController.chargingType.value,
            decoration: InputDecoration(
              labelText: 'Charging type',
              labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 14),
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            hint: const Text('All'),
            items: [
              const DropdownMenuItem<String?>(value: null, child: Text('All')),
              ...options.map((o) => DropdownMenuItem<String?>(value: o, child: Text(o))),
            ],
            onChanged: (v) => searchController.chargingType.value = v,
          ),
        ],
      );
    });
  }

  Widget _doorsSeatsSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _filterSectionTitle('Doors & seats', isDark),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _doorsMinController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Doors (min)',
                  labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 14),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null) searchController.doorsMin.value = n.clamp(0, 10);
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _seatsMinController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: 'Seats (min)',
                  labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 14),
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) {
                  final n = int.tryParse(v);
                  if (n != null) searchController.seatsMin.value = n.clamp(0, 20);
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _filterChipSection(bool isDark, String title, RxList<int> selectedIds, List<LookupItem> items) {
    if (items.isEmpty) return const SizedBox.shrink();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle(title, isDark),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              final selected = selectedIds.contains(item.id);
              return FilterChip(
                label: Text(item.name),
                selected: selected,
                onSelected: (_) {
                  if (selected) {
                    selectedIds.remove(item.id);
                  } else {
                    selectedIds.add(item.id);
                  }
                },
                selectedColor: AppColors.primary.withValues(alpha: 0.3),
                checkmarkColor: AppColors.primary,
              );
            }).toList(),
          ),
        ],
      );
    });
  }

  Widget _equipmentSection(bool isDark) {
    final cs = Get.find<ConstantsService>();
    final equipmentTypes = cs.getEquipmentTypes();
    if (equipmentTypes.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _filterSectionTitle('Equipment', isDark),
        ...equipmentTypes.map((et) {
          final equipments = cs.getEquipmentsByTypeId(et.id);
          if (equipments.isEmpty) return const SizedBox.shrink();
          return ExpansionTile(
            title: Text(
              et.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: equipments.map((e) {
                    return Obx(() {
                      final selected = searchController.equipmentIds.contains(e.id);
                      return FilterChip(
                        label: Text(e.name),
                        selected: selected,
                        onSelected: (_) {
                          if (selected) {
                            searchController.equipmentIds.remove(e.id);
                          } else {
                            searchController.equipmentIds.add(e.id);
                          }
                        },
                        selectedColor: AppColors.primary.withValues(alpha: 0.3),
                        checkmarkColor: AppColors.primary,
                      );
                    });
                  }).toList(),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _actionButtons(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              searchController.clearFilters();
              _priceFromController.text = '';
              _priceToController.text = '';
              _mileageFromController.text = '';
              _mileageToController.text = '';
              _yearFromController.text = '';
              _yearToController.text = '';
              _ownershipTaxFromController.text = '';
              _ownershipTaxToController.text = '';
              _firstRegYearFromController.text = '';
              _firstRegYearToController.text = '';
              _enginePowerFromController.text = '';
              _enginePowerToController.text = '';
              _batteryFromController.text = '';
              _batteryToController.text = '';
              _rangeKmFromController.text = '';
              _rangeKmToController.text = '';
              _sellerDistanceController.text = '';
              _doorsMinController.text = '';
              _seatsMinController.text = '';
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Reset'),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (widget.fromResultScreen) {
                Get.find<VehicleResultController>().fetchVehicles();
                Get.back();
              } else {
                Get.toNamed('/search-vehicles');
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.primaryForeground,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: const Text('Search Vehicles'),
          ),
        ),
      ],
    );
  }
}
