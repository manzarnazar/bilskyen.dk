import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/constants_service.dart';

/// Filter state for vehicle search; `buildFilterMap()` keys match the web vehicles sidebar
/// and POST `/api/v1/search-vehicles` whitelist.
class SearchViewController extends GetxController {
  /// Matches [vehicles.blade.php] aside sliders (price / km).
  static const int priceMax = 5000000;
  static const int mileageMax = 2000000;

  /// Matches Blade `max="2027"` on model year and first registration year inputs.
  static const int calendarYearMax = 2027;

  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchTextController = TextEditingController();

  ConstantsService get constantsService => Get.find<ConstantsService>();

  /// Optional listing sort key (same as web); included in body when set.
  final Rx<String?> sort = Rx<String?>(null);

  final Rx<int?> conditionId = Rx<int?>(null);
  final RxList<int> listingTypeIds = <int>[].obs;

  final RxDouble priceFrom = 0.0.obs;
  final RxDouble priceTo = priceMax.toDouble().obs;
  final RxDouble mileageFrom = 0.0.obs;
  final RxDouble mileageTo = mileageMax.toDouble().obs;

  /// Model year range; defaults = no filter (same idea as empty inputs on web).
  final RxInt modelYearFrom = 1950.obs;
  final RxInt modelYearTo = calendarYearMax.obs;

  final RxDouble ownershipTaxFrom = 0.0.obs;
  final RxDouble ownershipTaxTo = 20000.0.obs;

  final RxInt firstRegYearFrom = 1950.obs;
  final RxInt firstRegYearTo = calendarYearMax.obs;

  /// UI stores kW range (Blade uses `engine_power_kw_*` with HP label)
  final RxDouble enginePowerKwFrom = 0.0.obs;
  final RxDouble enginePowerKwTo = 1000.0.obs;

  /// Maps to `electrical_consumption_*` (Blade "battery" inputs)
  final RxDouble electricalConsumptionFrom = 0.0.obs;
  final RxDouble electricalConsumptionTo = 500.0.obs;

  final Rx<String?> chargingType = Rx<String?>(null);

  final RxInt doorCount = 0.obs;
  final RxInt seatsMin = 0.obs;
  final RxInt seatsMax = 0.obs;
  final RxInt axleCount = 0.obs;
  final RxInt specificationsAirbags = 0.obs;
  final RxInt towingWeight = 0.obs;

  final RxDouble kmPerLiterFrom = 0.0.obs;
  final RxDouble kmPerLiterTo = 100.0.obs;

  final RxDouble maxSpeedFrom = 0.0.obs;
  final RxDouble maxSpeedTo = 400.0.obs;
  final RxDouble maximumWeightKgFrom = 0.0.obs;
  final RxDouble maximumWeightKgTo = 5000.0.obs;

  final RxBool ncapTest = false.obs;
  final RxBool isImport = false.obs;
  final RxBool isFactoryNew = false.obs;

  final Rx<int?> brandId = Rx<int?>(null);
  final Rx<int?> modelId = Rx<int?>(null);
  final RxList<int> selectedBrandIds = <int>[].obs;
  final RxMap<int, String> selectedBrandNames = <int, String>{}.obs;
  final RxList<int> selectedModelIds = <int>[].obs;
  final RxMap<int, String> selectedModelNames = <int, String>{}.obs;
  final RxList<int> selectedVariantIds = <int>[].obs;
  final RxMap<int, String> selectedVariantNames = <int, String>{}.obs;

  final RxList<int> fuelTypeIds = <int>[].obs;
  final Rx<int?> gearTypeId = Rx<int?>(null);
  final Rx<int?> salesTypeId = Rx<int?>(null);
  final Rx<int?> bodyTypeId = Rx<int?>(null);
  final Rx<int?> colorId = Rx<int?>(null);
  final Rx<int?> priceTypeId = Rx<int?>(null);
  final Rx<int?> emissionNormId = Rx<int?>(null);
  final Rx<int?> useId = Rx<int?>(null);

  final RxList<int> equipmentIds = <int>[].obs;

