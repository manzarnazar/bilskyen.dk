import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../models/sell_vehicle_model/vehicle_lookup_response_model.dart';
import '../models/sell_vehicle_model/reference_data_model.dart';
import '../models/sell_vehicle_model/sell_vehicle_request_model.dart';
import '../models/sell_vehicle_model/plan_model.dart';
import '../repositories/sell_vehicle/sell_vehicle_repository.dart';
import '../main.dart';
import 'dart:convert';

class SellVehicleController extends GetxController {
  final SellVehicleRepository _repository = SellVehicleRepository();
  final ImagePicker _imagePicker = ImagePicker();

  // Form visibility
  final RxBool isFormVisible = false.obs;

  // License plate lookup
  final registrationController = TextEditingController();
  final RxBool isLookingUp = false.obs;
  final RxString lookupError = ''.obs;
  VehicleLookupResponseModel? vehicleData;

  // Expandable sections state
  final RxMap<String, bool> sectionExpanded = {
    'basic-info': true,
    'specifications': true,
    'equipment': true,
    'pricing': true,
    'photos': true,
    'description': true,
    'seller-info': true,
    'packages': true,
  }.obs;

  // Basic Vehicle Information
  final RxString title = ''.obs;
  final Rx<int?> variantId = Rx<int?>(null);
  final Rx<int?> colorId = Rx<int?>(null);

  // Vehicle Specifications
  final kmDrivenController = TextEditingController();
  final Rx<int?> firstRegistrationMonth = Rx<int?>(null);
  final Rx<int?> firstRegistrationYear = Rx<int?>(null);
  final Rx<int?> lastInspectionMonth = Rx<int?>(null);
  final Rx<int?> lastInspectionYear = Rx<int?>(null);
  final fuelEfficiencyController = TextEditingController();
  final technicalTotalWeightController = TextEditingController();
  final Rx<int?> euronomId = Rx<int?>(null);

  // Equipment & Features
  final RxList<int> selectedEquipmentIds = <int>[].obs;
  final RxString servicebog = 'Default'.obs;

  // Pricing & Tax
  final priceController = TextEditingController();
  final RxBool taxInfoExpanded = false.obs;

  // Photos
  final RxList<File> selectedImages = <File>[].obs;

  // Description
  final descriptionController = TextEditingController();

  // Seller Information
  final sellerPhoneController = TextEditingController();
  final sellerAddressController = TextEditingController();
  final sellerPostcodeController = TextEditingController();
  final RxList<LocationModel> locationSuggestions = <LocationModel>[].obs;
  final RxBool showLocationSuggestions = false.obs;

  // Packages
  final Rx<int?> selectedPlanId = Rx<int?>(null);

  // Reference data
  final RxList<ColorModel> colors = <ColorModel>[].obs;
  final RxList<EquipmentModel> equipment = <EquipmentModel>[].obs;
  final RxList<EquipmentTypeModel> equipmentTypes = <EquipmentTypeModel>[].obs;
  final RxList<VariantModel> variants = <VariantModel>[].obs;
  final RxList<EuronomModel> euronorms = <EuronomModel>[].obs;
  final RxList<PlanModel> plans = <PlanModel>[].obs;
  final RxList<LocationModel> locations = <LocationModel>[].obs;

  // Loading states
  final RxBool isLoadingReferenceData = false.obs;
  final RxBool isSubmitting = false.obs;

