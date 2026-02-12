import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/sell_vehicle_model/vehicle_lookup_response_model.dart';
import '../repositories/seller/seller_repository.dart';
import '../services/constants_service.dart';

class EditVehicleController extends GetxController {
  final SellerRepository _sellerRepo = SellerRepository();
  final ConstantsService _constantsService = Get.find<ConstantsService>();

  final int vehicleId;

  EditVehicleController({required this.vehicleId});

  final RxBool isLoading = true.obs;
  final RxString loadError = ''.obs;

  final formKey = GlobalKey<FormState>();
  final titleController = TextEditingController();
  final Rx<int?> variantId = Rx<int?>(null);
  final Rx<int?> colorId = Rx<int?>(null);
  final kmDrivenController = TextEditingController();
  final Rx<int?> firstRegistrationMonth = Rx<int?>(null);
  final Rx<int?> firstRegistrationYear = Rx<int?>(null);
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
    'pricing': true,
    'description': true,
    'seller-info': true,
  }.obs;

  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxList<VariantModel> variants = <VariantModel>[].obs;
  final RxList<EquipmentModel> equipment = <EquipmentModel>[].obs;
  final RxList<EquipmentTypeModel> equipmentTypes = <EquipmentTypeModel>[].obs;
  final RxList<EuronomModel> euronorms = <EuronomModel>[].obs;

  final RxBool isSubmitting = false.obs;

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
      variants.value = c.variants.map((e) => VariantModel(id: e.id, name: e.name)).toList();
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
    result.fold(
      (err) {
        loadError.value = err;
        isLoading.value = false;
      },
      (data) {
        _mapVehicleToForm(data);
        isLoading.value = false;
      },
    );
  }

  void _mapVehicleToForm(Map<String, dynamic> data) {
    titleController.text = data['title'] as String? ?? '';
    priceController.text = (data['price'] as num?)?.toString() ?? '';
    kmDrivenController.text = (data['km_driven'] as num?)?.toString() ?? '';
    firstRegistrationMonth.value = null;
    firstRegistrationYear.value = null;
    final firstReg = data['first_registration_date'] as String?;
    if (firstReg != null && firstReg.isNotEmpty) {
      try {
        final parts = firstReg.split('-');
        if (parts.isNotEmpty) firstRegistrationYear.value = int.tryParse(parts[0]);
        if (parts.length >= 2) firstRegistrationMonth.value = int.tryParse(parts[1]);
      } catch (_) {}
    }

    final details = data['details'] as Map<String, dynamic>?;
    if (details != null) {
      descriptionController.text = details['description'] as String? ?? '';
      variantId.value = details['variant_id'] as int? ?? data['variant_id'] as int?;
      colorId.value = details['color_id'] as int? ?? data['color_id'] as int?;
      sellerPhoneController.text = details['seller_phone'] as String? ?? '';
      euronomId.value = details['euronom_id'] as int?;
      if (details['technical_total_weight'] != null) {
        technicalTotalWeightController.text = details['technical_total_weight'].toString();
      }
      if (details['fuel_consumption_wltp'] != null || details['fuel_efficiency'] != null) {
        fuelEfficiencyController.text = (details['fuel_consumption_wltp'] ?? details['fuel_efficiency']).toString();
      }
    }
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
    String? firstRegDate;
    if (firstRegistrationYear.value != null && firstRegistrationMonth.value != null) {
      firstRegDate = '${firstRegistrationYear.value}-${firstRegistrationMonth.value!.toString().padLeft(2, '0')}-01';
    }

    final body = <String, dynamic>{
      'title': titleController.text.trim().isEmpty ? null : titleController.text.trim(),
      'price': priceVal,
      'km_driven': kmVal,
      'first_registration_date': firstRegDate,
      'seller_address': sellerAddressController.text.trim(),
      'seller_postcode': sellerPostcodeController.text.trim(),
      'description': descriptionController.text.trim().isEmpty ? null : descriptionController.text.trim(),
      'variant_id': variantId.value,
      'color_id': colorId.value,
      'seller_phone': sellerPhoneController.text.trim(),
      'euronom_id': euronomId.value,
      'equipment_ids': selectedEquipmentIds.toList(),
    };
    if (technicalTotalWeightController.text.trim().isNotEmpty) {
      final w = int.tryParse(technicalTotalWeightController.text.trim());
      if (w != null) body['technical_total_weight'] = w;
    }
    if (fuelEfficiencyController.text.trim().isNotEmpty) {
      final f = double.tryParse(fuelEfficiencyController.text.trim());
      if (f != null) body['fuel_efficiency'] = f;
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