  Future<void> ensureConstantsLoaded() async {
    if (constantsService.getConstants() == null) {
      await constantsService.fetchConstants();
    }
  }

  Map<String, dynamic> buildFilterMap() {
    final map = <String, dynamic>{};

    final search = searchTextController.text.trim();
    if (search.isNotEmpty) map['search'] = search;

    final s = sort.value;
    if (s != null && s.trim().isNotEmpty) map['sort'] = s.trim();

    final cid = conditionId.value;
    if (cid != null) map['condition_id'] = cid;

    if (listingTypeIds.isNotEmpty) {
      map['listing_type_id'] = listingTypeIds.toList();
    }

    if (priceFrom.value > 0) map['price_from'] = priceFrom.value.toInt();
    if (priceTo.value < priceMax) map['price_to'] = priceTo.value.toInt();

    if (selectedBrandIds.isNotEmpty) {
      map['brand_id'] = selectedBrandIds.toList();
    } else {
      final bid = brandId.value;
      if (bid != null) map['brand_id'] = bid;
    }

    if (selectedModelIds.isNotEmpty) {
      map['model_id'] = selectedModelIds.toList();
    } else {
      final mid = modelId.value;
      if (mid != null) map['model_id'] = mid;
    }

    if (selectedVariantIds.isNotEmpty) {
      map['variant_id'] = selectedVariantIds.toList();
    }

    if (mileageFrom.value > 0) map['km_driven_from'] = mileageFrom.value.toInt();
    if (mileageTo.value < mileageMax) map['km_driven_to'] = mileageTo.value.toInt();

    if (modelYearFrom.value > 1950) map['model_year_from'] = modelYearFrom.value;
    if (modelYearTo.value < calendarYearMax) map['model_year_to'] = modelYearTo.value;

    if (ownershipTaxFrom.value > 0) {
      map['ownership_tax_from'] = ownershipTaxFrom.value.toInt();
    }
    final defaultOwnershipTax = ownershipTaxFrom.value == 0 && ownershipTaxTo.value == 20000;
    if (!defaultOwnershipTax && ownershipTaxTo.value < 20001) {
      map['ownership_tax_to'] = ownershipTaxTo.value.toInt();
    }

    if (firstRegYearFrom.value > 1950) {
      map['first_registration_year_from'] = firstRegYearFrom.value;
    }
    if (firstRegYearTo.value < calendarYearMax) {
      map['first_registration_year_to'] = firstRegYearTo.value;
    }

    if (enginePowerKwFrom.value > 0) map['engine_power_kw_from'] = enginePowerKwFrom.value.toInt();
    final defaultEngineKw = enginePowerKwFrom.value == 0 && enginePowerKwTo.value == 1000;
    if (!defaultEngineKw && enginePowerKwTo.value < 1001) {
      map['engine_power_kw_to'] = enginePowerKwTo.value.toInt();
    }

    if (electricalConsumptionFrom.value > 0) {
      map['electrical_consumption_from'] = electricalConsumptionFrom.value.toInt();
    }
    final defaultElectrical = electricalConsumptionFrom.value == 0 && electricalConsumptionTo.value == 500;
    if (!defaultElectrical && electricalConsumptionTo.value < 501) {
      map['electrical_consumption_to'] = electricalConsumptionTo.value.toInt();
    }

    if (kmPerLiterFrom.value > 0) map['km_per_liter_from'] = kmPerLiterFrom.value;
    final defaultKmPerLiter = kmPerLiterFrom.value == 0 && kmPerLiterTo.value == 100;
    if (!defaultKmPerLiter && kmPerLiterTo.value < 101) {
      map['km_per_liter_to'] = kmPerLiterTo.value;
    }

    final ct = chargingType.value;
    if (ct != null && ct.isNotEmpty) map['charging_type'] = ct;

    if (maxSpeedFrom.value > 0) map['max_speed_from'] = maxSpeedFrom.value.toInt();
    final defaultMaxSpeed = maxSpeedFrom.value == 0 && maxSpeedTo.value == 400;
    if (!defaultMaxSpeed && maxSpeedTo.value < 401) {
      map['max_speed_to'] = maxSpeedTo.value.toInt();
    }

    if (maximumWeightKgFrom.value > 0) {
      map['maximum_weight_kg_from'] = maximumWeightKgFrom.value.toInt();
    }
    final defaultWeight = maximumWeightKgFrom.value == 0 && maximumWeightKgTo.value == 5000;
    if (!defaultWeight && maximumWeightKgTo.value < 5001) {
      map['maximum_weight_kg_to'] = maximumWeightKgTo.value.toInt();
    }

    if (doorCount.value > 0) map['door_count'] = doorCount.value;
    if (seatsMin.value > 0) map['seats_min'] = seatsMin.value;
    if (seatsMax.value > 0) map['seats_max'] = seatsMax.value;
    if (axleCount.value > 0) map['axle_count'] = axleCount.value;
    if (specificationsAirbags.value > 0) {
      map['specifications_airbags'] = specificationsAirbags.value;
    }
    if (towingWeight.value > 0) map['towing_weight'] = towingWeight.value;

    if (ncapTest.value) map['ncap_test'] = 1;
    if (isImport.value) map['is_import'] = 1;
    if (isFactoryNew.value) map['is_factory_new'] = 1;

    if (fuelTypeIds.isNotEmpty) map['fuel_type_id'] = fuelTypeIds.toList();

    final gt = gearTypeId.value;
    if (gt != null) map['gear_type_id'] = gt;

    final st = salesTypeId.value;
    if (st != null) map['sales_type_id'] = st;

    final bt = bodyTypeId.value;
    if (bt != null) map['body_type_id'] = bt;

    final col = colorId.value;
    if (col != null) map['color_id'] = col;

    final pt = priceTypeId.value;
    if (pt != null) map['price_type_id'] = pt;

    final en = emissionNormId.value;
    if (en != null) map['emission_norm_id'] = en;

    final uid = useId.value;
    if (uid != null) map['use_id'] = uid;

    if (equipmentIds.isNotEmpty) map['equipment_ids'] = equipmentIds.toList();

    return map;
  }