  // Form validation
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    _loadReferenceData();
  }

  @override
  void onClose() {
    registrationController.dispose();
    kmDrivenController.dispose();
    fuelEfficiencyController.dispose();
    technicalTotalWeightController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    sellerPhoneController.dispose();
    sellerAddressController.dispose();
    sellerPostcodeController.dispose();
    super.onClose();
  }

  /// Load user data to pre-fill seller information
  void _loadUserData() {
    try {
      final userJson = appStorage.read('user');
      if (userJson != null) {
        final userMap = jsonDecode(userJson.toString()) as Map<String, dynamic>;
        sellerPhoneController.text = userMap['phone'] as String? ?? '';
        sellerAddressController.text = userMap['address'] as String? ?? '';
        sellerPostcodeController.text = userMap['postcode'] as String? ?? '';
      }
    } catch (e) {
      // Ignore errors
    }
  }

  /// Load all reference data for dropdowns
  Future<void> _loadReferenceData() async {
    isLoadingReferenceData.value = true;
    try {
      // Load colors
      final colorsResult = await _repository.getColors();
      colorsResult.fold(
        (error) => null,
        (data) => colors.value = data,
      );

      // Load equipment
      final equipmentResult = await _repository.getEquipment();
      equipmentResult.fold(
        (error) => null,
        (data) {
          equipment.value = data;
          // Group equipment by type
          final typeMap = <int, List<EquipmentModel>>{};
          for (var item in data) {
            final typeId = item.equipmentTypeId ?? 0;
            if (!typeMap.containsKey(typeId)) {
              typeMap[typeId] = [];
            }
            typeMap[typeId]!.add(item);
          }
          // Extract unique equipment types
          final types = <EquipmentTypeModel>[];
          for (var item in data) {
            if (item.equipmentType != null &&
                !types.any((t) => t.id == item.equipmentType!.id)) {
              types.add(item.equipmentType!);
            }
          }
          equipmentTypes.value = types;
        },
      );

      // Load variants
      final variantsResult = await _repository.getVariants();
      variantsResult.fold(
        (error) => null,
        (data) => variants.value = data,
      );

      // Load euronorms
      final euronormsResult = await _repository.getEuronorms();
      euronormsResult.fold(
        (error) => null,
        (data) => euronorms.value = data,
      );

      // Load locations, plans (if available)
      // These might need to be fetched from internal API
      // For now, they're empty lists
    } catch (e) {
      // Handle error
    } finally {
      isLoadingReferenceData.value = false;
    }
  }

  /// Toggle section expansion
  void toggleSection(String sectionId) {
    sectionExpanded[sectionId] = !(sectionExpanded[sectionId] ?? false);
  }

  /// Perform license plate lookup
  Future<void> lookupVehicle() async {
    final registration = registrationController.text.trim().toUpperCase();
    if (registration.isEmpty) {
      lookupError.value = 'Please enter a license plate number';
      return;
    }

    isLookingUp.value = true;
    lookupError.value = '';

    final result = await _repository.getVehicleByRegistration(registration);

    result.fold(
      (error) {
        lookupError.value = error;
        isLookingUp.value = false;
      },
      (data) {
        vehicleData = data;
        _autoFillForm(data);
        isFormVisible.value = true;
        isLookingUp.value = false;
        lookupError.value = '';
      },
    );
  }

  /// Auto-fill form fields from API response
  void _autoFillForm(VehicleLookupResponseModel data) {
    // Title
    if (data.title != null) {
      title.value = data.title!;
    } else if (data.brand != null && data.model != null) {
      title.value =
          '${data.brand!.name} ${data.model!.name}${data.modelYear != null ? ' ${data.modelYear!.name}' : ''}';
    }

    // Variant
    if (data.variant != null) {
      variantId.value = data.variant!.id;
    }

    // Color
    if (data.color != null) {
      colorId.value = data.color!.id;
    }

    // Kilometer driven
    if (data.kmDriven != null) {
      kmDrivenController.text = data.kmDriven.toString();
    }

    // First registration
    if (data.firstRegistrationMonth != null) {
      firstRegistrationMonth.value = data.firstRegistrationMonth;
    }
    if (data.firstRegistrationYear != null) {
      firstRegistrationYear.value = data.firstRegistrationYear;
    }
    if (data.firstRegistrationDate != null) {
      // Parse date and extract month/year if needed
      try {
        final date = DateTime.parse(data.firstRegistrationDate!);
        if (firstRegistrationMonth.value == null) {
          firstRegistrationMonth.value = date.month;
        }
        if (firstRegistrationYear.value == null) {
          firstRegistrationYear.value = date.year;
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }

    // Last inspection
    if (data.lastInspectionMonth != null) {
      lastInspectionMonth.value = data.lastInspectionMonth;
    }
    if (data.lastInspectionYear != null) {
      lastInspectionYear.value = data.lastInspectionYear;
    }
    if (data.lastInspectionDate != null) {
      try {
        final date = DateTime.parse(data.lastInspectionDate!);
        if (lastInspectionMonth.value == null) {
          lastInspectionMonth.value = date.month;
        }
        if (lastInspectionYear.value == null) {
          lastInspectionYear.value = date.year;
        }
      } catch (e) {
        // Ignore parsing errors
      }
    }

    // Fuel efficiency
    if (data.fuelEfficiency != null) {
      fuelEfficiencyController.text = data.fuelEfficiency.toString();
    }

    // Technical total weight
    if (data.technicalTotalWeight != null) {
      technicalTotalWeightController.text =
          data.technicalTotalWeight.toString();
    }

    // Euronom
    if (data.euronorm != null) {
      euronomId.value = data.euronorm!.id;
    }

    // Equipment
    if (data.equipment != null && data.equipment!.isNotEmpty) {
      selectedEquipmentIds.value =
          data.equipment!.map((e) => e.id).toList();
    }

    // Description
    if (data.description != null) {
      descriptionController.text = data.description!;
    }
  }

  /// Pick images from gallery
  Future<void> pickImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((xFile) => File(xFile.path)).toList();
        selectedImages.addAll(files);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: ${e.toString()}');
    }
  }

  /// Remove image at index
  void removeImage(int index) {
    if (index >= 0 && index < selectedImages.length) {
      selectedImages.removeAt(index);
    }
  }

  /// Reorder images (for drag and drop)
  void reorderImages(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = selectedImages.removeAt(oldIndex);
    selectedImages.insert(newIndex, item);
  }

  /// Toggle equipment selection
  void toggleEquipment(int equipmentId) {
    if (selectedEquipmentIds.contains(equipmentId)) {
      selectedEquipmentIds.remove(equipmentId);
    } else {
      selectedEquipmentIds.add(equipmentId);
    }
  }

  /// Filter equipment by type
  List<EquipmentModel> getEquipmentByType(int? typeId) {
    if (typeId == null) {
      return equipment.where((e) => e.equipmentTypeId == null).toList();
    }
    return equipment.where((e) => e.equipmentTypeId == typeId).toList();
  }

  /// Search locations
  void searchLocations(String query) {
    if (query.isEmpty) {
      locationSuggestions.clear();
      showLocationSuggestions.value = false;
      return;
    }

    final filtered = locations.where((location) {
      return location.city.toLowerCase().contains(query.toLowerCase()) ||
          location.postcode.contains(query);
    }).toList();

    locationSuggestions.value = filtered;
    showLocationSuggestions.value = filtered.isNotEmpty;
  }

  /// Select location
  void selectLocation(LocationModel location) {
    sellerAddressController.text = location.city;
    sellerPostcodeController.text = location.postcode;
    showLocationSuggestions.value = false;
  }

  /// Validate form
  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    // Check required fields
    if (kmDrivenController.text.isEmpty) {
      Get.snackbar('Error', 'Kilometer driven is required');
      return false;
    }

    if (priceController.text.isEmpty) {
      Get.snackbar('Error', 'Price is required');
      return false;
    }

    if (sellerPhoneController.text.isEmpty) {
      Get.snackbar('Error', 'Phone number is required');
      return false;
    }

    if (sellerAddressController.text.isEmpty) {
      Get.snackbar('Error', 'Address is required');
      return false;
    }

    if (sellerPostcodeController.text.isEmpty) {
      Get.snackbar('Error', 'Postal code is required');
      return false;
    }

    if (selectedImages.isEmpty) {
      Get.snackbar('Error', 'Please upload at least one image');
      return false;
    }

    return true;
  }

  /// Submit form
  Future<void> submitForm() async {
    if (!validateForm()) {
      return;
    }

    isSubmitting.value = true;

    try {
      // Parse fuel type ID from vehicle data or use default
      int fuelTypeId = 1; // Default
      if (vehicleData?.fuelType != null) {
        fuelTypeId = vehicleData!.fuelType!.id;
      }

      // Parse vehicle list status (default to draft = 1)
      int vehicleListStatusId = 1; // Draft

      final requestData = SellVehicleRequestModel(
        registration: registrationController.text.trim().toUpperCase(),
        vin: vehicleData?.vin,
        title: title.value.isNotEmpty ? title.value : null,
        price: int.parse(priceController.text),
        fuelTypeId: fuelTypeId,
        kmDriven: int.parse(kmDrivenController.text),
        variantId: variantId.value,
        colorId: colorId.value,
        euronomId: euronomId.value,
        firstRegistrationMonth: firstRegistrationMonth.value,
        firstRegistrationYear: firstRegistrationYear.value,
        lastInspectionMonth: lastInspectionMonth.value,
        lastInspectionYear: lastInspectionYear.value,
        fuelEfficiency: fuelEfficiencyController.text.isNotEmpty
            ? double.tryParse(fuelEfficiencyController.text)
            : null,
        technicalTotalWeight: technicalTotalWeightController.text.isNotEmpty
            ? int.tryParse(technicalTotalWeightController.text)
            : null,
        equipmentIds: selectedEquipmentIds.isNotEmpty
            ? selectedEquipmentIds.toList()
            : null,
        servicebog: servicebog.value,
        description: descriptionController.text.isNotEmpty
            ? descriptionController.text
            : null,
        sellerPhone: sellerPhoneController.text,
        sellerAddress: sellerAddressController.text,
        sellerPostcode: sellerPostcodeController.text,
        planId: selectedPlanId.value,
        vehicleExternalId: vehicleData?.vehicleExternalId,
        brandId: vehicleData?.brand?.id,
        modelId: vehicleData?.model?.id,
        modelYearId: vehicleData?.modelYear?.id,
        vehicleListStatusId: vehicleListStatusId,
      );

      final result = await _repository.submitVehicleListing(
        requestData: requestData,
        images: selectedImages.toList(),
      );

      result.fold(
        (error) {
          Get.snackbar('Error', error);
          isSubmitting.value = false;
        },
        (data) {
          Get.snackbar('Success', 'Vehicle listing submitted successfully!');
          isSubmitting.value = false;
          // Navigate back or to success page
          Get.back();
        },
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to submit: ${e.toString()}');
      isSubmitting.value = false;
    }
  }
}
