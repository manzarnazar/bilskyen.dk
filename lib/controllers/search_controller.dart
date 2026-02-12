import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/constants_service.dart';

class SearchViewController extends GetxController {
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchTextController = TextEditingController();

  // Constants service for filter options (ensure loaded in onInit / when opening search)
  ConstantsService get constantsService => Get.find<ConstantsService>();

  // Search text (bound to search query param)
  final RxString searchQuery = ''.obs;

  // Segmented / single select
  final Rx<int?> conditionId = Rx<int?>(null); // null = All
  final RxList<int> listingTypeIds = <int>[].obs;

  // Ranges
  final RxDouble priceFrom = 0.0.obs;
  final RxDouble priceTo = 1000000.0.obs;
  final RxDouble mileageFrom = 0.0.obs;
  final RxDouble mileageTo = 500000.0.obs;
  final RxInt yearFrom = 1975.obs;
  final RxInt yearTo = 2026.obs; // current year + 1

  // Owner tax range
  final RxDouble ownershipTaxFrom = 0.0.obs;
  final RxDouble ownershipTaxTo = 100000.0.obs;

  // First registration year range
  final RxInt firstRegYearFrom = 1975.obs;
  final RxInt firstRegYearTo = 2026.obs;

  // Seller distance (km)
  final RxInt sellerDistanceKm = 0.obs;

  // Horsepower (hp) range
  final RxDouble enginePowerFrom = 0.0.obs;
  final RxDouble enginePowerTo = 1000.0.obs;

  // Battery capacity (kWh) range
  final RxDouble batteryCapacityFrom = 0.0.obs;
  final RxDouble batteryCapacityTo = 200.0.obs;

  // Range (km) - EV range
  final RxDouble rangeKmFrom = 0.0.obs;
  final RxDouble rangeKmTo = 1000.0.obs;

  // Charging type (dropdown: AC, DC, AC/DC)
  final Rx<String?> chargingType = Rx<String?>(null);

  // Doors (min), Seats (min)
  final RxInt doorsMin = 0.obs;
  final RxInt seatsMin = 0.obs;

  // Drive wheels (multi: fwd, rwd, awd)
  final RxList<String> driveAxles = <String>[].obs;

  // Vehicle details (dropdowns)
  final Rx<int?> brandId = Rx<int?>(null);
  final Rx<int?> modelId = Rx<int?>(null);
  final Rx<int?> categoryId = Rx<int?>(null);

  // Multi-select (checkbox groups)
  final RxList<int> conditionIds = <int>[].obs;
  final RxList<int> fuelTypeIds = <int>[].obs;
  final RxList<int> gearTypeIds = <int>[].obs;
  final RxList<int> salesTypeIds = <int>[].obs;
  final RxList<int> priceTypeIds = <int>[].obs;
  final RxList<int> bodyTypeIds = <int>[].obs;
  final RxList<int> listingTypeIdsMulti = <int>[].obs; // listing types as multi checkbox
  final RxList<int> euronormIds = <int>[].obs;
  final RxList<int> equipmentIds = <int>[].obs;

  /// Ensure constants are loaded (call when opening search if needed).
  Future<void> ensureConstantsLoaded() async {
    if (constantsService.getConstants() == null) {
      await constantsService.fetchConstants();
    }
  }