  void clearFilters() {
    sort.value = null;
    conditionId.value = null;
    listingTypeIds.clear();
    priceFrom.value = 0;
    priceTo.value = priceMax.toDouble();
    mileageFrom.value = 0;
    mileageTo.value = mileageMax.toDouble();
    modelYearFrom.value = 1950;
    modelYearTo.value = calendarYearMax;
    ownershipTaxFrom.value = 0;
    ownershipTaxTo.value = 20000;
    firstRegYearFrom.value = 1950;
    firstRegYearTo.value = calendarYearMax;
    enginePowerKwFrom.value = 0;
    enginePowerKwTo.value = 1000;
    electricalConsumptionFrom.value = 0;
    electricalConsumptionTo.value = 500;
    chargingType.value = null;
    doorCount.value = 0;
    seatsMin.value = 0;
    seatsMax.value = 0;
    axleCount.value = 0;
    specificationsAirbags.value = 0;
    towingWeight.value = 0;
    kmPerLiterFrom.value = 0;
    kmPerLiterTo.value = 100;
    maxSpeedFrom.value = 0;
    maxSpeedTo.value = 400;
    maximumWeightKgFrom.value = 0;
    maximumWeightKgTo.value = 5000;
    ncapTest.value = false;
    isImport.value = false;
    isFactoryNew.value = false;
    brandId.value = null;
    modelId.value = null;
    selectedBrandIds.clear();
    selectedBrandNames.clear();
    selectedModelIds.clear();
    selectedModelNames.clear();
    selectedVariantIds.clear();
    selectedVariantNames.clear();
    fuelTypeIds.clear();
    gearTypeId.value = null;
    salesTypeId.value = null;
    bodyTypeId.value = null;
    colorId.value = null;
    priceTypeId.value = null;
    emissionNormId.value = null;
    useId.value = null;
    equipmentIds.clear();
    searchTextController.clear();
  }

  void requestFocus() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (searchFocusNode.canRequestFocus) {
        searchFocusNode.requestFocus();
      }
    });
  }

  @override
  void onClose() {
    searchFocusNode.dispose();
    searchTextController.dispose();
    super.onClose();
  }
}
