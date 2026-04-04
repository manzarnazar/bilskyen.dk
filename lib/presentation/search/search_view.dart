import 'dart:math' show max, min;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/search_controller.dart' as search_controller;
import '../../controllers/vehicle_result_controller.dart';
import '../../models/constants_model/constants_model.dart';
import 'search_lookup_picker_view.dart';
import '../../services/constants_service.dart';

String _listingTypeLabel(LookupItem t, AppLocalizations l10n) {
  final n = t.name.trim().toLowerCase();
  if (n == 'purchase') return l10n.listingPurchase;
  if (n == 'leasing') return l10n.listingLeasing;
  return t.name;
}

/// Display text for km/L filter fields (allows half steps like the web slider).
String _kmPerLiterSliderText(double v, {required bool isTo, required double maxVal}) {
  if (v <= 0) return '';
  if (isTo && v >= maxVal) return '';
  if (v == v.roundToDouble()) return v.toInt().toString();
  return v.toStringAsFixed(1);
}

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
  late final TextEditingController _doorCountController;
  late final TextEditingController _seatsMinController;
  late final TextEditingController _seatsMaxController;
  late final TextEditingController _towingWeightController;
  late final TextEditingController _fuelEfficiencyFromController;
  late final TextEditingController _fuelEfficiencyToController;
  late final TextEditingController _topSpeedFromController;
  late final TextEditingController _topSpeedToController;
  late final TextEditingController _weightFromController;
  late final TextEditingController _weightToController;
  late final TextEditingController _axleCountController;
  late final TextEditingController _airbagsController;
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
    _yearFromController = TextEditingController(text: _formatYear(searchController.modelYearFrom.value));
    _yearToController = TextEditingController(text: _formatYear(searchController.modelYearTo.value));
    _ownershipTaxFromController = TextEditingController();
    _ownershipTaxToController = TextEditingController();
    _firstRegYearFromController = TextEditingController();
    _firstRegYearToController = TextEditingController();
    _enginePowerFromController = TextEditingController();
    _enginePowerToController = TextEditingController();
    _batteryFromController = TextEditingController();
    _batteryToController = TextEditingController();
    _doorCountController = TextEditingController();
    _seatsMinController = TextEditingController();
    _seatsMaxController = TextEditingController();
    _towingWeightController = TextEditingController();
    _fuelEfficiencyFromController = TextEditingController();
    _fuelEfficiencyToController = TextEditingController();
    _topSpeedFromController = TextEditingController();
    _topSpeedToController = TextEditingController();
    _weightFromController = TextEditingController();
    _weightToController = TextEditingController();
    _axleCountController = TextEditingController();
    _airbagsController = TextEditingController();
    _hydrateLegacySelections();
  }
  String _formatPrice(double v) =>
      v > 0 && v < search_controller.SearchViewController.priceMax ? v.toInt().toString() : '';
  String _formatMileage(double v) =>
      v > 0 && v < search_controller.SearchViewController.mileageMax ? v.toInt().toString() : '';
  String _formatYear(int v) {
    final cap = search_controller.SearchViewController.calendarYearMax;
    return v > 1950 && v < cap ? v.toString() : '';
  }
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
    _doorCountController.dispose();
    _seatsMinController.dispose();
    _seatsMaxController.dispose();
    _towingWeightController.dispose();
    _fuelEfficiencyFromController.dispose();
    _fuelEfficiencyToController.dispose();
    _topSpeedFromController.dispose();
    _topSpeedToController.dispose();
    _weightFromController.dispose();
    _weightToController.dispose();
    _axleCountController.dispose();
    _airbagsController.dispose();
    super.dispose();
  }

  void _hydrateLegacySelections() {
    final cs = Get.find<ConstantsService>();
    final selectedLegacyBrand = searchController.brandId.value;
    if (selectedLegacyBrand != null && !searchController.selectedBrandIds.contains(selectedLegacyBrand)) {
      searchController.selectedBrandIds.add(selectedLegacyBrand);
      final name = cs.getBrands().firstWhereOrNull((e) => e.id == selectedLegacyBrand)?.name;
      if (name != null) {
        searchController.selectedBrandNames[selectedLegacyBrand] = name;
      }
    }

    final selectedLegacyModel = searchController.modelId.value;
    if (selectedLegacyModel != null && !searchController.selectedModelIds.contains(selectedLegacyModel)) {
      searchController.selectedModelIds.add(selectedLegacyModel);
      final model = cs.getModels().firstWhereOrNull((e) => e.id == selectedLegacyModel);
      if (model != null) {
        searchController.selectedModelNames[selectedLegacyModel] = model.name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final constantsService = Get.find<ConstantsService>();
      final constants = constantsService.getConstants();
      final constantsLoading = constantsService.isLoading.value;
      final constantsError = constantsService.error.value;
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: constants == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (constantsLoading) ...[
                        const CircularProgressIndicator(),
                        const SizedBox(height: 16),
                        Text(
                          l10n.loadingFilters,
                          style: TextStyle(
                            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                          ),
                        ),
                      ] else ...[
                        Icon(
                          Icons.error_outline,
                          size: 40,
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            constantsError.isNotEmpty ? constantsError : l10n.loadingFilters,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () => constantsService.fetchConstants(),
                          child: Text(l10n.retry),
                        ),
                      ],
                    ],
                  ),
                )
              : Column(
                  children: [
                    _searchBar(context, isDark),
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
                          checkboxTheme: CheckboxThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6),
                            ),
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            splashRadius: 22,
                          ),
                          listTileTheme: const ListTileThemeData(
                            horizontalTitleGap: 4,
                          ),
                        ),
                        child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _conditionSection(context, isDark),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _listingTypeSection(context, isDark),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _salesTypeSection(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: l10n.typeBrandModel,
                          initiallyExpanded: true,
                          child: _brandModelYearContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: '${l10n.priceRange} / ${l10n.kmDriven}',
                          initiallyExpanded: true,
                          child: _priceKmContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: '${l10n.fuelType} / ${l10n.bodyTypes}',
                          initiallyExpanded: searchController.fuelTypeIds.isNotEmpty ||
                              searchController.bodyTypeId.value != null,
                          child: _fuelBodyContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: '${l10n.color} / ${l10n.type}',
                          initiallyExpanded: searchController.colorId.value != null ||
                              searchController.priceTypeId.value != null ||
                              searchController.emissionNormId.value != null ||
                              searchController.useId.value != null,
                          child: _colorDetailsContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: '${l10n.firstRegistrationYear} / ${l10n.horsepowerHp}',
                          initiallyExpanded: () {
                            final y = search_controller.SearchViewController.calendarYearMax;
                            return searchController.firstRegYearFrom.value > 1950 ||
                                searchController.firstRegYearTo.value < y ||
                                searchController.ownershipTaxFrom.value > 0 ||
                                searchController.ownershipTaxTo.value < 20000 ||
                                searchController.enginePowerKwFrom.value > 0 ||
                                searchController.enginePowerKwTo.value < 1000 ||
                                searchController.electricalConsumptionFrom.value > 0 ||
                                searchController.electricalConsumptionTo.value < 500 ||
                                searchController.kmPerLiterFrom.value > 0 ||
                                searchController.kmPerLiterTo.value < 100;
                          }(),
                          child: _modelYearHpContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: l10n.physicalDetails,
                          initiallyExpanded: searchController.maxSpeedFrom.value > 0 ||
                              searchController.maxSpeedTo.value < 400 ||
                              searchController.maximumWeightKgFrom.value > 0 ||
                              searchController.maximumWeightKgTo.value < 5000 ||
                              searchController.doorCount.value > 0 ||
                              searchController.seatsMin.value > 0 ||
                              searchController.seatsMax.value > 0 ||
                              searchController.axleCount.value > 0 ||
                              searchController.specificationsAirbags.value > 0 ||
                              searchController.towingWeight.value > 0,
                          child: _physicalDetailsContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: l10n.chargingType,
                          initiallyExpanded: searchController.chargingType.value != null ||
                              searchController.ncapTest.value ||
                              searchController.isImport.value ||
                              searchController.isFactoryNew.value,
                          child: _chargingContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: l10n.equipment,
                          initiallyExpanded: searchController.equipmentIds.isNotEmpty,
                          child: _equipmentContent(context, isDark),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                  ),
                  SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: _actionButtons(context, isDark),
                    ),
                  ),
                ],
              ),
        ),
      );
    });
  }
  Widget _searchBar(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: TextField(
        controller: searchController.searchTextController,
        focusNode: searchController.searchFocusNode,
        decoration: InputDecoration(
          hintText: l10n.searchHint,
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
  Widget _expandableFilterSection({
    required BuildContext context,
    required bool isDark,
    required String title,
    required bool initiallyExpanded,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: initiallyExpanded,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
          title: Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 0.5,
            ),
          ),
          controlAffinity: ListTileControlAffinity.trailing,
          children: [child],
        ),
      ),
    );
  }
  Widget _conditionSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final conditions = Get.find<ConstantsService>().getConditions();
    return Obx(() {
      final selectedId = searchController.conditionId.value;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle(l10n.condition, isDark),
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : AppColors.borderLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _conditionSegment(isDark, l10n.all, null, selectedId),
                ...conditions.map((c) => Padding(
                  padding: const EdgeInsets.only(left: 4),
                  child: _conditionSegment(isDark, c.name, c.id, selectedId),
                )),
              ],
            ),
          ),
        ],
      );
    });
  }
  Widget _conditionSegment(bool isDark, String label, int? id, int? selectedId) {
    final selected = selectedId == id;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          searchController.conditionId.value = id;
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          decoration: BoxDecoration(
            color: selected ? (isDark ? AppColors.backgroundDark : Colors.white) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected ? [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 2, offset: const Offset(0, 1))] : null,
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
        ),
      ),
    );
  }
  Widget _listingTypeSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final allTypes = Get.find<ConstantsService>().getListingTypes();
    final types = allTypes.where((t) {
      final n = t.name.trim().toLowerCase();
      return n == 'purchase' || n == 'leasing';
    }).toList();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle(l10n.listingType, isDark),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: types.map((t) {
              final selected = searchController.listingTypeIds.contains(t.id);
              return _wrapCheckboxChip(
                isDark,
                value: selected,
                onTap: () {
                  if (selected) {
                    searchController.listingTypeIds.remove(t.id);
                  } else {
                    searchController.listingTypeIds.add(t.id);
                  }
                },
                label: _listingTypeLabel(t, l10n),
              );
            }).toList(),
          ),
        ],
      );
    });
  }
  Widget _brandModelYearContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Get.find<ConstantsService>();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _lookupNavigationTile(
            context: context,
            isDark: isDark,
            label: l10n.brand,
            selectedIds: searchController.selectedBrandIds,
            selectedNames: searchController.selectedBrandNames,
            onTap: () => Get.to(
              () => const SearchLookupPickerView(type: SearchLookupType.brand),
            ),
            onRemoveSelected: (id) {
              searchController.selectedBrandIds.remove(id);
              searchController.selectedBrandNames.remove(id);
              searchController.selectedModelIds.clear();
              searchController.selectedModelNames.clear();
              searchController.selectedVariantIds.clear();
              searchController.selectedVariantNames.clear();
              searchController.brandId.value = null;
              searchController.modelId.value = null;
            },
          ),
          const SizedBox(height: 12),
          AbsorbPointer(
            absorbing: searchController.selectedBrandIds.isEmpty,
            child: Opacity(
              opacity: searchController.selectedBrandIds.isEmpty ? 0.5 : 1,
              child: _lookupNavigationTile(
                context: context,
                isDark: isDark,
                label: l10n.model,
                selectedIds: searchController.selectedModelIds,
                selectedNames: searchController.selectedModelNames,
                onTap: () => Get.to(
                  () => const SearchLookupPickerView(type: SearchLookupType.model),
                ),
                onRemoveSelected: (id) {
                  searchController.selectedModelIds.remove(id);
                  searchController.selectedModelNames.remove(id);
                  searchController.selectedVariantIds.clear();
                  searchController.selectedVariantNames.clear();
                  searchController.modelId.value = null;
                },
                emptyHint: l10n.selectBrandFirst,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AbsorbPointer(
            absorbing: searchController.selectedModelIds.isEmpty,
            child: Opacity(
              opacity: searchController.selectedModelIds.isEmpty ? 0.5 : 1,
              child: _lookupNavigationTile(
                context: context,
                isDark: isDark,
                label: l10n.variant,
                selectedIds: searchController.selectedVariantIds,
                selectedNames: searchController.selectedVariantNames,
                onTap: () => Get.to(
                  () => const SearchLookupPickerView(type: SearchLookupType.variant),
                ),
                onRemoveSelected: (id) {
                  searchController.selectedVariantIds.remove(id);
                  searchController.selectedVariantNames.remove(id);
                },
                emptyHint: l10n.selectBrandFirst,
              ),
            ),
          ),
          const SizedBox(height: 12),
          _singleSelectDropdown(
            isDark: isDark,
            label: l10n.gearType,
            value: searchController.gearTypeId.value,
            items: cs.getGearTypes(),
            onChanged: (v) => searchController.gearTypeId.value = v,
          ),
          const SizedBox(height: 12),
          Obx(() {
            final currentYear = search_controller.SearchViewController.calendarYearMax;
            // Isolate model-year observables so the range slider and slider thumbs rebuild reliably.
            final mf = searchController.modelYearFrom.value;
            final mt = searchController.modelYearTo.value;
            return _rangeRow(
              isDark: isDark,
              label: l10n.modelYear,
              fromCtrl: _yearFromController,
              toCtrl: _yearToController,
              fromVal: mf.toDouble(),
              toVal: mt.toDouble(),
              min: 1950,
              max: currentYear.toDouble(),
              divisions: currentYear - 1950,
              onSliderChanged: (a, b) {
                searchController.modelYearFrom.value = a.toInt();
                searchController.modelYearTo.value = b.toInt();
                _yearFromController.text = a > 1950 ? a.toInt().toString() : '';
                _yearToController.text = b < currentYear ? b.toInt().toString() : '';
              },
              onFromChanged: (n) {
                searchController.modelYearFrom.value = n.clamp(1950, currentYear.toDouble()).toInt();
              },
              onToChanged: (n) {
                searchController.modelYearTo.value = n.clamp(1950, currentYear.toDouble()).toInt();
              },
            );
          }),
        ],
      );
    });
  }

  Widget _salesTypeSection(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Get.find<ConstantsService>();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _filterSectionTitle(l10n.salesType, isDark),
          DropdownButtonFormField<int?>(
            value: searchController.salesTypeId.value,
            isExpanded: true,
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            hint: Text(l10n.all),
            items: [
              DropdownMenuItem<int?>(value: null, child: Text(l10n.all)),
              ...cs.getSalesTypes().map((s) => DropdownMenuItem<int?>(value: s.id, child: Text(s.name))),
            ],
            onChanged: (v) => searchController.salesTypeId.value = v,
          ),
        ],
      );
    });
  }
  Widget _priceKmContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final priceMax = search_controller.SearchViewController.priceMax.toDouble();
    final mileageMax = search_controller.SearchViewController.mileageMax.toDouble();
    return Obx(() {
      final pf = searchController.priceFrom.value.clamp(0.0, priceMax);
      final pt = searchController.priceTo.value.clamp(0.0, priceMax);
      final mf = searchController.mileageFrom.value.clamp(0.0, mileageMax);
      final mt = searchController.mileageTo.value.clamp(0.0, mileageMax);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.priceRange,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _priceFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: l10n.min,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) {
                      searchController.priceFrom.value = n.clamp(0, search_controller.SearchViewController.priceMax).toDouble();
                    }
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
                    hintText: l10n.max,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) {
                      searchController.priceTo.value = n.clamp(0, search_controller.SearchViewController.priceMax).toDouble();
                    }
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: RangeSlider(
              values: RangeValues(min(pf, pt), max(pf, pt)),
              min: 0,
              max: priceMax,
              divisions: 100,
              onChanged: (v) {
                searchController.priceFrom.value = v.start;
                searchController.priceTo.value = v.end;
                _priceFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
                _priceToController.text = v.end < priceMax ? v.end.toInt().toString() : '';
              },
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.kmDriven,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _mileageFromController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    hintText: l10n.min,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) {
                      searchController.mileageFrom.value = n.clamp(0, search_controller.SearchViewController.mileageMax).toDouble();
                    }
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
                    hintText: l10n.max,
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) {
                      searchController.mileageTo.value = n.clamp(0, search_controller.SearchViewController.mileageMax).toDouble();
                    }
                  },
                ),
              ),
            ],
          ),
          RangeSlider(
            values: RangeValues(min(mf, mt), max(mf, mt)),
            min: 0,
            max: mileageMax,
            divisions: 50,
            onChanged: (v) {
              searchController.mileageFrom.value = v.start;
              searchController.mileageTo.value = v.end;
              _mileageFromController.text = v.start > 0 ? v.start.toInt().toString() : '';
              _mileageToController.text = v.end < mileageMax ? v.end.toInt().toString() : '';
            },
          ),
        ],
      );
    });
  }
  Widget _singleSelectDropdown({
    required bool isDark,
    required String label,
    required int? value,
    required List<LookupItem> items,
    required void Function(int?) onChanged,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<int?>(
          value: value,
          isExpanded: true,
          decoration: InputDecoration(
            isDense: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          ),
          hint: Text(l10n.all, overflow: TextOverflow.ellipsis),
          items: [
            DropdownMenuItem<int?>(value: null, child: Text(l10n.all, overflow: TextOverflow.ellipsis)),
            ...items.map((i) => DropdownMenuItem<int?>(value: i.id, child: Text(i.name, overflow: TextOverflow.ellipsis))),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
  Widget _fuelBodyContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Get.find<ConstantsService>();
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.fuelType,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: cs.getFuelTypes().map((ft) {
              final selected = searchController.fuelTypeIds.contains(ft.id);
              return _wrapCheckboxChip(
                isDark,
                value: selected,
                onTap: () {
                  if (selected) {
                    searchController.fuelTypeIds.remove(ft.id);
                  } else {
                    searchController.fuelTypeIds.add(ft.id);
                  }
                },
                label: ft.name,
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          _singleSelectDropdown(
            isDark: isDark,
            label: l10n.bodyTypes,
            value: searchController.bodyTypeId.value,
            items: cs.getBodyTypes(),
            onChanged: (v) => searchController.bodyTypeId.value = v,
          ),
        ],
      );
    });
  }
  Widget _colorDetailsContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Get.find<ConstantsService>();
    return Obx(() {
      Widget dropdown(String label, int? value, List<LookupItem> items, void Function(int?) onChanged) {
        return _singleSelectDropdown(isDark: isDark, label: label, value: value, items: items, onChanged: onChanged);
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: dropdown(
                  l10n.color,
                  searchController.colorId.value,
                  cs.getColors(),
                  (v) => searchController.colorId.value = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: dropdown(
                  l10n.priceType,
                  searchController.priceTypeId.value,
                  cs.getPriceTypes(),
                  (v) => searchController.priceTypeId.value = v,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: dropdown(
                  l10n.euronorms,
                  searchController.emissionNormId.value,
                  cs.getEuronorms(),
                  (v) => searchController.emissionNormId.value = v,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: dropdown(
                  l10n.use,
                  searchController.useId.value,
                  cs.getVehicleUses(),
                  (v) => searchController.useId.value = v,
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
  Widget _rangeRow({
    required bool isDark,
    required String label,
    required TextEditingController fromCtrl,
    required TextEditingController toCtrl,
    required double fromVal,
    required double toVal,
    required double min,
    required double max,
    required int divisions,
    required void Function(double, double) onSliderChanged,
    required void Function(double) onFromChanged,
    required void Function(double) onToChanged,
    bool allowDecimal = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    final clampedFrom = fromVal.clamp(min, max);
    final clampedTo = toVal.clamp(min, max);
    final rangeStart = clampedFrom <= clampedTo ? clampedFrom : clampedTo;
    final rangeEnd = clampedFrom <= clampedTo ? clampedTo : clampedFrom;
    final formatters = allowDecimal
        ? <TextInputFormatter>[FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}'))]
        : <TextInputFormatter>[FilteringTextInputFormatter.digitsOnly];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: fromCtrl,
                keyboardType: allowDecimal
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
                inputFormatters: formatters,
                decoration: InputDecoration(
                  hintText: l10n.from,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) {
                  final n = double.tryParse(v.replaceAll(',', '.'));
                  if (n != null) onFromChanged(n);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: toCtrl,
                keyboardType: allowDecimal
                    ? const TextInputType.numberWithOptions(decimal: true)
                    : TextInputType.number,
                inputFormatters: formatters,
                decoration: InputDecoration(
                  hintText: l10n.to,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) {
                  final n = double.tryParse(v.replaceAll(',', '.'));
                  if (n != null) onToChanged(n);
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: RangeSlider(
            values: RangeValues(rangeStart, rangeEnd),
            min: min,
            max: max,
            divisions: divisions,
            onChanged: (v) => onSliderChanged(v.start, v.end),
          ),
        ),
      ],
    );
  }
  Widget _modelYearHpContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final regYearMax = search_controller.SearchViewController.calendarYearMax;
    const fuelEffMax = 100.0;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rangeRow(
            isDark: isDark,
            label: l10n.firstRegistrationYear,
            fromCtrl: _firstRegYearFromController,
            toCtrl: _firstRegYearToController,
            fromVal: searchController.firstRegYearFrom.value.toDouble(),
            toVal: searchController.firstRegYearTo.value.toDouble(),
            min: 1950,
            max: regYearMax.toDouble(),
            divisions: regYearMax - 1950,
            onSliderChanged: (a, b) {
              searchController.firstRegYearFrom.value = a.toInt();
              searchController.firstRegYearTo.value = b.toInt();
              _firstRegYearFromController.text = a > 1950 ? a.toInt().toString() : '';
              _firstRegYearToController.text = b < regYearMax ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.firstRegYearFrom.value = n.clamp(1950, regYearMax.toDouble()).toInt(),
            onToChanged: (n) => searchController.firstRegYearTo.value = n.clamp(1950, regYearMax.toDouble()).toInt(),
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.ownerTax,
            fromCtrl: _ownershipTaxFromController,
            toCtrl: _ownershipTaxToController,
            fromVal: searchController.ownershipTaxFrom.value,
            toVal: searchController.ownershipTaxTo.value,
            min: 0,
            max: 20000,
            divisions: 40,
            onSliderChanged: (a, b) {
              searchController.ownershipTaxFrom.value = a;
              searchController.ownershipTaxTo.value = b;
              _ownershipTaxFromController.text = a > 0 ? a.toInt().toString() : '';
              _ownershipTaxToController.text = b < 20000 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.ownershipTaxFrom.value = n,
            onToChanged: (n) => searchController.ownershipTaxTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.horsepowerHp,
            fromCtrl: _enginePowerFromController,
            toCtrl: _enginePowerToController,
            fromVal: searchController.enginePowerKwFrom.value,
            toVal: searchController.enginePowerKwTo.value,
            min: 0,
            max: 1000,
            divisions: 100,
            onSliderChanged: (a, b) {
              searchController.enginePowerKwFrom.value = a;
              searchController.enginePowerKwTo.value = b;
              _enginePowerFromController.text = a > 0 ? a.toInt().toString() : '';
              _enginePowerToController.text = b < 1000 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.enginePowerKwFrom.value = n,
            onToChanged: (n) => searchController.enginePowerKwTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.batteryCapacityKwh,
            fromCtrl: _batteryFromController,
            toCtrl: _batteryToController,
            fromVal: searchController.electricalConsumptionFrom.value,
            toVal: searchController.electricalConsumptionTo.value,
            min: 0,
            max: 500,
            divisions: 50,
            onSliderChanged: (a, b) {
              searchController.electricalConsumptionFrom.value = a;
              searchController.electricalConsumptionTo.value = b;
              _batteryFromController.text = a > 0 ? a.toInt().toString() : '';
              _batteryToController.text = b < 500 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.electricalConsumptionFrom.value = n,
            onToChanged: (n) => searchController.electricalConsumptionTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.fuelEfficiency,
            fromCtrl: _fuelEfficiencyFromController,
            toCtrl: _fuelEfficiencyToController,
            fromVal: searchController.kmPerLiterFrom.value,
            toVal: searchController.kmPerLiterTo.value,
            min: 0,
            max: fuelEffMax,
            divisions: 200,
            allowDecimal: true,
            onSliderChanged: (a, b) {
              final af = (((a * 2).round() / 2).clamp(0.0, fuelEffMax) as num).toDouble();
              final bf = (((b * 2).round() / 2).clamp(0.0, fuelEffMax) as num).toDouble();
              searchController.kmPerLiterFrom.value = af;
              searchController.kmPerLiterTo.value = bf;
              _fuelEfficiencyFromController.text =
                  _kmPerLiterSliderText(af, isTo: false, maxVal: fuelEffMax);
              _fuelEfficiencyToController.text =
                  _kmPerLiterSliderText(bf, isTo: true, maxVal: fuelEffMax);
            },
            onFromChanged: (n) => searchController.kmPerLiterFrom.value = n.clamp(0, fuelEffMax),
            onToChanged: (n) => searchController.kmPerLiterTo.value = n.clamp(0, fuelEffMax),
          ),
        ],
      );
    });
  }
  Widget _physicalDetailsContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    const topSpeedMax = 400.0;
    const weightMax = 5000.0;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rangeRow(
            isDark: isDark,
            label: l10n.topSpeedKmh,
            fromCtrl: _topSpeedFromController,
            toCtrl: _topSpeedToController,
            fromVal: searchController.maxSpeedFrom.value,
            toVal: searchController.maxSpeedTo.value,
            min: 0,
            max: topSpeedMax,
            divisions: 80,
            onSliderChanged: (a, b) {
              searchController.maxSpeedFrom.value = a;
              searchController.maxSpeedTo.value = b;
              _topSpeedFromController.text = a > 0 ? a.toInt().toString() : '';
              _topSpeedToController.text = b < topSpeedMax ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.maxSpeedFrom.value = n,
            onToChanged: (n) => searchController.maxSpeedTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.weightKg,
            fromCtrl: _weightFromController,
            toCtrl: _weightToController,
            fromVal: searchController.maximumWeightKgFrom.value,
            toVal: searchController.maximumWeightKgTo.value,
            min: 0,
            max: weightMax,
            divisions: 50,
            onSliderChanged: (a, b) {
              searchController.maximumWeightKgFrom.value = a;
              searchController.maximumWeightKgTo.value = b;
              _weightFromController.text = a > 0 ? a.toInt().toString() : '';
              _weightToController.text = b < weightMax ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.maximumWeightKgFrom.value = n,
            onToChanged: (n) => searchController.maximumWeightKgTo.value = n,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _doorCountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.doors,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.doorCount.value = n.clamp(0, 10);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _seatsMinController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.seatsMin,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
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
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _seatsMaxController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.seatsMax,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.seatsMax.value = n.clamp(0, 20);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _axleCountController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.axles,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.axleCount.value = n.clamp(0, 10);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _airbagsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.airbags,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.specificationsAirbags.value = n.clamp(0, 20);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _towingWeightController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              hintText: l10n.minTowingWeight,
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
            onChanged: (v) {
              final n = int.tryParse(v);
              if (n != null) searchController.towingWeight.value = n.clamp(0, 10000);
            },
          ),
        ],
      );
    });
  }
  Widget _chargingContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.chargingType,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String?>(
                value: searchController.chargingType.value,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                hint: Text(l10n.all),
                items: [
                  DropdownMenuItem<String?>(value: null, child: Text(l10n.all)),
                  DropdownMenuItem<String?>(value: 'AC', child: Text(l10n.filterChargingAc)),
                  DropdownMenuItem<String?>(value: 'DC', child: Text(l10n.filterChargingDc)),
                  DropdownMenuItem<String?>(value: 'AC/DC', child: Text(l10n.filterChargingAcDc)),
                ],
                onChanged: (v) => searchController.chargingType.value = v,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 0,
            runSpacing: 0,
            children: [
              _wrapCheckboxChip(
                isDark,
                value: searchController.ncapTest.value,
                onTap: () => searchController.ncapTest.value = !searchController.ncapTest.value,
                label: l10n.filterNcapTest,
              ),
              _wrapCheckboxChip(
                isDark,
                value: searchController.isImport.value,
                onTap: () => searchController.isImport.value = !searchController.isImport.value,
                label: l10n.import,
              ),
              _wrapCheckboxChip(
                isDark,
                value: searchController.isFactoryNew.value,
                onTap: () => searchController.isFactoryNew.value = !searchController.isFactoryNew.value,
                label: l10n.factoryNew,
              ),
            ],
          ),
        ],
      );
    });
  }
  Widget _equipmentContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final cs = Get.find<ConstantsService>();
    final equipmentTypes = cs.getEquipmentTypes();
    final otherEquipments = cs.getEquipmentsWithoutType();
    if (equipmentTypes.isEmpty && otherEquipments.isEmpty) {
      return const SizedBox.shrink();
    }
    Widget equipmentWrap(List<EquipmentItem> equipments) {
      return Obx(() {
        return Wrap(
          spacing: 0,
          runSpacing: 0,
          children: equipments.map((e) {
            final selected = searchController.equipmentIds.contains(e.id);
            return _wrapCheckboxChip(
              isDark,
              value: selected,
              onTap: () {
                if (selected) {
                  searchController.equipmentIds.remove(e.id);
                } else {
                  searchController.equipmentIds.add(e.id);
                }
              },
              label: e.name,
            );
          }).toList(),
        );
      });
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                child: equipmentWrap(equipments),
              ),
            ],
          );
        }),
        if (otherEquipments.isNotEmpty)
          ExpansionTile(
            title: Text(
              l10n.equipmentOther,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, bottom: 12),
                child: equipmentWrap(otherEquipments),
              ),
            ],
          ),
      ],
    );
  }
  Widget _lookupNavigationTile({
    required BuildContext context,
    required bool isDark,
    required String label,
    required List<int> selectedIds,
    required Map<int, String> selectedNames,
    required VoidCallback onTap,
    required void Function(int id) onRemoveSelected,
    String? emptyHint,
  }) {
    final selectedLabel = selectedIds.isEmpty
        ? (emptyHint ?? AppLocalizations.of(context)!.all)
        : selectedIds.map((id) => selectedNames[id] ?? '#$id').join(', ');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: InputDecorator(
            decoration: InputDecoration(
              isDense: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              suffixIcon: Icon(Icons.expand_more, color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
            ),
            child: Text(
              selectedLabel,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 16,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ),
        ),
        if (selectedIds.isNotEmpty) ...[
          const SizedBox(height: 8),
          _selectedLookupChips(
            isDark: isDark,
            chips: selectedIds.map((id) {
              return _LookupChipData(
                id: id,
                label: selectedNames[id] ?? '#$id',
              );
            }).toList(),
            onRemove: onRemoveSelected,
          ),
        ],
      ],
    );
  }

  Widget _selectedLookupChips({
    required bool isDark,
    required List<_LookupChipData> chips,
    required void Function(int id) onRemove,
  }) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: chips.map((chip) {
        return InputChip(
          label: Text(
            chip.label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          onDeleted: () => onRemove(chip.id),
          deleteIcon: const Icon(Icons.close, size: 18),
          visualDensity: VisualDensity.compact,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          backgroundColor: isDark ? AppColors.cardDark : AppColors.borderLight.withValues(alpha: 0.5),
        );
      }).toList(),
    );
  }

  Widget _wrapCheckboxChip(bool isDark, {required bool value, required VoidCallback onTap, required String label}) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: value,
              onChanged: (_) => onTap(),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              activeColor: AppColors.primary,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 15,
                color: isDark ? AppColors.textDark : AppColors.textLight,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButtons(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
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
              _doorCountController.text = '';
              _seatsMinController.text = '';
              _seatsMaxController.text = '';
              _towingWeightController.text = '';
              _fuelEfficiencyFromController.text = '';
              _fuelEfficiencyToController.text = '';
              _topSpeedFromController.text = '';
              _topSpeedToController.text = '';
              _weightFromController.text = '';
              _weightToController.text = '';
              _axleCountController.text = '';
              _airbagsController.text = '';
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? AppColors.textDark : AppColors.textLight,
              side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(l10n.reset),
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
            child: Text(l10n.searchVehicles),
          ),
        ),
      ],
    );
  }
}

class _LookupChipData {
  final int id;
  final String label;

  const _LookupChipData({
    required this.id,
    required this.label,
  });
}
