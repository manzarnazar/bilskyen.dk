import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/constants_model/constants_model.dart';
import '../models/sell_vehicle_model/vehicle_lookup_response_model.dart';
import '../repositories/seller/seller_repository.dart';
import '../repositories/sell_vehicle/sell_vehicle_repository.dart';
import '../services/constants_service.dart';

class EditVehicleController extends GetxController {
  final SellerRepository _sellerRepo = SellerRepository();
  final SellVehicleRepository _sellVehicleRepo = SellVehicleRepository();
  final ConstantsService _constantsService = Get.find<ConstantsService>();

  final int vehicleId;

  EditVehicleController({required this.vehicleId});

  final RxBool isLoading = true.obs;
  final RxString loadError = ''.obs;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final Rx<int?> variantId = Rx<int?>(null);
  /// Shown when current variant id is not in [variants] (e.g. API-only trim).
  String? initialVariantName;
  /// Shown when current fuel type id is not in [fuelTypes].
  String? initialFuelTypeName;
  final Rx<int?> colorId = Rx<int?>(null);
  final Rx<int?> fuelTypeId = Rx<int?>(null);
  final kmDrivenController = TextEditingController();
  final Rx<int?> firstRegistrationMonth = Rx<int?>(null);
  final Rx<int?> firstRegistrationYear = Rx<int?>(null);
  final Rx<int?> lastInspectionMonth = Rx<int?>(null);
  final Rx<int?> lastInspectionYear = Rx<int?>(null);
  /// Matches web: Yes | No | Default
  final RxString servicebog = 'Default'.obs;
  final priceController = TextEditingController();
  final descriptionController = TextEditingController();
  final sellerPhoneController = TextEditingController();
  final sellerAddressController = TextEditingController();
  final sellerPostcodeController = TextEditingController();
  final technicalTotalWeightController = TextEditingController();
  final fuelEfficiencyController = TextEditingController();
  final Rx<int?> euronomId = Rx<int?>(null);
  final RxList<int> selectedEquipmentIds = <int>[].obs;

  final RxMap<String, bool> sectionExpanded = {
    'basic-info': true,
    'specifications': true,
    'equipment': true,
    'servicebog': true,
    'pricing': true,
    'description': true,
    'seller-info': true,
  }.obs;

  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxList<LookupItem> fuelTypes = <LookupItem>[].obs;
  final RxList<VariantModel> variants = <VariantModel>[].obs;
  final RxList<EquipmentModel> equipment = <EquipmentModel>[].obs;
  final RxList<EquipmentTypeModel> equipmentTypes = <EquipmentTypeModel>[].obs;
  final RxList<EuronomModel> euronorms = <EuronomModel>[].obs;

