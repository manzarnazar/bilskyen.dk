import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bilskyen/models/constants_model/constants_model.dart';
import '../models/sell_vehicle_model/vehicle_lookup_response_model.dart';
import '../models/sell_vehicle_model/reference_data_model.dart';
import '../models/sell_vehicle_model/sell_vehicle_request_model.dart';
import '../models/sell_vehicle_model/plan_model.dart';
import '../repositories/sell_vehicle/sell_vehicle_repository.dart';
import '../services/constants_service.dart';
import '../main.dart';
import '../utils/validation_utils.dart';
import 'dart:convert';

class SellVehicleController extends GetxController {
  final SellVehicleRepository _repository = SellVehicleRepository();
  final ImagePicker _imagePicker = ImagePicker();
  final ConstantsService _constantsService = Get.find<ConstantsService>();

  // Form visibility
  final RxBool isFormVisible = false.obs;

  // Manual entry mode (no registration number)
  final RxBool isManualEntryMode = false.obs;
  final Rx<int?> manualBrandId = Rx<int?>(null);
  final Rx<int?> manualModelId = Rx<int?>(null);
  final Rx<int?> manualModelYearId = Rx<int?>(null);
  final Rx<int?> manualFuelTypeId = Rx<int?>(null);

  // License plate lookup
  final registrationController = TextEditingController();
  final RxBool isLookingUp = false.obs;
  final RxString lookupError = ''.obs;
  final Rx<VehicleLookupResponseModel?> vehicleData = Rx<VehicleLookupResponseModel?>(null);

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
  final Rx<int?> gearTypeId = Rx<int?>(null);
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

  // Description (auto-filled from API or generated from form; user can edit)
  final descriptionController = TextEditingController();
  final RxBool descriptionUserEdited = false.obs;
  bool _isAutoFilling = false;

  // Seller Information
  final sellerPhoneController = TextEditingController();
  final sellerAddressController = TextEditingController();
  final sellerPostcodeController = TextEditingController();
  final RxList<LocationModel> locationSuggestions = <LocationModel>[].obs;
  final RxBool showLocationSuggestions = false.obs;

  // Packages
  final Rx<int?> selectedPlanId = Rx<int?>(null);

  // Reference data
  final RxList<LookupItem> gearTypes = <LookupItem>[].obs;
  final RxList<LookupItem> brands = <LookupItem>[].obs;
  final RxList<ModelItem> models = <ModelItem>[].obs;
  final RxList<LookupItem> modelYears = <LookupItem>[].obs;
  final RxList<LookupItem> fuelTypes = <LookupItem>[].obs;
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

  /// Keys for scrolling to sections when validation fails. Initialized once.
  final Map<String, GlobalKey> sectionScrollKeys = {
    'license': GlobalKey(),
    'basic-info': GlobalKey(),
    'specifications': GlobalKey(),
    'equipment': GlobalKey(),
    'pricing': GlobalKey(),
    'photos': GlobalKey(),
    'description': GlobalKey(),
    'seller-info': GlobalKey(),
    'packages': GlobalKey(),
  };

  /// Keys for form fields with validators, in tree order. Used to find first invalid field when form.validate() fails.
  final List<GlobalKey<FormFieldState<dynamic>>> formFieldKeys = List.generate(5, (_) => GlobalKey<FormFieldState<dynamic>>());
  static const List<String> _formFieldSectionIds = ['specifications', 'pricing', 'seller-info', 'seller-info', 'seller-info'];
  static const List<String> _formFieldLabels = ['Kilometer driven', 'Price', 'Phone', 'Address', 'Postal code'];

  @override
  void onInit() {
    super.onInit();
    final token = appStorage.read('token');
    if (token == null || token.toString().isEmpty) {
      Get.offNamed('/login');
      return;
    }
    _loadUserData();
    _loadReferenceData();
    _setupDescriptionRegenerationListeners();
  }

