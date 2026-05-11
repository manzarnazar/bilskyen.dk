import 'package:get/get.dart';
import 'package:bilskyen/models/constants_model/constants_model.dart';
import 'package:bilskyen/repositories/constants/constants_repository.dart';

class ConstantsService extends GetxService {
  final ConstantsRepository _repository = ConstantsRepository();
  
  final Rx<ConstantsModel?> constants = Rx<ConstantsModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Try to load cached constants first
    _loadCachedConstants();
  }

  /// Load constants from cache
  void _loadCachedConstants() {
    final cached = _repository.getCachedConstants();
    if (cached != null) {
      constants.value = cached;
    }
  }

  /// Fetch constants from API
  Future<bool> fetchConstants() async {
    isLoading.value = true;
    error.value = '';
    
    try {
      final result = await _repository.getConstants();
      
      return result.fold(
        (errorMessage) {
          error.value = errorMessage;
          isLoading.value = false;
          return false;
        },
        (constantsData) {
          constants.value = constantsData;
          isLoading.value = false;
          return true;
        },
      );
    } catch (e) {
      error.value = 'Unexpected error: $e';
      isLoading.value = false;
      return false;
    }
  }

  /// Get constants (returns cached if available, otherwise null)
  ConstantsModel? getConstants() => constants.value;

  /// Helper methods to get specific lookup lists
  List<LookupItem> getBrands() => constants.value?.brands ?? [];
  List<LookupItem> getFuelTypes() => constants.value?.fuelTypes ?? [];
  List<LookupItem> getTransmissions() => constants.value?.transmissions ?? [];
  List<LookupItem> getGearTypes() => constants.value?.gearTypes ?? [];
  List<LookupItem> getVehicleUses() => constants.value?.vehicleUses ?? [];
  List<LookupItem> getSalesTypes() => constants.value?.salesTypes ?? [];
  List<LookupItem> getPriceTypes() => constants.value?.priceTypes ?? [];
  List<LookupItem> getConditions() => constants.value?.conditions ?? [];
  List<LookupItem> getVariants() => constants.value?.variants ?? [];
  List<LookupItem> getCategories() => constants.value?.categories ?? [];
  List<LookupItem> getBodyTypes() => constants.value?.bodyTypes ?? [];
  List<LookupItem> getColors() => constants.value?.colors ?? [];
  List<LookupItem> getTypes() => constants.value?.types ?? [];
  List<LookupItem> getPermits() => constants.value?.permits ?? [];
  List<LookupItem> getModelYears() => constants.value?.modelYears ?? [];
  List<LookupItem> getListingTypes() => constants.value?.listingTypes ?? [];
  List<LookupItem> getEquipmentTypes() => constants.value?.equipmentTypes ?? [];
  List<LookupItem> getEuronorms() => constants.value?.euronorms ?? [];
  List<ModelItem> getModels() => constants.value?.models ?? [];
  List<EquipmentItem> getEquipments() => constants.value?.equipments ?? [];

  /// Get models filtered by brand ID
  List<ModelItem> getModelsByBrandId(int brandId) {
    return getModels().where((model) => model.brandId == brandId).toList();
  }

  Future<List<LookupItem>> searchBrands({
    String? search,
    int limit = 25,
  }) async {
    final result = await _repository.searchBrands(search: search, limit: limit);
    return result.fold((_) => <LookupItem>[], (items) => items);
  }

  Future<List<ModelItem>> searchModels({
    String? search,
    List<int> brandIds = const [],
    int limit = 25,
  }) async {
    final result = await _repository.searchModels(
      search: search,
      brandIds: brandIds,
      limit: limit,
    );
    return result.fold((_) => <ModelItem>[], (items) => items);
  }

  /// Models that appear on published listings (same as web vehicle filters).
  Future<List<ModelItem>> searchListingModels({
    String? search,
    List<int> brandIds = const [],
    int limit = 25,
  }) async {
    final result = await _repository.searchListingModels(
      search: search,
      brandIds: brandIds,
      limit: limit,
    );
    return result.fold((_) => <ModelItem>[], (items) => items);
  }

  Future<List<VariantItem>> searchVariants({
    String? search,
    List<int> modelIds = const [],
    int limit = 25,
  }) async {
    final result = await _repository.searchVariants(
      search: search,
      modelIds: modelIds,
      limit: limit,
    );
    return result.fold((_) => <VariantItem>[], (items) => items);
  }

  /// Get equipments filtered by equipment type ID
  List<EquipmentItem> getEquipmentsByTypeId(int equipmentTypeId) {
    return getEquipments()
        .where((equipment) => equipment.equipmentTypeId == equipmentTypeId)
        .toList();
  }

  /// Equipments with no type (same as web `equipment_other` group).
  List<EquipmentItem> getEquipmentsWithoutType() {
    return getEquipments().where((e) => e.equipmentTypeId == null).toList();
  }
}