  final RxBool isSubmitting = false.obs;
  final RxBool isLoadingVariants = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadReferenceData();
    _loadVehicle();
  }

  @override
  void onClose() {
    titleController.dispose();
    kmDrivenController.dispose();
    descriptionController.dispose();
    sellerPhoneController.dispose();
    sellerAddressController.dispose();
    sellerPostcodeController.dispose();
    technicalTotalWeightController.dispose();
    fuelEfficiencyController.dispose();
    super.onClose();
  }

  void toggleSection(String id) {
    sectionExpanded[id] = !(sectionExpanded[id] ?? true);
  }

  Future<void> _loadReferenceData() async {
    if (_constantsService.getConstants() == null) {
      await _constantsService.fetchConstants();
    }
    final c = _constantsService.getConstants();
    if (c != null) {
      colors.value = c.colors.map((e) => ColorModel(id: e.id, name: e.name)).toList();
      fuelTypes.value = c.fuelTypes;
      variants.clear();
      equipment.value = c.equipments.map((e) => EquipmentModel(
        id: e.id,
        name: e.name,
        equipmentTypeId: e.equipmentTypeId,
      )).toList();
      equipmentTypes.value = c.equipmentTypes.map((e) => EquipmentTypeModel(id: e.id, name: e.name)).toList();
      euronorms.value = c.euronorms.map((e) => EuronomModel(id: e.id, name: e.name)).toList();
    }
  }

  Future<void> _loadVehicle() async {
    isLoading.value = true;
    loadError.value = '';
    final result = await _sellerRepo.getVehicle(vehicleId);
    final data = result.fold<Map<String, dynamic>?>(
      (err) {
        loadError.value = err;
        return null;
      },
      (v) => v,
    );
    if (data == null) {
      isLoading.value = false;
      return;
    }
    _mapVehicleToForm(data);
    final mid = data['model_id'];
    if (mid != null) {
      final id = mid is int ? mid : (mid as num).toInt();
      await _loadVariantsForDmrModel(id);
    }
    isLoading.value = false;
  }

  Future<void> _loadVariantsForDmrModel(int modelId) async {
    isLoadingVariants.value = true;
    try {
      final result = await _sellVehicleRepo.searchVariants(modelId: modelId);
      result.fold((_) => null, (list) => variants.value = list);
    } finally {
      isLoadingVariants.value = false;
    }
  }

  void _mapVehicleToForm(Map<String, dynamic> data) {
    titleController.text = data['title'] as String? ?? '';
    priceController.text = (data['price'] as num?)?.toString() ?? '';
    kmDrivenController.text = (data['km_driven'] as num?)?.toString() ?? '';
    firstRegistrationMonth.value = null;
    firstRegistrationYear.value = null;
    lastInspectionMonth.value = null;
    lastInspectionYear.value = null;

    final firstRegMonth = data['first_registration_month'];
    final firstRegYear = data['first_registration_year'];
    if (firstRegMonth != null && firstRegYear != null) {
      firstRegistrationMonth.value =
          firstRegMonth is int ? firstRegMonth : (firstRegMonth as num).toInt();
      firstRegistrationYear.value =
          firstRegYear is int ? firstRegYear : (firstRegYear as num).toInt();
    } else {
      final firstReg = data['first_registration_date'] as String?;
      if (firstReg != null && firstReg.isNotEmpty) {
        try {
          final parts = firstReg.split('-');
          if (parts.isNotEmpty) firstRegistrationYear.value = int.tryParse(parts[0]);
          if (parts.length >= 2) {
            final month = int.tryParse(parts[1]);
            firstRegistrationMonth.value =
                (month != null && month >= 1 && month <= 12) ? month : null;
          }
        } catch (_) {}
      }
    }

    final lastInspMonth = data['last_inspection_month'];
    final lastInspYear = data['last_inspection_year'];
    if (lastInspMonth != null && lastInspYear != null) {
      lastInspectionMonth.value =
          lastInspMonth is int ? lastInspMonth : (lastInspMonth as num).toInt();
      lastInspectionYear.value =
          lastInspYear is int ? lastInspYear : (lastInspYear as num).toInt();
    } else {
      final lastInsp = data['last_inspection_date'] as String?;
      if (lastInsp != null && lastInsp.isNotEmpty) {
        try {
          final parts = lastInsp.split('-');
          if (parts.isNotEmpty) lastInspectionYear.value = int.tryParse(parts[0]);
          if (parts.length >= 2) {
            final month = int.tryParse(parts[1]);
            lastInspectionMonth.value =
                (month != null && month >= 1 && month <= 12) ? month : null;
          }
        } catch (_) {}
      }
    }

    final sb = data['servicebog'] as String?;
    if (sb == 'Yes' || sb == 'No' || sb == 'Default') {
      servicebog.value = sb!;
    } else {
      servicebog.value = 'Default';
    }

    // Prefer km_per_liter (web/API); fallback fuel_efficiency
    final kml = data['km_per_liter'];
    if (kml != null) {
      fuelEfficiencyController.text = kml is num ? kml.toString() : kml.toString();
    }
    final fuelEff = data['fuel_efficiency'];
    if (fuelEfficiencyController.text.isEmpty && fuelEff != null) {
      if (fuelEff is num) {
        fuelEfficiencyController.text = fuelEff.toString();
      } else if (fuelEff is String && fuelEff.isNotEmpty) {
        fuelEfficiencyController.text = fuelEff;
      }
    }
    final details = data['details'] as Map<String, dynamic>?;
    if (details != null) {
      descriptionController.text = details['description'] as String? ?? '';
      if (technicalTotalWeightController.text.isEmpty) {
        final tw = details['technical_total_weight'];
        if (tw != null) {
          technicalTotalWeightController.text = tw.toString();
        }
      }
      if (fuelEfficiencyController.text.isEmpty &&
          (details['fuel_consumption_wltp'] != null || details['fuel_efficiency'] != null)) {
        fuelEfficiencyController.text =
            (details['fuel_consumption_wltp'] ?? details['fuel_efficiency']).toString();
      }
    }
    if (data['maximum_weight_kg'] != null) {
      technicalTotalWeightController.text = data['maximum_weight_kg'].toString();
    }
    if (descriptionController.text.isEmpty) {
      descriptionController.text = data['description'] as String? ?? '';
    }
    sellerPhoneController.text = (details?['seller_phone'] as String?) ??
        data['seller_phone'] as String? ??
        '';
    final eid = details != null
        ? (details['emission_norm_id'] ?? details['euronom_id'] ?? data['emission_norm_id'])
        : data['emission_norm_id'];
    euronomId.value =
        eid == null ? null : (eid is int ? eid : (eid as num).toInt());
    initialVariantName = data['variant_name'] as String?;
    final vidRoot = details != null ? details['variant_id'] : null;
    final vid = vidRoot ?? data['variant_id'];
    variantId.value = vid == null ? null : (vid is int ? vid : (vid as num).toInt());
    initialFuelTypeName = data['fuel_type_name'] as String?;
    final ftid = data['fuel_type_id'];
    fuelTypeId.value =
        ftid == null ? null : (ftid is int ? ftid : (ftid as num).toInt());
    final cidRoot = details != null ? details['color_id'] : null;
    final cid = cidRoot ?? data['color_id'] ?? data['colour_id'];
    colorId.value = cid == null ? null : (cid is int ? cid : (cid as num).toInt());
    sellerAddressController.text = data['seller_address'] as String? ?? '';
    sellerPostcodeController.text = data['seller_postcode'] as String? ?? '';

    final equipmentList = data['equipment'] as List<dynamic>?;
    if (equipmentList != null && equipmentList.isNotEmpty) {
      selectedEquipmentIds.value = equipmentList
          .map((e) => e is Map ? (e['id'] as num?)?.toInt() : (e is num ? e.toInt() : null))
          .whereType<int>()
          .toList();
    }
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    final priceVal = int.tryParse(priceController.text.trim());
    if (priceVal == null || priceVal < 0) {
      Get.snackbar('Error', 'Enter a valid price');
      return;
    }
    final kmVal = int.tryParse(kmDrivenController.text.trim());
    if (kmVal == null || kmVal < 0) {
      Get.snackbar('Error', 'Enter valid kilometer driven');
      return;
    }

    isSubmitting.value = true;

    // Same keys as seller-vehicle-edit.blade.php / SellerVehicleEditService
    final body = <String, dynamic>{
      'title': titleController.text.trim().isEmpty ? null : titleController.text.trim(),
      'price': priceVal,
      'km_driven': kmVal,
      'seller_address': sellerAddressController.text.trim(),
      'seller_postcode': sellerPostcodeController.text.trim(),
      'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
      'variant_id': variantId.value,
      'colour_id': colorId.value,
      'seller_phone': sellerPhoneController.text.trim(),
      'emission_norm_id': euronomId.value,
      'equipment_ids': selectedEquipmentIds.toList(),
      'servicebog': servicebog.value,
    };
    if (firstRegistrationMonth.value != null &&
        firstRegistrationYear.value != null) {
      body['first_registration_month'] = firstRegistrationMonth.value;
      body['first_registration_year'] = firstRegistrationYear.value;
    }
    if (lastInspectionMonth.value != null && lastInspectionYear.value != null) {
      body['last_inspection_month'] = lastInspectionMonth.value;
      body['last_inspection_year'] = lastInspectionYear.value;
    }
    if (technicalTotalWeightController.text.trim().isNotEmpty) {
      final w = int.tryParse(technicalTotalWeightController.text.trim());
      if (w != null) body['maximum_weight_kg'] = w;
    }
    if (fuelEfficiencyController.text.trim().isNotEmpty) {
      final f = double.tryParse(fuelEfficiencyController.text.trim());
      if (f != null) body['km_per_liter'] = f;
    }

    try {
      final result = await _sellerRepo.updateVehicle(vehicleId, body);
      result.fold(
        (err) {
          Get.snackbar('Error', err, snackPosition: SnackPosition.TOP);
        },
        (_) {
          Get.back(result: true);
          Future.delayed(const Duration(milliseconds: 300), () {
            Get.snackbar('Success', 'Vehicle updated', snackPosition: SnackPosition.TOP);
          });
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong', snackPosition: SnackPosition.TOP);
    } finally {
      isSubmitting.value = false;
    }
  }

  void toggleEquipment(int id) {
    if (selectedEquipmentIds.contains(id)) {
      selectedEquipmentIds.remove(id);
    } else {
      selectedEquipmentIds.add(id);
    }
  }

  List<EquipmentModel> getEquipmentByType(int? typeId) {
    if (typeId == null) return equipment.where((e) => e.equipmentTypeId == null).toList();
    return equipment.where((e) => e.equipmentTypeId == typeId).toList();
  }
}
