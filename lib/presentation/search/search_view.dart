import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
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
  late final TextEditingController _seatsMaxController;
  late final TextEditingController _towingWeightController;
  late final TextEditingController _fuelEfficiencyFromController;
  late final TextEditingController _fuelEfficiencyToController;
  late final TextEditingController _topSpeedFromController;
  late final TextEditingController _topSpeedToController;
  late final TextEditingController _weightFromController;
  late final TextEditingController _weightToController;
  late final TextEditingController _engineDisplacementFromController;
  late final TextEditingController _engineDisplacementToController;
  late final TextEditingController _engineCylindersController;
  late final TextEditingController _wheelsController;
  late final TextEditingController _axlesController;
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
    _seatsMaxController = TextEditingController();
    _towingWeightController = TextEditingController();
    _fuelEfficiencyFromController = TextEditingController();
    _fuelEfficiencyToController = TextEditingController();
    _topSpeedFromController = TextEditingController();
    _topSpeedToController = TextEditingController();
    _weightFromController = TextEditingController();
    _weightToController = TextEditingController();
    _engineDisplacementFromController = TextEditingController();
    _engineDisplacementToController = TextEditingController();
    _engineCylindersController = TextEditingController();
    _wheelsController = TextEditingController();
    _axlesController = TextEditingController();
    _airbagsController = TextEditingController();
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
    _seatsMaxController.dispose();
    _towingWeightController.dispose();
    _fuelEfficiencyFromController.dispose();
    _fuelEfficiencyToController.dispose();
    _topSpeedFromController.dispose();
    _topSpeedToController.dispose();
    _weightFromController.dispose();
    _weightToController.dispose();
    _engineDisplacementFromController.dispose();
    _engineDisplacementToController.dispose();
    _engineCylindersController.dispose();
    _wheelsController.dispose();
    _axlesController.dispose();
    _airbagsController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final constants = Get.find<ConstantsService>().getConstants();
      final l10n = AppLocalizations.of(context)!;
      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: constants == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(),
                      const SizedBox(height: 16),
                      Text(
                        l10n.loadingFilters,
                        style: TextStyle(
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                        ),
                      ),
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
                              searchController.gearTypeIds.isNotEmpty ||
                              searchController.bodyTypeIds.isNotEmpty,
                          child: _fuelBodyContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: '${l10n.color} / ${l10n.type}',
                          initiallyExpanded: searchController.colorIds.isNotEmpty ||
                              searchController.typeIds.isNotEmpty ||
                              searchController.salesTypeIds.isNotEmpty ||
                              searchController.priceTypeIds.isNotEmpty ||
                              searchController.euronormIds.isNotEmpty ||
                              searchController.useIds.isNotEmpty,
                          child: _colorTypeContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: '${l10n.modelYear} / ${l10n.horsepowerHp}',
                          initiallyExpanded: false,
                          child: _modelYearHpContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: l10n.physicalDetails,
                          initiallyExpanded: searchController.topSpeedFrom.value > 0 ||
                              searchController.topSpeedTo.value < 300 ||
                              searchController.weightFrom.value > 0 ||
                              searchController.weightTo.value < 5000 ||
                              searchController.engineDisplacementFrom.value > 0 ||
                              searchController.engineDisplacementTo.value < 10000 ||
                              searchController.engineCylinders.value > 0 ||
                              searchController.doorsMin.value > 0 ||
                              searchController.seatsMin.value > 0 ||
                              searchController.seatsMax.value > 0 ||
                              searchController.wheels.value > 0 ||
                              searchController.axles.value > 0 ||
                              searchController.airbags.value > 0 ||
                              searchController.driveAxles.isNotEmpty ||
                              searchController.towingWeight.value > 0,
                          child: _physicalDetailsContent(context, isDark),
                        ),
                        _expandableFilterSection(
                          context: context,
                          isDark: isDark,
                          title: l10n.chargingType,
                          initiallyExpanded: searchController.chargingType.value != null ||
                              searchController.ncapFive.value ||
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
          searchController.conditionIds.clear();
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
    final types = allTypes.where((t) => t.name == 'Purchase' || t.name == 'Leasing').toList();
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
                label: t.name,
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
    final brands = cs.getBrands();
    return Obx(() {
      final brandId = searchController.brandId.value;
      final models = brandId != null ? cs.getModelsByBrandId(brandId) : <ModelItem>[];
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBrandSelectorTile(context, isDark, l10n, brands, searchController.brandId.value),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.model,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<int?>(
                value: searchController.modelId.value,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                hint: Text(brandId == null ? l10n.selectBrandFirst : l10n.all),
                items: [
                  DropdownMenuItem<int?>(value: null, child: Text(l10n.all)),
                  ...models.map((m) => DropdownMenuItem<int?>(value: m.id, child: Text(m.name))),
                ],
                onChanged: brandId == null ? null : (v) => searchController.modelId.value = v,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.modelYear,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<int?>(
                value: searchController.modelYearId.value,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                hint: Text(l10n.all),
                items: [
                  DropdownMenuItem<int?>(value: null, child: Text(l10n.all)),
                  ...cs.getModelYears().map((y) => DropdownMenuItem<int?>(value: y.id, child: Text(y.name))),
                ],
                onChanged: (v) => searchController.modelYearId.value = v,
              ),
            ],
          ),
        ],
      );
    });
  }
  Widget _priceKmContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    return Obx(() {
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
                    hintText: l10n.max,
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
                    hintText: l10n.max,
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
          Row(
            children: [
              Expanded(
                child: _singleSelectDropdown(
                  isDark: isDark,
                  label: l10n.fuelType,
                  value: searchController.fuelTypeIds.isNotEmpty ? searchController.fuelTypeIds.first : null,
                  items: cs.getFuelTypes(),
                  onChanged: (v) {
                    searchController.fuelTypeIds.clear();
                    if (v != null) searchController.fuelTypeIds.add(v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _singleSelectDropdown(
                  isDark: isDark,
                  label: l10n.gearType,
                  value: searchController.gearTypeIds.isNotEmpty ? searchController.gearTypeIds.first : null,
                  items: cs.getGearTypes(),
                  onChanged: (v) {
                    searchController.gearTypeIds.clear();
                    if (v != null) searchController.gearTypeIds.add(v);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _singleSelectDropdown(
            isDark: isDark,
            label: l10n.bodyTypes,
            value: searchController.bodyTypeIds.isNotEmpty ? searchController.bodyTypeIds.first : null,
            items: cs.getBodyTypes(),
            onChanged: (v) {
              searchController.bodyTypeIds.clear();
              if (v != null) searchController.bodyTypeIds.add(v);
            },
          ),
        ],
      );
    });
  }
  Widget _colorTypeContent(BuildContext context, bool isDark) {
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
                  searchController.colorIds.isNotEmpty ? searchController.colorIds.first : null,
                  cs.getColors(),
                  (v) {
                    searchController.colorIds.clear();
                    if (v != null) searchController.colorIds.add(v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: dropdown(
                  l10n.type,
                  searchController.typeIds.isNotEmpty ? searchController.typeIds.first : null,
                  cs.getTypes(),
                  (v) {
                    searchController.typeIds.clear();
                    if (v != null) searchController.typeIds.add(v);
                  },
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
                  l10n.salesType,
                  searchController.salesTypeIds.isNotEmpty ? searchController.salesTypeIds.first : null,
                  cs.getSalesTypes(),
                  (v) {
                    searchController.salesTypeIds.clear();
                    if (v != null) searchController.salesTypeIds.add(v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: dropdown(
                  l10n.priceType,
                  searchController.priceTypeIds.isNotEmpty ? searchController.priceTypeIds.first : null,
                  cs.getPriceTypes(),
                  (v) {
                    searchController.priceTypeIds.clear();
                    if (v != null) searchController.priceTypeIds.add(v);
                  },
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
                  searchController.euronormIds.isNotEmpty ? searchController.euronormIds.first : null,
                  cs.getEuronorms(),
                  (v) {
                    searchController.euronormIds.clear();
                    if (v != null) searchController.euronormIds.add(v);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: dropdown(
                  l10n.use,
                  searchController.useIds.isNotEmpty ? searchController.useIds.first : null,
                  cs.getVehicleUses(),
                  (v) {
                    searchController.useIds.clear();
                    if (v != null) searchController.useIds.add(v);
                  },
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
  }) {
    final l10n = AppLocalizations.of(context)!;
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
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: l10n.from,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) {
                  final n = double.tryParse(v);
                  if (n != null) onFromChanged(n);
                },
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: toCtrl,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: l10n.to,
                  isDense: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onChanged: (v) {
                  final n = double.tryParse(v);
                  if (n != null) onToChanged(n);
                },
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: RangeSlider(
            values: RangeValues(fromVal.clamp(min, max), toVal.clamp(min, max)),
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
    final currentYear = DateTime.now().year + 1;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rangeRow(
            isDark: isDark,
            label: l10n.modelYear,
            fromCtrl: _yearFromController,
            toCtrl: _yearToController,
            fromVal: searchController.yearFrom.value.toDouble(),
            toVal: searchController.yearTo.value.toDouble(),
            min: 1975,
            max: currentYear.toDouble(),
            divisions: currentYear - 1975,
            onSliderChanged: (a, b) {
              searchController.yearFrom.value = a.toInt();
              searchController.yearTo.value = b.toInt();
              _yearFromController.text = a > 1975 ? a.toInt().toString() : '';
              _yearToController.text = b < currentYear ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.yearFrom.value = n.clamp(1975, currentYear).toInt(),
            onToChanged: (n) => searchController.yearTo.value = n.clamp(1975, currentYear).toInt(),
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.firstRegistrationYear,
            fromCtrl: _firstRegYearFromController,
            toCtrl: _firstRegYearToController,
            fromVal: searchController.firstRegYearFrom.value.toDouble(),
            toVal: searchController.firstRegYearTo.value.toDouble(),
            min: 1975,
            max: currentYear.toDouble(),
            divisions: currentYear - 1975,
            onSliderChanged: (a, b) {
              searchController.firstRegYearFrom.value = a.toInt();
              searchController.firstRegYearTo.value = b.toInt();
              _firstRegYearFromController.text = a > 1975 ? a.toInt().toString() : '';
              _firstRegYearToController.text = b < currentYear ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.firstRegYearFrom.value = n.clamp(1975, currentYear).toInt(),
            onToChanged: (n) => searchController.firstRegYearTo.value = n.clamp(1975, currentYear).toInt(),
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
            max: 100000,
            divisions: 100,
            onSliderChanged: (a, b) {
              searchController.ownershipTaxFrom.value = a;
              searchController.ownershipTaxTo.value = b;
              _ownershipTaxFromController.text = a > 0 ? a.toInt().toString() : '';
              _ownershipTaxToController.text = b < 100000 ? b.toInt().toString() : '';
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
            fromVal: searchController.enginePowerFrom.value,
            toVal: searchController.enginePowerTo.value,
            min: 0,
            max: 1000,
            divisions: 100,
            onSliderChanged: (a, b) {
              searchController.enginePowerFrom.value = a;
              searchController.enginePowerTo.value = b;
              _enginePowerFromController.text = a > 0 ? a.toInt().toString() : '';
              _enginePowerToController.text = b < 1000 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.enginePowerFrom.value = n,
            onToChanged: (n) => searchController.enginePowerTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.batteryCapacityKwh,
            fromCtrl: _batteryFromController,
            toCtrl: _batteryToController,
            fromVal: searchController.batteryCapacityFrom.value,
            toVal: searchController.batteryCapacityTo.value,
            min: 0,
            max: 200,
            divisions: 50,
            onSliderChanged: (a, b) {
              searchController.batteryCapacityFrom.value = a;
              searchController.batteryCapacityTo.value = b;
              _batteryFromController.text = a > 0 ? a.toInt().toString() : '';
              _batteryToController.text = b < 200 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.batteryCapacityFrom.value = n,
            onToChanged: (n) => searchController.batteryCapacityTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.rangeKm,
            fromCtrl: _rangeKmFromController,
            toCtrl: _rangeKmToController,
            fromVal: searchController.rangeKmFrom.value,
            toVal: searchController.rangeKmTo.value,
            min: 0,
            max: 1000,
            divisions: 50,
            onSliderChanged: (a, b) {
              searchController.rangeKmFrom.value = a;
              searchController.rangeKmTo.value = b;
              _rangeKmFromController.text = a > 0 ? a.toInt().toString() : '';
              _rangeKmToController.text = b < 1000 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.rangeKmFrom.value = n,
            onToChanged: (n) => searchController.rangeKmTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.fuelEfficiency,
            fromCtrl: _fuelEfficiencyFromController,
            toCtrl: _fuelEfficiencyToController,
            fromVal: searchController.fuelEfficiencyFrom.value,
            toVal: searchController.fuelEfficiencyTo.value,
            min: 0,
            max: 100,
            divisions: 50,
            onSliderChanged: (a, b) {
              searchController.fuelEfficiencyFrom.value = a;
              searchController.fuelEfficiencyTo.value = b;
              _fuelEfficiencyFromController.text = a > 0 ? a.toInt().toString() : '';
              _fuelEfficiencyToController.text = b < 100 ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.fuelEfficiencyFrom.value = n,
            onToChanged: (n) => searchController.fuelEfficiencyTo.value = n,
          ),
        ],
      );
    });
  }
  Widget _physicalDetailsContent(BuildContext context, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    const topSpeedMax = 300.0;
    const weightMax = 5000.0;
    const engineDispMax = 10000.0;
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _rangeRow(
            isDark: isDark,
            label: l10n.topSpeedKmh,
            fromCtrl: _topSpeedFromController,
            toCtrl: _topSpeedToController,
            fromVal: searchController.topSpeedFrom.value,
            toVal: searchController.topSpeedTo.value,
            min: 0,
            max: topSpeedMax,
            divisions: 60,
            onSliderChanged: (a, b) {
              searchController.topSpeedFrom.value = a;
              searchController.topSpeedTo.value = b;
              _topSpeedFromController.text = a > 0 ? a.toInt().toString() : '';
              _topSpeedToController.text = b < topSpeedMax ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.topSpeedFrom.value = n,
            onToChanged: (n) => searchController.topSpeedTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.weightKg,
            fromCtrl: _weightFromController,
            toCtrl: _weightToController,
            fromVal: searchController.weightFrom.value,
            toVal: searchController.weightTo.value,
            min: 0,
            max: weightMax,
            divisions: 50,
            onSliderChanged: (a, b) {
              searchController.weightFrom.value = a;
              searchController.weightTo.value = b;
              _weightFromController.text = a > 0 ? a.toInt().toString() : '';
              _weightToController.text = b < weightMax ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.weightFrom.value = n,
            onToChanged: (n) => searchController.weightTo.value = n,
          ),
          const SizedBox(height: 16),
          _rangeRow(
            isDark: isDark,
            label: l10n.engineDisplacementCc,
            fromCtrl: _engineDisplacementFromController,
            toCtrl: _engineDisplacementToController,
            fromVal: searchController.engineDisplacementFrom.value,
            toVal: searchController.engineDisplacementTo.value,
            min: 0,
            max: engineDispMax,
            divisions: 100,
            onSliderChanged: (a, b) {
              searchController.engineDisplacementFrom.value = a;
              searchController.engineDisplacementTo.value = b;
              _engineDisplacementFromController.text = a > 0 ? a.toInt().toString() : '';
              _engineDisplacementToController.text = b < engineDispMax ? b.toInt().toString() : '';
            },
            onFromChanged: (n) => searchController.engineDisplacementFrom.value = n,
            onToChanged: (n) => searchController.engineDisplacementTo.value = n,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _engineCylindersController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.cylinders,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.engineCylinders.value = n.clamp(0, 16);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _doorsMinController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.doorsMin,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
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
                  controller: _wheelsController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: l10n.wheels,
                    labelStyle: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight, fontSize: 12),
                    isDense: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                  onChanged: (v) {
                    final n = int.tryParse(v);
                    if (n != null) searchController.wheels.value = n.clamp(0, 20);
                  },
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _axlesController,
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
                    if (n != null) searchController.axles.value = n.clamp(0, 10);
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
                    if (n != null) searchController.airbags.value = n.clamp(0, 20);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.driveWheels,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 6),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _wrapCheckboxChip(
                isDark,
                value: searchController.driveAxles.contains('fwd'),
                onTap: () {
                  if (searchController.driveAxles.contains('fwd')) {
                    searchController.driveAxles.remove('fwd');
                  } else {
                    searchController.driveAxles.add('fwd');
                  }
                },
                label: l10n.driveWheelFwd,
              ),
              _wrapCheckboxChip(
                isDark,
                value: searchController.driveAxles.contains('rwd'),
                onTap: () {
                  if (searchController.driveAxles.contains('rwd')) {
                    searchController.driveAxles.remove('rwd');
                  } else {
                    searchController.driveAxles.add('rwd');
                  }
                },
                label: l10n.driveWheelRwd,
              ),
              _wrapCheckboxChip(
                isDark,
                value: searchController.driveAxles.contains('awd'),
                onTap: () {
                  if (searchController.driveAxles.contains('awd')) {
                    searchController.driveAxles.remove('awd');
                  } else {
                    searchController.driveAxles.add('awd');
                  }
                },
                label: l10n.driveWheelAwd,
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
                  const DropdownMenuItem<String?>(value: 'AC', child: Text('AC')),
                  const DropdownMenuItem<String?>(value: 'DC', child: Text('DC')),
                  const DropdownMenuItem<String?>(value: 'AC/DC', child: Text('AC/DC')),
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
                value: searchController.ncapFive.value,
                onTap: () => searchController.ncapFive.value = !searchController.ncapFive.value,
                label: l10n.ncapFiveStar,
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
    final cs = Get.find<ConstantsService>();
    final equipmentTypes = cs.getEquipmentTypes();
    if (equipmentTypes.isEmpty) return const SizedBox.shrink();
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
                child: Obx(() {
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
                }),
              ),
            ],
          );
        }),
      ],
    );
  }
  Widget _buildBrandSelectorTile(
    BuildContext context,
    bool isDark,
    AppLocalizations l10n,
    List<LookupItem> brands,
    int? selectedBrandId,
  ) {
    LookupItem? selectedBrand;
    if (selectedBrandId != null) {
      try {
        selectedBrand = brands.firstWhere((b) => b.id == selectedBrandId);
      } catch (_) {
        selectedBrand = null;
      }
    }
    final displayText = selectedBrand?.name ?? l10n.all;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          l10n.brand,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        ),
        const SizedBox(height: 6),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => Get.toNamed('/brand-selector'),
            borderRadius: BorderRadius.circular(8),
            child: InputDecorator(
              decoration: InputDecoration(
                isDense: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                suffixIcon: Icon(Icons.chevron_right, color: isDark ? AppColors.mutedDark : AppColors.mutedLight, size: 24),
              ),
              child: Text(
                displayText,
                style: TextStyle(
                  fontSize: 16,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ),
          ),
        ),
      ],
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
              _rangeKmFromController.text = '';
              _rangeKmToController.text = '';
              _sellerDistanceController.text = '';
              _doorsMinController.text = '';
              _seatsMinController.text = '';
              _seatsMaxController.text = '';
              _towingWeightController.text = '';
              _fuelEfficiencyFromController.text = '';
              _fuelEfficiencyToController.text = '';
              _topSpeedFromController.text = '';
              _topSpeedToController.text = '';
              _weightFromController.text = '';
              _weightToController.text = '';
              _engineDisplacementFromController.text = '';
              _engineDisplacementToController.text = '';
              _engineCylindersController.text = '';
              _wheelsController.text = '';
              _axlesController.text = '';
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