  @override
  void onClose() {
    kmDrivenController.removeListener(_onSpecChanged);
    fuelEfficiencyController.removeListener(_onSpecChanged);
    technicalTotalWeightController.removeListener(_onSpecChanged);
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

  void _setupDescriptionRegenerationListeners() {
    kmDrivenController.addListener(_onSpecChanged);
    fuelEfficiencyController.addListener(_onSpecChanged);
    technicalTotalWeightController.addListener(_onSpecChanged);
    ever(firstRegistrationMonth, (_) => _onSpecChanged());
    ever(firstRegistrationYear, (_) => _onSpecChanged());
    ever(lastInspectionMonth, (_) => _onSpecChanged());
    ever(lastInspectionYear, (_) => _onSpecChanged());
    ever(euronomId, (_) => _onSpecChanged());
    ever(selectedEquipmentIds, (_) => _onSpecChanged());
    ever(servicebog, (_) => _onSpecChanged());
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

  /// Load all reference data for dropdowns from constants
  Future<void> _loadReferenceData() async {
    isLoadingReferenceData.value = true;
    try {
      // Wait for constants to be loaded if not already loaded
      if (_constantsService.getConstants() == null) {
        await _constantsService.fetchConstants();
      }

      final constants = _constantsService.getConstants();
      if (constants == null) {
        // Fallback to repository if constants are not available
        await _loadReferenceDataFromRepository();
        return;
      }

      // Map gear types from constants
      gearTypes.assignAll(constants.gearTypes);

      // Map brands, model years, fuel types for manual entry
      brands.assignAll(constants.brands);
      modelYears.assignAll(constants.modelYears);
      fuelTypes.assignAll(constants.fuelTypes);
      models.assignAll(constants.models);

      // Map colors from constants
      colors.value = constants.colors.map((item) => ColorModel(
        id: item.id,
        name: item.name,
      )).toList();

      // Map variants from constants
      variants.value = constants.variants.map((item) => VariantModel(
        id: item.id,
        name: item.name,
      )).toList();

      // Map equipment from constants
      final equipmentList = constants.equipments.map((item) => EquipmentModel(
        id: item.id,
        name: item.name,
        equipmentTypeId: item.equipmentTypeId,
      )).toList();
      equipment.value = equipmentList;

      // Map equipment types from constants
      equipmentTypes.value = constants.equipmentTypes.map((item) => EquipmentTypeModel(
        id: item.id,
        name: item.name,
      )).toList();

      // Map euronorms from constants
      euronorms.value = constants.euronorms.map((item) => EuronomModel(
        id: item.id,
        name: item.name,
      )).toList();

      // Load locations, plans (if available)
      // These might need to be fetched from internal API
      // For now, they're empty lists
    } catch (e) {
      // Handle error - fallback to repository
      await _loadReferenceDataFromRepository();
    } finally {
      isLoadingReferenceData.value = false;
    }
  }

  /// Fallback: Load reference data from repository (if constants are not available)
  Future<void> _loadReferenceDataFromRepository() async {
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
    } catch (e) {
      // Handle error
    }
  }

  /// Toggle section expansion
  void toggleSection(String sectionId) {
    sectionExpanded[sectionId] = !(sectionExpanded[sectionId] ?? false);
  }

  /// Enter manual mode when user does not have a registration number
  void enterManualMode() {
    isManualEntryMode.value = true;
    registrationController.text = 'N/A';
    vehicleData.value = null;
    _resetFormFields();
    isFormVisible.value = true;
    lookupError.value = '';
    // Variant will be user-selectable in manual mode
  }

  /// Return to license plate lookup mode
  void startOver() {
    isManualEntryMode.value = false;
    registrationController.text = '';
    vehicleData.value = null;
    _resetFormFields();
    isFormVisible.value = false;
    manualBrandId.value = null;
    manualModelId.value = null;
    manualModelYearId.value = null;
    manualFuelTypeId.value = null;
    lookupError.value = '';
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
    
    // Reset form fields before new lookup
    _resetFormFields();

    final result = await _repository.getVehicleByRegistration(registration);

    result.fold(
      (error) {
        lookupError.value = error;
        isLookingUp.value = false;
      },
      (data) {
        vehicleData.value = data;
        _autoFillForm(data);
        isFormVisible.value = true;
        isLookingUp.value = false;
        lookupError.value = '';
      },
    );
  }

  /// Reset form fields when performing a new lookup
  void _resetFormFields() {
    // Reset vehicle data (only if not in manual mode - manual mode keeps form visible)
    if (!isManualEntryMode.value) {
      vehicleData.value = null;
    }
    
    // Reset basic info
    title.value = '';
    variantId.value = null;
    colorId.value = null;
    
    // Reset specifications
    kmDrivenController.clear();
    gearTypeId.value = null;
    firstRegistrationMonth.value = null;
    firstRegistrationYear.value = null;
    lastInspectionMonth.value = null;
    lastInspectionYear.value = null;
    fuelEfficiencyController.clear();
    technicalTotalWeightController.clear();
    euronomId.value = null;
    
    // Reset equipment
    selectedEquipmentIds.clear();
    manualBrandId.value = null;
    manualModelId.value = null;
    manualModelYearId.value = null;
    manualFuelTypeId.value = null;
    
    // Reset description
    descriptionController.clear();
    descriptionUserEdited.value = false;

    // Note: We don't reset price, seller info, images, or plan as user might want to keep those
  }

  /// Auto-fill form fields from API response
  void _autoFillForm(VehicleLookupResponseModel data) {
    _isAutoFilling = true;
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

    // Gear type (from API or DMR; default to Automatic when available)
    if (data.gearTypeId != null) {
      gearTypeId.value = data.gearTypeId;
    } else if (gearTypes.isNotEmpty) {
      LookupItem? automatic;
      for (final g in gearTypes) {
        if (g.name.toLowerCase() == 'automatic') {
          automatic = g;
          break;
        }
      }
      gearTypeId.value = automatic?.id ?? gearTypes.first.id;
    }

    // Equipment
    if (data.equipment != null && data.equipment!.isNotEmpty) {
      selectedEquipmentIds.value =
          data.equipment!.map((e) => e.id).toList();
    }

    // Description: use API value if present, otherwise generate from form fields (like web)
    if (data.description != null && data.description!.trim().isNotEmpty) {
      descriptionController.text = data.description!;
    } else {
      generateDescription();
    }
    _isAutoFilling = false;

    // Note: All other fields (weights, engine specs, inspection details, etc.)
    // are stored in vehicleData and will be passed directly to the API in submitForm()
    // This ensures all data from the lookup response is included in the request
  }

  /// Mark description as user-edited so we don't overwrite it when spec fields change.
  void markDescriptionUserEdited() {
    descriptionUserEdited.value = true;
  }

  /// Generate description from form fields (matches web sell-your-car-form.js generateDescription).
  void generateDescription() {
    if (descriptionUserEdited.value) return;

    final parts = <String>[];

    // Equipment
    if (selectedEquipmentIds.isNotEmpty) {
      final names = <String>[];
      for (final id in selectedEquipmentIds) {
        for (final e in equipment) {
          if (e.id == id) {
            names.add(e.name);
            break;
          }
        }
      }
      if (names.isNotEmpty) {
        parts.add('Equipment: ${names.join(', ')}');
      }
    }

    // Servicebog
    if (servicebog.value != 'Default') {
      parts.add('Service book: ${servicebog.value}');
    }

    // Kilometer driven
    final kmText = kmDrivenController.text.trim();
    if (kmText.isNotEmpty) {
      final km = int.tryParse(kmText);
      if (km != null) {
        parts.add('Kilometers driven: ${km.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} km');
      }
    }

    // First registration
    final frMonth = firstRegistrationMonth.value;
    final frYear = firstRegistrationYear.value;
    if (frMonth != null && frYear != null) {
      parts.add('First registration: ${_monthName(frMonth)} $frYear');
    }

    // Last inspection
    final liMonth = lastInspectionMonth.value;
    final liYear = lastInspectionYear.value;
    if (liMonth != null && liYear != null) {
      parts.add('Last inspection: ${_monthName(liMonth)} $liYear');
    }

    // Fuel efficiency / electric range (label by fuel type)
    final fuelEffText = fuelEfficiencyController.text.trim();
    if (fuelEffText.isNotEmpty) {
      final fuelTypeId = vehicleData.value?.fuelType?.id;
      const electricFuelTypes = [3, 7];
      const hybridFuelTypes = [4, 5];
      final val = double.tryParse(fuelEffText) ?? int.tryParse(fuelEffText)?.toDouble();
      if (val != null) {
        if (fuelTypeId != null && electricFuelTypes.contains(fuelTypeId)) {
          parts.add('Electric range: ${val.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} km');
        } else if (fuelTypeId != null && hybridFuelTypes.contains(fuelTypeId)) {
          parts.add('Range/Efficiency: ${val.toStringAsFixed(2)} km');
        } else {
          parts.add('Fuel efficiency: ${val.toStringAsFixed(2)} km/l');
        }
      }
    }

    // Euronom
    final euronomIdVal = euronomId.value;
    if (euronomIdVal != null) {
      String? euronomName;
      for (final e in euronorms) {
        if (e.id == euronomIdVal) {
          euronomName = e.name;
          break;
        }
      }
      if (euronomName != null && euronomName.isNotEmpty) {
        parts.add('Euro norm: $euronomName');
      }
    }

    // Total technical weight
    final weightText = technicalTotalWeightController.text.trim();
    if (weightText.isNotEmpty) {
      final w = int.tryParse(weightText);
      if (w != null) {
        parts.add('Total technical weight: ${w.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (m) => '${m[1]},')} kg');
      }
    }

    if (parts.isNotEmpty) {
      descriptionController.text = '${parts.join('. ')}.';
    }
  }

  static const _monthNames = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  static String _monthName(int month) =>
      month >= 1 && month <= 12 ? _monthNames[month - 1] : '$month';

  void _onSpecChanged() {
    if (_isAutoFilling || descriptionUserEdited.value) return;
    generateDescription();
  }

  /// Pick images from gallery with validation
  Future<void> pickImages() async {
    try {
      final List<XFile> pickedFiles = await _imagePicker.pickMultiImage(
        imageQuality: 85,
      );

      if (pickedFiles.isNotEmpty) {
        final files = pickedFiles.map((xFile) => File(xFile.path)).toList();
        final validationErrors = <String>[];

        // Validate each image before adding
        for (var i = 0; i < files.length; i++) {
          final file = files[i];
          final sizeError = ValidationUtils.validateImageSize(file);
          if (sizeError != null) {
            validationErrors.add('Image ${i + 1}: $sizeError');
            continue;
          }

          final typeError = ValidationUtils.validateImageType(file);
          if (typeError != null) {
            validationErrors.add('Image ${i + 1}: $typeError');
            continue;
          }

          // Image is valid, add it
          selectedImages.add(file);
        }

        // Show validation errors if any
        if (validationErrors.isNotEmpty) {
          Get.snackbar(
            'Image Validation Error',
            validationErrors.join('\n'),
            duration: const Duration(seconds: 5),
          );
        }

        // Show success message if some images were added
        if (selectedImages.length > files.length - validationErrors.length) {
          final addedCount =
              selectedImages.length - (selectedImages.length - files.length);
          if (addedCount > 0) {
            Get.snackbar(
              'Success',
              '$addedCount image(s) added successfully',
              duration: const Duration(seconds: 2),
            );
          }
        }
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

  static String? _findNameById(List<LookupItem> list, int id) {
    for (final item in list) {
      if (item.id == id) return item.name;
    }
    return null;
  }

  String? _findModelNameById(int brandId, int modelId) {
    for (final m in getModelsByBrand(brandId)) {
      if (m.id == modelId) return m.name;
    }
    return null;
  }

  /// Get models filtered by brand (for manual entry)
  List<ModelItem> getModelsByBrand(int? brandId) {
    if (brandId == null) return [];
    return models.where((m) => m.brandId == brandId).toList();
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

  /// Validate form according to backend validation rules.
  /// Returns (isValid, scrollToSectionId). When invalid, scrollToSectionId is the section to scroll to (null = use fallback 'basic-info').
  (bool, String?) validateForm() {
    // First validate form fields
    if (!formKey.currentState!.validate()) {
      // Find first form field with error (in tree order) for scroll target and snackbar message
      String? firstInvalidMessage;
      String? scrollSectionId;
      for (var i = 0; i < formFieldKeys.length && i < _formFieldSectionIds.length; i++) {
        final state = formFieldKeys[i].currentState;
        if (state?.hasError == true) {
          scrollSectionId ??= _formFieldSectionIds[i];
          firstInvalidMessage ??= state!.errorText ?? (i < _formFieldLabels.length ? _formFieldLabels[i] : 'Field');
          break;
        }
      }
      Get.snackbar(
        'Validation Error',
        firstInvalidMessage ?? 'Please fix the highlighted fields.',
        duration: const Duration(seconds: 5),
      );
      return (false, scrollSectionId ?? 'basic-info');
    }

    final errors = <String>[];
    String? firstSectionId;

    // Title - optional, but if provided max 255 characters
    if (title.value.isNotEmpty) {
      final titleError = ValidationUtils.validateStringMaxLength(title.value, 255);
      if (titleError != null) {
        errors.add(titleError);
        firstSectionId ??= 'basic-info';
      }
    }

    // Registration - required, max 20 characters (or "N/A" in manual mode)
    final registration = registrationController.text.trim();
    if (registration.isEmpty) {
      errors.add('Registration number is required');
      firstSectionId ??= 'license';
    } else if (registration.length > 20) {
      errors.add('Registration number must be maximum 20 characters');
      firstSectionId ??= 'license';
    }

    // VIN - optional, max 17 characters
    if (vehicleData.value?.vin != null) {
      final vinError = ValidationUtils.validateVin(vehicleData.value!.vin);
      if (vinError != null) {
        errors.add(vinError);
        firstSectionId ??= 'basic-info';
      }
    }

    // Price - required, integer >= 0
    if (priceController.text.isEmpty) {
      errors.add('Price is required');
      firstSectionId ??= 'pricing';
    } else {
      final priceValue = int.tryParse(priceController.text);
      if (priceValue == null) {
        errors.add('Price must be a valid number');
        firstSectionId ??= 'pricing';
      } else {
        final priceError =
            ValidationUtils.validateNonNegativeInteger(priceValue, 'Price');
        if (priceError != null) {
          errors.add(priceError);
          firstSectionId ??= 'pricing';
        }
      }
    }

    // Fuel Type ID - required (from lookup or manual selection)
    if (isManualEntryMode.value) {
      if (manualFuelTypeId.value == null) {
        errors.add('Fuel type is required');
        firstSectionId ??= 'basic-info';
      }
      if (manualBrandId.value == null) {
        errors.add('Brand is required');
        firstSectionId ??= 'basic-info';
      }
      if (manualModelId.value == null) {
        errors.add('Model is required');
        firstSectionId ??= 'basic-info';
      }
      if (manualModelYearId.value == null) {
        errors.add('Year is required');
        firstSectionId ??= 'basic-info';
      }
    } else if (vehicleData.value?.fuelType == null) {
      errors.add('Fuel type is required');
      firstSectionId ??= 'specifications';
    }

    // Kilometer driven - required, must be >= 0
    if (kmDrivenController.text.isEmpty) {
      errors.add('Kilometer driven is required');
      firstSectionId ??= 'specifications';
    } else {
      final kmValue = int.tryParse(kmDrivenController.text.trim());
      if (kmValue == null) {
        errors.add('Kilometer driven must be a valid number');
        firstSectionId ??= 'specifications';
      } else {
        final kmError = ValidationUtils.validateNonNegativeInteger(
          kmValue,
          'Kilometer driven',
        );
        if (kmError != null) {
          errors.add(kmError);
          firstSectionId ??= 'specifications';
        }
      }
    }

    // Fuel efficiency
    if (fuelEfficiencyController.text.isNotEmpty) {
      final fuelEffValue = double.tryParse(fuelEfficiencyController.text);
      if (fuelEffValue == null) {
        errors.add('Fuel efficiency must be a valid number');
        firstSectionId ??= 'specifications';
      } else if (fuelEffValue < 0) {
        errors.add('Fuel efficiency must be a positive number');
        firstSectionId ??= 'specifications';
      }
    }

    // Technical total weight
    if (technicalTotalWeightController.text.isNotEmpty) {
      final weightValue =
          int.tryParse(technicalTotalWeightController.text);
      if (weightValue == null) {
        errors.add('Technical total weight must be a valid number');
        firstSectionId ??= 'specifications';
      } else {
        final weightError = ValidationUtils.validateNonNegativeInteger(
          weightValue,
          'Technical total weight',
        );
        if (weightError != null) {
          errors.add(weightError);
          firstSectionId ??= 'specifications';
        }
      }
    }

    // Validate images
    if (selectedImages.isEmpty) {
      errors.add('Please upload at least one image');
      firstSectionId ??= 'photos';
    } else {
      final imageErrors = ValidationUtils.validateImages(selectedImages);
      if (imageErrors.isNotEmpty) {
        errors.addAll(imageErrors);
        firstSectionId ??= 'photos';
      }
    }

    // Seller information
    final phoneError =
        ValidationUtils.validateRequired(sellerPhoneController.text, 'Phone');
    if (phoneError != null) {
      errors.add(phoneError);
      firstSectionId ??= 'seller-info';
    }

    final addressError =
        ValidationUtils.validateRequired(sellerAddressController.text, 'Address');
    if (addressError != null) {
      errors.add(addressError);
      firstSectionId ??= 'seller-info';
    }

    final postcodeError = ValidationUtils.validateRequired(
      sellerPostcodeController.text,
      'Postal code',
    );
    if (postcodeError != null) {
      errors.add(postcodeError);
      firstSectionId ??= 'seller-info';
    }

    if (errors.isNotEmpty) {
      Get.snackbar(
        'Validation Error',
        errors.join('\n'),
        duration: const Duration(seconds: 5),
      );
      return (false, firstSectionId ?? 'basic-info');
    }

    return (true, null);
  }

  /// Scroll to a section so the user sees the invalid field. Expands the section first; call after layout (e.g. in addPostFrameCallback).
  void scrollToSection(String sectionId) {
    final key = sectionScrollKeys[sectionId];
    final ctx = key?.currentContext;
    if (ctx == null) return;
    try {
      Scrollable.ensureVisible(
        ctx,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
    } catch (_) {
      // Context may be inactive/disposed if user navigated away; ignore.
    }
  }

  /// Submit form with proper validation and field mapping
  Future<void> submitForm() async {
    final (bool isValid, String? scrollToSectionId) = validateForm();
    if (!isValid) {
      final targetSectionId = scrollToSectionId ?? 'basic-info';
      sectionExpanded[targetSectionId] = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        scrollToSection(targetSectionId);
      });
      return;
    }

    // Check if user is authenticated before submission
    final token = appStorage.read("token")?.toString();
    if (token == null || token.isEmpty) {
      Get.snackbar(
        'Authentication Required',
        'Please login to submit your vehicle listing.',
        duration: const Duration(seconds: 5),
      );
      return;
    }

    isSubmitting.value = true;

    try {
      // Title is optional - backend will auto-generate if not provided
      final vehicleTitle = title.value.trim().isNotEmpty ? title.value.trim() : null;

      // Parse fuel type ID (from vehicle data or manual selection)
      int? fuelTypeId;
      if (isManualEntryMode.value) {
        fuelTypeId = manualFuelTypeId.value;
        if (fuelTypeId == null) {
          Get.snackbar('Error', 'Fuel type is required');
          isSubmitting.value = false;
          return;
        }
      } else if (vehicleData.value?.fuelType != null) {
        fuelTypeId = vehicleData.value!.fuelType!.id;
      } else {
        Get.snackbar('Error', 'Fuel type is required');
        isSubmitting.value = false;
        return;
      }

      // Parse price (required field, already validated)
      final priceValue = int.parse(priceController.text.trim());

      // Parse km_driven (required field)
      if (kmDrivenController.text.isEmpty) {
        Get.snackbar('Error', 'Kilometer driven is required');
        isSubmitting.value = false;
        return;
      }
      final kmDrivenValue = int.tryParse(kmDrivenController.text.trim());
      if (kmDrivenValue == null || kmDrivenValue < 0) {
        Get.snackbar('Error', 'Kilometer driven must be a valid positive number');
        isSubmitting.value = false;
        return;
      }

      // Parse fuel efficiency (optional)
      double? fuelEffValue;
      if (fuelEfficiencyController.text.isNotEmpty) {
        fuelEffValue = double.tryParse(fuelEfficiencyController.text.trim());
        if (fuelEffValue != null && fuelEffValue < 0) {
          Get.snackbar('Error', 'Fuel efficiency must be a positive number');
          isSubmitting.value = false;
          return;
        }
      }

      // Parse technical total weight (optional)
      int? techWeightValue;
      if (technicalTotalWeightController.text.isNotEmpty) {
        techWeightValue =
            int.tryParse(technicalTotalWeightController.text.trim());
        if (techWeightValue != null && techWeightValue < 0) {
          Get.snackbar('Error', 'Technical total weight must be a positive number');
          isSubmitting.value = false;
          return;
        }
      }

      // Helper function to parse string to int (for wheels, axles, drive_axles)
      int? _parseIntFromString(dynamic value) {
        if (value == null) return null;
        if (value is int) return value;
        if (value is String) {
          if (value.isEmpty) return null;
          return int.tryParse(value);
        }
        if (value is num) return value.toInt();
        return null;
      }

      // Helper function to convert array to JSON string
      String? _arrayToJsonString(List<dynamic>? array) {
        if (array == null || array.isEmpty) return null;
        try {
          return jsonEncode(array);
        } catch (e) {
          return null;
        }
      }

      // Build request model with all fields from vehicle lookup response
      // Note: The model will handle date conversion from month/year to date strings
      // Backend will automatically set vehicle_list_status_id to 2 and published_at to now()
      final requestData = SellVehicleRequestModel(
        registration: registrationController.text.trim().toUpperCase(),
        price: priceValue,
        fuelTypeId: fuelTypeId,
        kmDriven: kmDrivenValue,
        title: vehicleTitle,
        vin: vehicleData.value?.vin,
        vehicleExternalId: vehicleData.value?.vehicleExternalId ?? vehicleData.value?.vehicleId?.toString(),
        brandId: isManualEntryMode.value ? manualBrandId.value : vehicleData.value?.brand?.id,
        modelId: isManualEntryMode.value ? manualModelId.value : vehicleData.value?.model?.id,
        modelYearId: isManualEntryMode.value ? manualModelYearId.value : vehicleData.value?.modelYear?.id,
        brandName: isManualEntryMode.value && manualBrandId.value != null
            ? _findNameById(brands, manualBrandId.value!)
            : null,
        modelName: isManualEntryMode.value && manualBrandId.value != null && manualModelId.value != null
            ? _findModelNameById(manualBrandId.value!, manualModelId.value!)
            : null,
        modelYearName: isManualEntryMode.value && manualModelYearId.value != null
            ? _findNameById(modelYears, manualModelYearId.value!)
            : null,
        listingTypeId: null, // Will be set by backend if not provided
        
        // Vehicle details
        vinLocation: vehicleData.value?.vinLocation,
        typeId: vehicleData.value?.type?.id,
        typeName: vehicleData.value?.type?.name,
        version: vehicleData.value?.version,
        registrationStatus: vehicleData.value?.registrationStatus,
        registrationStatusUpdatedDate: vehicleData.value?.registrationStatusUpdatedDate,
        expireDate: vehicleData.value?.expireDate,
        statusUpdatedDate: vehicleData.value?.statusUpdatedDate,
        description: descriptionController.text.trim().isNotEmpty
            ? descriptionController.text.trim()
            : vehicleData.value?.description,
        
        // Vehicle specifications
        variantId: variantId.value ?? vehicleData.value?.variant?.id,
        variantName: variantId.value != null
            ? (variants.where((v) => v.id == variantId.value).isNotEmpty
                ? variants.where((v) => v.id == variantId.value).first.name
                : vehicleData.value?.variant?.name)
            : vehicleData.value?.variant?.name,
        colorId: colorId.value ?? vehicleData.value?.color?.id,
        useId: vehicleData.value?.use?.id,
        bodyTypeId: vehicleData.value?.bodyType?.id,
        gearTypeId: gearTypeId.value ?? vehicleData.value?.gearTypeId,
        
        // Dates
        firstRegistrationMonth: firstRegistrationMonth.value ?? vehicleData.value?.firstRegistrationMonth,
        firstRegistrationYear: firstRegistrationYear.value ?? vehicleData.value?.firstRegistrationYear,
        firstRegistrationDate: vehicleData.value?.firstRegistrationDate,
        lastInspectionMonth: lastInspectionMonth.value ?? vehicleData.value?.lastInspectionMonth,
        lastInspectionYear: lastInspectionYear.value ?? vehicleData.value?.lastInspectionYear,
        lastInspectionDate: vehicleData.value?.lastInspectionDate,
        lastInspectionResult: vehicleData.value?.lastInspectionResult,
        lastInspectionOdometer: vehicleData.value?.lastInspectionOdometer,
        // Note: leasingPeriodStart and leasingPeriodEnd are not available in VehicleLookupResponseModel
        // They are set to null - can be added later if API provides them
        
        // Weight and dimensions
        totalWeight: vehicleData.value?.totalWeight,
        vehicleWeight: vehicleData.value?.vehicleWeight,
        technicalTotalWeight: techWeightValue ?? vehicleData.value?.technicalTotalWeight,
        towingWeight: vehicleData.value?.towingWeight,
        towingWeightBrakes: vehicleData.value?.towingWeightBrakes,
        minimumWeight: vehicleData.value?.minimumWeight,
        grossCombinationWeight: vehicleData.value?.grossCombinationWeight,
        
        // Engine specifications
        enginePower: vehicleData.value?.enginePower,
        engineDisplacement: vehicleData.value?.engineDisplacement,
        engineCylinders: vehicleData.value?.engineCylinders,
        engineCode: vehicleData.value?.engineCode,
        fuelEfficiency: fuelEffValue ?? vehicleData.value?.fuelEfficiency,
        euronomId: euronomId.value ?? vehicleData.value?.euronorm?.id,
        euronomName: euronomId.value != null
            ? (euronorms.where((e) => e.id == euronomId.value).isNotEmpty
                ? euronorms.where((e) => e.id == euronomId.value).first.name
                : vehicleData.value?.euronorm?.name)
            : vehicleData.value?.euronorm?.name,
        
        // Other specifications
        ownershipTax: vehicleData.value?.ownershipTax,
        annualTax: vehicleData.value?.annualTax,
        doors: vehicleData.value?.doors,
        minimumSeats: vehicleData.value?.minimumSeats,
        maximumSeats: vehicleData.value?.maximumSeats,
        topSpeed: vehicleData.value?.topSpeed,
        wheels: _parseIntFromString(vehicleData.value?.wheels),
        axles: _parseIntFromString(vehicleData.value?.axles),
        driveAxles: _parseIntFromString(vehicleData.value?.driveAxles),
        wheelbase: vehicleData.value?.wheelbase,
        category: vehicleData.value?.category,
        typeApprovalCode: vehicleData.value?.typeApprovalCode,
        extraEquipment: vehicleData.value?.extraEquipment,
        dispensations: _arrayToJsonString(vehicleData.value?.dispensations),
        permits: _arrayToJsonString(vehicleData.value?.permits),
        airbags: vehicleData.value?.airbags,
        integratedChildSeats: vehicleData.value?.integratedChildSeats,
        seatBeltAlarms: vehicleData.value?.seatBeltAlarms,
        ncapFive: vehicleData.value?.ncapFive,
        coupling: vehicleData.value?.coupling,
        
        // Equipment and features
        equipmentIds: selectedEquipmentIds.isNotEmpty
            ? selectedEquipmentIds.toList()
            : (vehicleData.value?.equipment != null && vehicleData.value!.equipment!.isNotEmpty
                ? vehicleData.value!.equipment!.map((e) => e.id).toList()
                : null),
        servicebog: servicebog.value,
        
        // Seller information
        sellerPhone: sellerPhoneController.text.trim(),
        sellerAddress: sellerAddressController.text.trim(),
        sellerPostcode: sellerPostcodeController.text.trim(),
        planId: selectedPlanId.value,
      );

      // Validate images one more time before submission
      final imageErrors = ValidationUtils.validateImages(selectedImages);
      if (imageErrors.isNotEmpty) {
        Get.snackbar(
          'Image Validation Error',
          imageErrors.join('\n'),
          duration: const Duration(seconds: 5),
        );
        isSubmitting.value = false;
        return;
      }

      final result = await _repository.submitVehicleListing(
        requestData: requestData,
        images: selectedImages.toList(),
      );

      result.fold(
        (error) {
          Get.snackbar(
            'Submission Error',
            error,
            duration: const Duration(seconds: 5),
          );
          isSubmitting.value = false;
        },
        (data) async {
          Get.snackbar(
            'Success',
            'Vehicle listing submitted successfully!',
            duration: const Duration(seconds: 3),
            snackPosition: SnackPosition.TOP,
          );
          isSubmitting.value = false;
          // Wait for snackbar to display before navigating
          await Future.delayed(const Duration(milliseconds: 1500));
          // Defer navigation to next frame to avoid inactive element / disposed controller errors
          // during sell screen teardown. Go to main with My Listings tab to avoid duplicate
          // MyListingsView (tab + route) and Duplicate GlobalKey.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Get.offAllNamed('/main', arguments: {'tabIndex': 3});
          });
        },
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit: ${e.toString()}',
        duration: const Duration(seconds: 5),
      );
      isSubmitting.value = false;
    }
  }
}