  /// Build query map for vehicles API. Keys match backend VehicleController::index / VehicleService.
  Map<String, dynamic> buildFilterMap() {
    final map = <String, dynamic>{};

    final search = searchTextController.text.trim();
    if (search.isNotEmpty) map['search'] = search;
    final cid = conditionId.value;
    if (cid != null) {
      map['condition_id'] = cid;
    } else if (conditionIds.isNotEmpty) {
      map['condition_id'] = conditionIds.length == 1 ? conditionIds.first : conditionIds.toList();
    }
    final listingIds = listingTypeIdsMulti.isNotEmpty ? listingTypeIdsMulti : listingTypeIds;
    if (listingIds.isNotEmpty) {
      map['listing_type_id'] = listingIds.toList();
    }
    if (priceFrom.value > 0) map['price_from'] = priceFrom.value.toInt();
    if (priceTo.value < 1000000) map['price_to'] = priceTo.value.toInt();
    final bid = brandId.value;
    if (bid != null) map['brand_id'] = bid;
    final mid = modelId.value;
    if (mid != null) map['model_id'] = mid;
    final cid2 = categoryId.value;
    if (cid2 != null) map['category_id'] = cid2;
    if (mileageFrom.value > 0) map['mileage_from'] = mileageFrom.value.toInt();
    if (mileageTo.value < 500000) map['mileage_to'] = mileageTo.value.toInt();
    if (yearFrom.value > 1975) map['year_from'] = yearFrom.value;
    if (yearTo.value < 2026) map['year_to'] = yearTo.value;

    if (ownershipTaxFrom.value > 0) map['ownership_tax_from'] = ownershipTaxFrom.value.toInt();
    if (ownershipTaxTo.value < 100000) map['ownership_tax_to'] = ownershipTaxTo.value.toInt();
    if (firstRegYearFrom.value > 1975) map['first_registration_year_from'] = firstRegYearFrom.value;
    if (firstRegYearTo.value < 2026) map['first_registration_year_to'] = firstRegYearTo.value;
    if (sellerDistanceKm.value > 0) map['seller_distance'] = sellerDistanceKm.value;
    if (enginePowerFrom.value > 0) map['engine_power_from'] = enginePowerFrom.value.toInt();
    if (enginePowerTo.value < 1000) map['engine_power_to'] = enginePowerTo.value.toInt();
    if (batteryCapacityFrom.value > 0) map['battery_capacity_from'] = batteryCapacityFrom.value.toInt();
    if (batteryCapacityTo.value < 200) map['battery_capacity_to'] = batteryCapacityTo.value.toInt();
    if (rangeKmFrom.value > 0) map['range_km_from'] = rangeKmFrom.value.toInt();
    if (rangeKmTo.value < 1000) map['range_km_to'] = rangeKmTo.value.toInt();
    final ct = chargingType.value;
    if (ct != null && ct.isNotEmpty) map['charging_type'] = ct;
    if (doorsMin.value > 0) map['doors'] = doorsMin.value;
    if (seatsMin.value > 0) map['seats_min'] = seatsMin.value;
    if (driveAxles.isNotEmpty) map['drive_axles'] = driveAxles.toList();

    if (fuelTypeIds.isNotEmpty) map['fuel_type_id'] = fuelTypeIds.toList();
    if (gearTypeIds.isNotEmpty) map['gear_type_id'] = gearTypeIds.toList();
    if (salesTypeIds.isNotEmpty) map['sales_type_id'] = salesTypeIds.toList();
    if (priceTypeIds.isNotEmpty) map['price_type_id'] = priceTypeIds.toList();
    if (bodyTypeIds.isNotEmpty) map['body_type_id'] = bodyTypeIds.toList();
    if (euronormIds.isNotEmpty) {
      final euronorms = constantsService.getEuronorms();
      for (final e in euronorms) {
        if (euronormIds.contains(e.id)) {
          map['euronorm'] = e.name;
          break;
        }
      }
    }
    if (equipmentIds.isNotEmpty) map['equipment_ids'] = equipmentIds.toList();

    return map;
  }

  /// Clear all filter selections.
  void clearFilters() {
    conditionId.value = null;
    conditionIds.clear();
    listingTypeIds.clear();
    priceFrom.value = 0;
    priceTo.value = 1000000;
    mileageFrom.value = 0;
    mileageTo.value = 500000;
    yearFrom.value = 1975;
    yearTo.value = DateTime.now().year + 1;
    ownershipTaxFrom.value = 0;
    ownershipTaxTo.value = 100000;
    firstRegYearFrom.value = 1975;
    firstRegYearTo.value = DateTime.now().year + 1;
    sellerDistanceKm.value = 0;
    enginePowerFrom.value = 0;
    enginePowerTo.value = 1000;
    batteryCapacityFrom.value = 0;
    batteryCapacityTo.value = 200;
    rangeKmFrom.value = 0;
    rangeKmTo.value = 1000;
    chargingType.value = null;
    doorsMin.value = 0;
    seatsMin.value = 0;
    driveAxles.clear();
    brandId.value = null;
    modelId.value = null;
    categoryId.value = null;
    fuelTypeIds.clear();
    gearTypeIds.clear();
    salesTypeIds.clear();
    priceTypeIds.clear();
    bodyTypeIds.clear();
    listingTypeIdsMulti.clear();
    euronormIds.clear();
    equipmentIds.clear();
    searchQuery.value = '';
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
