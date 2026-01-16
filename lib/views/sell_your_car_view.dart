import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../services/mock_lookup_service.dart';
import '../models/brand_model.dart';
import '../models/fuel_type_model.dart';
import '../models/category_model.dart';
import '../models/body_type_model.dart';
import '../models/color_model.dart';
import '../models/transmission_model.dart';
import '../models/vehicle_list_status_model.dart';
import '../models/location_model.dart';

class SellYourCarView extends StatefulWidget {
  const SellYourCarView({super.key});

  @override
  State<SellYourCarView> createState() => _SellYourCarViewState();
}

class _SellYourCarViewState extends State<SellYourCarView> {
  final VehicleController controller = Get.find<VehicleController>();
  final ImagePicker _imagePicker = ImagePicker();
  
  // Step 1: Basic Details
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<XFile> _selectedImages = [];
  int _descriptionCharCount = 0;
  
  // Step 2: Vehicle Information
  final TextEditingController _registrationController = TextEditingController();
  final TextEditingController _vinController = TextEditingController();
  final TextEditingController _brandNameController = TextEditingController();
  final TextEditingController _modelNameController = TextEditingController();
  final TextEditingController _modelYearController = TextEditingController();
  int? _selectedBrandId;
  int? _selectedModelId;
  int? _selectedModelYearId;
  int? _selectedFuelTypeId;
  int? _selectedCategoryId;
  int? _selectedBodyTypeId;
  int? _selectedColorId;
  int? _selectedConditionId;
  int? _selectedGearTypeId;
  
  // Step 3: Vehicle Specifications
  final TextEditingController _mileageController = TextEditingController();
  final TextEditingController _kmDrivenController = TextEditingController();
  final TextEditingController _enginePowerController = TextEditingController();
  final TextEditingController _engineDisplacementController = TextEditingController();
  final TextEditingController _engineCylindersController = TextEditingController();
  final TextEditingController _engineCodeController = TextEditingController();
  final TextEditingController _batteryCapacityController = TextEditingController();
  final TextEditingController _rangeKmController = TextEditingController();
  final TextEditingController _chargingTypeController = TextEditingController();
  final TextEditingController _fuelEfficiencyController = TextEditingController();
  final TextEditingController _doorsController = TextEditingController();
  final TextEditingController _minSeatsController = TextEditingController();
  final TextEditingController _maxSeatsController = TextEditingController();
  final TextEditingController _topSpeedController = TextEditingController();
  final TextEditingController _wheelsController = TextEditingController();
  final TextEditingController _totalWeightController = TextEditingController();
  final TextEditingController _vehicleWeightController = TextEditingController();
  final TextEditingController _technicalTotalWeightController = TextEditingController();
  final TextEditingController _towingWeightController = TextEditingController();
  final TextEditingController _towingWeightBrakesController = TextEditingController();
  final TextEditingController _minimumWeightController = TextEditingController();
  final TextEditingController _grossCombinationWeightController = TextEditingController();
  final TextEditingController _ownershipTaxController = TextEditingController();
  final TextEditingController _airbagsController = TextEditingController();
  final TextEditingController _integratedChildSeatsController = TextEditingController();
  final TextEditingController _seatBeltAlarmsController = TextEditingController();
  final TextEditingController _lastInspectionOdometerController = TextEditingController();
  final TextEditingController _axlesController = TextEditingController();
  final TextEditingController _driveAxlesController = TextEditingController();
  final TextEditingController _wheelbaseController = TextEditingController();
  final TextEditingController _lastInspectionResultController = TextEditingController();
  final TextEditingController _typeApprovalCodeController = TextEditingController();
  final TextEditingController _versionController = TextEditingController();
  final TextEditingController _typeNameController = TextEditingController();
  final TextEditingController _registrationStatusController = TextEditingController();
  final TextEditingController _vinLocationController = TextEditingController();
  final TextEditingController _vehicleExternalIdController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _extraEquipmentController = TextEditingController();
  final TextEditingController _dispensationsController = TextEditingController();
  final TextEditingController _permitsController = TextEditingController();
  final TextEditingController _euronormController = TextEditingController();
  DateTime? _firstRegistrationDate;
  DateTime? _lastInspectionDate;
  DateTime? _registrationStatusUpdatedDate;
  DateTime? _expireDate;
  DateTime? _statusUpdatedDate;
  DateTime? _leasingPeriodStart;
  DateTime? _leasingPeriodEnd;
  bool? _coupling;
  bool? _ncapFive;
  
  // Step 4: Location & Additional Details
  int? _selectedLocationId;
  int? _selectedListingTypeId;
  int? _selectedPriceTypeId;
  int? _selectedSalesTypeId;
  int? _selectedUseId;
  int? _selectedTypeId;
  int? _selectedVehicleListStatusId;
  List<int> _selectedEquipmentIds = [];
  DateTime? _publishedAt;
  
  int _currentStep = 0; // 0-based, so 0 = Step 1
  final int _totalSteps = 4;

  @override
  void initState() {
    super.initState();
    _descriptionController.addListener(() {
      setState(() {
        _descriptionCharCount = _descriptionController.text.length;
      });
    });
  }

  @override
  void dispose() {
    // Step 1
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    // Step 2
    _registrationController.dispose();
    _vinController.dispose();
    _brandNameController.dispose();
    _modelNameController.dispose();
    _modelYearController.dispose();
    // Step 3
    _mileageController.dispose();
    _kmDrivenController.dispose();
    _enginePowerController.dispose();
    _engineDisplacementController.dispose();
    _engineCylindersController.dispose();
    _engineCodeController.dispose();
    _batteryCapacityController.dispose();
    _rangeKmController.dispose();
    _chargingTypeController.dispose();
    _fuelEfficiencyController.dispose();
    _doorsController.dispose();
    _minSeatsController.dispose();
    _maxSeatsController.dispose();
    _topSpeedController.dispose();
    _wheelsController.dispose();
    _totalWeightController.dispose();
    _vehicleWeightController.dispose();
    _technicalTotalWeightController.dispose();
    _towingWeightController.dispose();
    _towingWeightBrakesController.dispose();
    _minimumWeightController.dispose();
    _grossCombinationWeightController.dispose();
    _ownershipTaxController.dispose();
    _airbagsController.dispose();
    _integratedChildSeatsController.dispose();
    _seatBeltAlarmsController.dispose();
    _lastInspectionOdometerController.dispose();
    _axlesController.dispose();
    _driveAxlesController.dispose();
    _wheelbaseController.dispose();
    _lastInspectionResultController.dispose();
    _typeApprovalCodeController.dispose();
    _versionController.dispose();
    _typeNameController.dispose();
    _registrationStatusController.dispose();
    _vinLocationController.dispose();
    _vehicleExternalIdController.dispose();
    _categoryController.dispose();
    _extraEquipmentController.dispose();
    _dispensationsController.dispose();
    _permitsController.dispose();
    _euronormController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _imagePicker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );
      
      if (images.isNotEmpty) {
        setState(() {
          final remainingSlots = 10 - _selectedImages.length;
          if (remainingSlots > 0) {
            _selectedImages.addAll(
              images.take(remainingSlots),
            );
          } else {
            Get.snackbar(
              'Limit Reached',
              'Maximum 10 photos allowed',
              snackPosition: SnackPosition.TOP,
            );
          }
        });
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to pick images: $e',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  void _handleNextStep() {
    if (_currentStep < _totalSteps - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Handle form submission
      Get.snackbar(
        'Success',
        'Form submitted successfully',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  void _handlePreviousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }


  String _getStepTitle() {
    switch (_currentStep) {
      case 0:
        return 'Step 1 of 4: Basic Info';
      case 1:
        return 'Step 2 of 4: Vehicle Information';
      case 2:
        return 'Step 3 of 4: Vehicle Specifications';
      case 3:
        return 'Step 4 of 4: Location & Additional Details';
      default:
        return 'Step ${_currentStep + 1} of $_totalSteps';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Top App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: (isDark
                          ? AppColors.backgroundDark
                          : AppColors.backgroundLight)
                      .withOpacity(0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.borderLight,
                      width: 0.5,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: 20,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                      onPressed: () => Get.back(),
                    ),
                    Expanded(
                      child: Text(
                        'Sell Your Car',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
                          letterSpacing: -0.015,
                        ),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              // Progress Indicators
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        _totalSteps,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: index == _currentStep ? 32 : 8,
                          decoration: BoxDecoration(
                            color: index == _currentStep
                                ? (isDark ? AppColors.textDark : AppColors.textLight)
                                : (isDark
                                    ? AppColors.borderDarkSecondary
                                    : AppColors.gray300),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getStepTitle(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable Form Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _buildStepContent(isDark),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomActions(isDark),
      );
    });
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return _buildBasicDetailsStep(isDark);
      case 1:
        return _buildVehicleInformationStep(isDark);
      case 2:
        return _buildVehicleSpecificationsStep(isDark);
      case 3:
        return _buildLocationAndAdditionalStep(isDark);
      default:
        return Container(
          padding: const EdgeInsets.all(32),
          child: Center(
            child: Text(
              'Step ${_currentStep + 1} content coming soon',
              style: TextStyle(
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
          ),
        );
    }
  }

  Widget _buildBasicDetailsStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Basic Details Section
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Text(
            'Basic Details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textDark : AppColors.textLight,
              letterSpacing: -0.015,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ad Title Input
            _buildTextField(
              label: 'Ad Title',
              controller: _titleController,
              placeholder: 'e.g. 2018 Toyota Camry XLE',
              isDark: isDark,
            ),
            const SizedBox(height: 20),
            // Price Input
            _buildPriceField(isDark),
            const SizedBox(height: 20),
            // Description Input
            _buildDescriptionField(isDark),
          ],
        ),
        // Divider
        Container(
          height: 1,
          margin: const EdgeInsets.symmetric(vertical: 16),
          color: isDark ? AppColors.borderDark : AppColors.gray200,
        ),
        // Photos Section
        _buildPhotosSection(isDark),
      ],
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isDark,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.mutedDark : AppColors.gray700,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          style: TextStyle(
            color: isDark ? AppColors.textDark : AppColors.textLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.mutedDark.withOpacity(0.7)
                  : AppColors.mutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPriceField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _priceController,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: isDark ? AppColors.textDark : AppColors.textLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: '0.00',
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.mutedDark.withOpacity(0.7)
                  : AppColors.mutedLight,
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.only(left: 16, top: 12, bottom: 12),
              child: Text(
                '\$',
                style: TextStyle(
                  color: isDark ? AppColors.mutedDark : AppColors.gray600,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionField(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'Description',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.mutedDark : AppColors.gray700,
              ),
            ),
            Text(
              '$_descriptionCharCount/1200',
              style: TextStyle(
                fontSize: 12,
                color: isDark
                    ? AppColors.mutedDark.withOpacity(0.7)
                    : AppColors.mutedLight,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _descriptionController,
          maxLines: 4,
          maxLength: 1200,
          style: TextStyle(
            color: isDark ? AppColors.textDark : AppColors.textLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText:
                'Tell buyers about the condition, features, and history...',
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.mutedDark.withOpacity(0.7)
                  : AppColors.mutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.all(16),
            counterText: '', // Hide default counter
          ),
        ),
      ],
    );
  }

  Widget _buildPhotosSection(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Photos',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textDark : AppColors.textLight,
                letterSpacing: -0.015,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.textDark.withOpacity(0.2)
                    : AppColors.textLight.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                'Required',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Upload Dropzone
        GestureDetector(
          onTap: _pickImages,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.surfaceDark.withOpacity(0.5)
                  : Colors.white.withOpacity(0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark
                    ? AppColors.borderDarkSecondary
                    : AppColors.gray300,
                width: 2,
                style: BorderStyle.solid,
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.textDark.withOpacity(0.1)
                        : AppColors.textLight.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.add_a_photo,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                    size: 28,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Tap to upload',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Max 10 photos. Good photos sell faster!',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                ),
              ],
            ),
          ),
        ),
        // Image Thumbnails
        if (_selectedImages.isNotEmpty) ...[
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.gray200,
                    ),
                  ),
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(_selectedImages[index].path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: GestureDetector(
                          onTap: () => _removeImage(index),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.close,
                              size: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
        const SizedBox(height: 32), // Bottom padding
      ],
    );
  }

  Widget _buildBottomActions(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.gray200,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentStep > 0) ...[
              SizedBox(
                width: 48,
                height: 48,
                child: OutlinedButton(
                  onPressed: _handlePreviousStep,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: isDark
                        ? AppColors.textDark
                        : AppColors.textLight,
                    side: BorderSide(
                      color: isDark
                          ? AppColors.borderDark
                          : AppColors.gray200,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.zero,
                  ),
                  child: Icon(
                    Icons.arrow_back,
                    size: 24,
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              child: SizedBox(
                height: 48,
                child: ElevatedButton(
                  onPressed: _handleNextStep,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isDark
                        ? AppColors.textDark
                        : AppColors.textLight,
                    foregroundColor: isDark
                        ? AppColors.textLight
                        : AppColors.textDark,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    _currentStep == _totalSteps - 1 ? 'Submit' : 'Next Step',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.015,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build dropdown
  Widget _buildDropdown<T>({
    required String label,
    required T? value,
    required List<T> items,
    required String Function(T) getLabel,
    required int? Function(T) getId,
    required void Function(T?) onChanged,
    required bool isDark,
    bool required = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isDark ? AppColors.mutedDark : AppColors.gray700,
              ),
            ),
            if (required)
              Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.gray200,
            ),
          ),
          child: DropdownButtonFormField<T>(
            value: value,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
            ),
            dropdownColor: isDark ? AppColors.surfaceDark : Colors.white,
            style: TextStyle(
              color: isDark ? AppColors.textDark : AppColors.textLight,
              fontSize: 16,
            ),
            icon: Icon(
              Icons.arrow_drop_down,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            items: items.map((T item) {
              return DropdownMenuItem<T>(
                value: item,
                child: Text(getLabel(item)),
              );
            }).toList(),
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  // Helper method to build number field
  Widget _buildNumberField({
    required String label,
    required TextEditingController controller,
    required String placeholder,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          style: TextStyle(
            color: isDark ? AppColors.textDark : AppColors.textLight,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: isDark
                  ? AppColors.mutedDark.withOpacity(0.7)
                  : AppColors.mutedLight,
            ),
            filled: true,
            fillColor: isDark ? AppColors.surfaceDark : Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.gray200,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isDark ? AppColors.textDark : AppColors.textLight,
                width: 1,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }

  // Step 2: Vehicle Information
  Widget _buildVehicleInformationStep(bool isDark) {
    final brands = MockLookupService.getBrands();
    final fuelTypes = MockLookupService.getFuelTypes();
    final categories = MockLookupService.getCategories();
    final bodyTypes = MockLookupService.getBodyTypes();
    final colors = MockLookupService.getColors();
    final transmissions = MockLookupService.getTransmissions();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Text(
            'Vehicle Information',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textDark : AppColors.textLight,
              letterSpacing: -0.015,
            ),
          ),
        ),
        _buildTextField(
          label: 'Registration',
          controller: _registrationController,
          placeholder: 'Enter registration number',
          isDark: isDark,
          required: true,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'VIN',
          controller: _vinController,
          placeholder: 'Enter VIN (optional)',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildDropdown<BrandModel>(
          label: 'Brand',
          value: _selectedBrandId != null
              ? brands.firstWhere((b) => b.id == _selectedBrandId, orElse: () => brands.first)
              : null,
          items: brands,
          getLabel: (b) => b.name,
          getId: (b) => b.id,
          onChanged: (value) {
            setState(() {
              _selectedBrandId = value?.id;
            });
          },
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Brand Name (if not in list)',
          controller: _brandNameController,
          placeholder: 'Enter brand name',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Model Name',
          controller: _modelNameController,
          placeholder: 'Enter model name',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Model Year',
          controller: _modelYearController,
          placeholder: 'e.g. 2020',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildDropdown<FuelTypeModel>(
          label: 'Fuel Type',
          value: _selectedFuelTypeId != null
              ? fuelTypes.firstWhere((f) => f.id == _selectedFuelTypeId, orElse: () => fuelTypes.first)
              : null,
          items: fuelTypes,
          getLabel: (f) => f.name,
          getId: (f) => f.id,
          onChanged: (value) {
            setState(() {
              _selectedFuelTypeId = value?.id;
            });
          },
          isDark: isDark,
          required: true,
        ),
        const SizedBox(height: 20),
        _buildDropdown<CategoryModel>(
          label: 'Category',
          value: _selectedCategoryId != null
              ? categories.firstWhere((c) => c.id == _selectedCategoryId, orElse: () => categories.first)
              : null,
          items: categories,
          getLabel: (c) => c.name,
          getId: (c) => c.id,
          onChanged: (value) {
            setState(() {
              _selectedCategoryId = value?.id;
            });
          },
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildDropdown<BodyTypeModel>(
          label: 'Body Type',
          value: _selectedBodyTypeId != null
              ? bodyTypes.firstWhere((b) => b.id == _selectedBodyTypeId, orElse: () => bodyTypes.first)
              : null,
          items: bodyTypes,
          getLabel: (b) => b.name,
          getId: (b) => b.id,
          onChanged: (value) {
            setState(() {
              _selectedBodyTypeId = value?.id;
            });
          },
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildDropdown<ColorModel>(
          label: 'Color',
          value: _selectedColorId != null
              ? colors.firstWhere((c) => c.id == _selectedColorId, orElse: () => colors.first)
              : null,
          items: colors,
          getLabel: (c) => c.name,
          getId: (c) => c.id,
          onChanged: (value) {
            setState(() {
              _selectedColorId = value?.id;
            });
          },
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildDropdown<TransmissionModel>(
          label: 'Gear Type',
          value: _selectedGearTypeId != null
              ? transmissions.firstWhere((t) => t.id == _selectedGearTypeId, orElse: () => transmissions.first)
              : null,
          items: transmissions,
          getLabel: (t) => t.name,
          getId: (t) => t.id,
          onChanged: (value) {
            setState(() {
              _selectedGearTypeId = value?.id;
            });
          },
          isDark: isDark,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Step 3: Vehicle Specifications
  Widget _buildVehicleSpecificationsStep(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Text(
            'Vehicle Specifications',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textDark : AppColors.textLight,
              letterSpacing: -0.015,
            ),
          ),
        ),
        _buildNumberField(
          label: 'Mileage',
          controller: _mileageController,
          placeholder: 'Enter mileage',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'KM Driven',
          controller: _kmDrivenController,
          placeholder: 'Enter kilometers driven',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Engine Power (HP)',
          controller: _enginePowerController,
          placeholder: 'Enter engine power',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Engine Displacement (cc)',
          controller: _engineDisplacementController,
          placeholder: 'Enter engine displacement',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Engine Cylinders',
          controller: _engineCylindersController,
          placeholder: 'Enter number of cylinders',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Engine Code',
          controller: _engineCodeController,
          placeholder: 'Enter engine code',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Battery Capacity (kWh)',
          controller: _batteryCapacityController,
          placeholder: 'Enter battery capacity',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Range (km)',
          controller: _rangeKmController,
          placeholder: 'Enter range in km',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Charging Type',
          controller: _chargingTypeController,
          placeholder: 'Enter charging type',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Fuel Efficiency',
          controller: _fuelEfficiencyController,
          placeholder: 'Enter fuel efficiency',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Doors',
          controller: _doorsController,
          placeholder: 'Enter number of doors',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Minimum Seats',
          controller: _minSeatsController,
          placeholder: 'Enter minimum seats',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Maximum Seats',
          controller: _maxSeatsController,
          placeholder: 'Enter maximum seats',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Top Speed (km/h)',
          controller: _topSpeedController,
          placeholder: 'Enter top speed',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Wheels',
          controller: _wheelsController,
          placeholder: 'Enter number of wheels',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Total Weight (kg)',
          controller: _totalWeightController,
          placeholder: 'Enter total weight',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Vehicle Weight (kg)',
          controller: _vehicleWeightController,
          placeholder: 'Enter vehicle weight',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Towing Weight (kg)',
          controller: _towingWeightController,
          placeholder: 'Enter towing weight',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Ownership Tax',
          controller: _ownershipTaxController,
          placeholder: 'Enter ownership tax',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildNumberField(
          label: 'Airbags',
          controller: _airbagsController,
          placeholder: 'Enter number of airbags',
          isDark: isDark,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          label: 'Euro Norm',
          controller: _euronormController,
          placeholder: 'Enter Euro norm',
          isDark: isDark,
        ),
        const SizedBox(height: 32),
      ],
    );
  }

  // Step 4: Location & Additional Details
  Widget _buildLocationAndAdditionalStep(bool isDark) {
    final equipment = MockLookupService.getEquipment();
    final statuses = MockLookupService.getVehicleListStatuses();
    
    // Mock locations - in real app, fetch from API
    final mockLocations = [
      LocationModel(
        id: 1,
        city: 'Copenhagen',
        postcode: '1000',
        region: 'Hovedstaden',
        countryCode: 'DK',
        latitude: 55.6761,
        longitude: 12.5683,
      ),
      LocationModel(
        id: 2,
        city: 'Aarhus',
        postcode: '8000',
        region: 'Midtjylland',
        countryCode: 'DK',
        latitude: 56.1629,
        longitude: 10.2039,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 16),
          child: Text(
            'Location & Additional Details',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.textDark : AppColors.textLight,
              letterSpacing: -0.015,
            ),
          ),
        ),
        _buildDropdown<LocationModel>(
          label: 'Location',
          value: _selectedLocationId != null
              ? mockLocations.firstWhere((l) => l.id == _selectedLocationId, orElse: () => mockLocations.first)
              : null,
          items: mockLocations,
          getLabel: (l) => l.fullAddress,
          getId: (l) => l.id,
          onChanged: (value) {
            setState(() {
              _selectedLocationId = value?.id;
            });
          },
          isDark: isDark,
          required: true,
        ),
        const SizedBox(height: 20),
        _buildDropdown<VehicleListStatusModel>(
          label: 'Vehicle Status',
          value: _selectedVehicleListStatusId != null
              ? statuses.firstWhere((s) => s.id == _selectedVehicleListStatusId, orElse: () => statuses.first)
              : null,
          items: statuses,
          getLabel: (s) => s.name,
          getId: (s) => s.id,
          onChanged: (value) {
            setState(() {
              _selectedVehicleListStatusId = value?.id;
            });
          },
          isDark: isDark,
          required: true,
        ),
        const SizedBox(height: 20),
        Text(
          'Equipment',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AppColors.mutedDark : AppColors.gray700,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: equipment.map((eq) {
            final isSelected = _selectedEquipmentIds.contains(eq.id);
            return FilterChip(
              label: Text(eq.name),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  if (selected) {
                    _selectedEquipmentIds.add(eq.id);
                  } else {
                    _selectedEquipmentIds.remove(eq.id);
                  }
                });
              },
              backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              selectedColor: isDark
                  ? AppColors.textDark.withOpacity(0.3)
                  : AppColors.textLight.withOpacity(0.3),
              labelStyle: TextStyle(
                color: isSelected
                    ? (isDark ? AppColors.textDark : AppColors.textLight)
                    : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
              ),
              side: BorderSide(
                color: isSelected
                    ? (isDark ? AppColors.textDark : AppColors.textLight)
                    : (isDark ? AppColors.borderDark : AppColors.gray200),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

