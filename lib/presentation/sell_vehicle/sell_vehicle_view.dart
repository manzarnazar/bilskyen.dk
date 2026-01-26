import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/sell_vehicle_controller.dart';
import 'widgets/expandable_section.dart';
import 'widgets/license_plate_lookup.dart';
import 'widgets/vehicle_info_display.dart';
import 'widgets/image_upload_widget.dart';
import 'widgets/equipment_selection.dart';
import 'widgets/plan_selection.dart';

class SellVehicleView extends StatelessWidget {
  const SellVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellVehicleController());
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final isFormVisible = controller.isFormVisible.value;
      final isSubmitting = controller.isSubmitting.value;
      

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: const Text(
            'Sell Your Car',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 0,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    'Sell your car on Denmark\'s largest car market',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Enter your car\'s license plate and we\'ll help you with the rest. All fields are visible.',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // License Plate Lookup
                  const LicensePlateLookup(),
                  // Form (visible after successful lookup)
                  if (isFormVisible) ...[
                    const SizedBox(height: 24),
                    // Success Badge
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.primary10,
                        border: Border.all(
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Vehicle information loaded successfully! Review and complete the form below.',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Vehicle Info Display
                    const VehicleInfoDisplay(),
                    // Section 1: Basic Vehicle Information
                    ExpandableSection(
                      sectionId: 'basic-info',
                      title: 'Basic Vehicle Information',
                      subtitle: 'Title, variant, and color',
                      sectionNumber: 1,
                      isExpanded: controller.sectionExpanded['basic-info'] ?? true,
                      onToggle: () => controller.toggleSection('basic-info'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Basic information about your vehicle.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Title Display
                          Obx(() => Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? AppColors.surfaceDark
                                      : AppColors.mutedBackground,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: isDark
                                        ? AppColors.borderDark
                                        : AppColors.borderLight,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        controller.title.value.isNotEmpty
                                            ? controller.title.value
                                            : 'Vehicle title will be auto-generated',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: controller.title.value.isNotEmpty
                                              ? (isDark
                                                  ? AppColors.textDark
                                                  : AppColors.textLight)
                                              : (isDark
                                                  ? AppColors.mutedDark
                                                  : AppColors.mutedLight),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )),
                          const SizedBox(height: 8),
                          Text(
                            'Vehicle title automatically generated from vehicle information.',
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Variant Dropdown
                          DropdownButtonFormField<int>(
                            value: controller.variantId.value,
                            decoration: InputDecoration(
                              labelText: 'Variant',
                              hintText: 'Select Variant',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: controller.variants.map((variant) {
                              return DropdownMenuItem<int>(
                                value: variant.id,
                                child: Text(variant.name),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                controller.variantId.value = value,
                          ),
                          const SizedBox(height: 16),
                          // Color Dropdown
                          DropdownButtonFormField<int>(
                            value: controller.colorId.value,
                            decoration: InputDecoration(
                              labelText: 'Color',
                              hintText: 'Select Color',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: controller.colors.map((color) {
                              return DropdownMenuItem<int>(
                                value: color.id,
                                child: Text(color.name),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                controller.colorId.value = value,
                          ),
                        ],
                      ),
                    ),
                    // Section 2: Vehicle Specifications
                    ExpandableSection(
                      sectionId: 'specifications',
                      title: 'Vehicle Specifications',
                      subtitle:
                          'Kilometer driven, registration, inspection, and technical details',
                      sectionNumber: 2,
                      isExpanded:
                          controller.sectionExpanded['specifications'] ?? true,
                      onToggle: () =>
                          controller.toggleSection('specifications'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Technical specifications and registration details.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Kilometer Driven
                          TextFormField(
                            controller: controller.kmDrivenController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Kilometer Driven *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Kilometer driven is required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // First Registration
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: controller.firstRegistrationMonth.value,
                                  decoration: InputDecoration(
                                    labelText: 'First Registration Month',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: List.generate(12, (index) {
                                    final month = index + 1;
                                    return DropdownMenuItem<int>(
                                      value: month,
                                      child: Text(_getMonthName(month)),
                                    );
                                  }),
                                  onChanged: (value) =>
                                      controller.firstRegistrationMonth.value =
                                          value,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: controller.firstRegistrationYear.value,
                                  decoration: InputDecoration(
                                    labelText: 'First Registration Year',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: List.generate(
                                      DateTime.now().year - 1899, (index) {
                                    final year = DateTime.now().year - index;
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }),
                                  onChanged: (value) =>
                                      controller.firstRegistrationYear.value =
                                          value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Last Inspection
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: controller.lastInspectionMonth.value,
                                  decoration: InputDecoration(
                                    labelText: 'Last Inspection Month',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: List.generate(12, (index) {
                                    final month = index + 1;
                                    return DropdownMenuItem<int>(
                                      value: month,
                                      child: Text(_getMonthName(month)),
                                    );
                                  }),
                                  onChanged: (value) =>
                                      controller.lastInspectionMonth.value =
                                          value,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: controller.lastInspectionYear.value,
                                  decoration: InputDecoration(
                                    labelText: 'Last Inspection Year',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: List.generate(
                                      DateTime.now().year - 1899, (index) {
                                    final year = DateTime.now().year - index;
                                    return DropdownMenuItem<int>(
                                      value: year,
                                      child: Text(year.toString()),
                                    );
                                  }),
                                  onChanged: (value) =>
                                      controller.lastInspectionYear.value =
                                          value,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Fuel Efficiency
                          TextFormField(
                            controller: controller.fuelEfficiencyController,
                            keyboardType:
                                const TextInputType.numberWithOptions(decimal: true),
                            decoration: InputDecoration(
                              labelText: 'KM/L',
                              hintText: '0.00',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Technical Total Weight
                          TextFormField(
                            controller: controller.technicalTotalWeightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Total Technical Weight (kg)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Euronom
                          DropdownButtonFormField<int>(
                            value: controller.euronomId.value,
                            decoration: InputDecoration(
                              labelText: 'Euronom',
                              hintText: 'Select Euronom',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            items: controller.euronorms.map((euronom) {
                              return DropdownMenuItem<int>(
                                value: euronom.id,
                                child: Text(euronom.name),
                              );
                            }).toList(),
                            onChanged: (value) =>
                                controller.euronomId.value = value,
                          ),
                        ],
                      ),
                    ),
                    // Section 3: Equipment & Features
                    ExpandableSection(
                      sectionId: 'equipment',
                      title: 'Equipment & Features',
                      subtitle: 'Select the equipment your vehicle has',
                      sectionNumber: 3,
                      isExpanded: controller.sectionExpanded['equipment'] ?? true,
                      onToggle: () => controller.toggleSection('equipment'),
                      child: const EquipmentSelection(),
                    ),
                    // Section 4: Pricing & Tax
                    ExpandableSection(
                      sectionId: 'pricing',
                      title: 'Pricing & Tax',
                      subtitle: 'Price and tax information',
                      sectionNumber: 4,
                      isExpanded: controller.sectionExpanded['pricing'] ?? true,
                      onToggle: () => controller.toggleSection('pricing'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price
                          TextFormField(
                            controller: controller.priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Price (DKK) *',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Price is required';
                              }
                              if (int.tryParse(value) == null) {
                                return 'Please enter a valid number';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Tax Information (Expandable)
                          InkWell(
                            onTap: () => controller.taxInfoExpanded.value =
                                !controller.taxInfoExpanded.value,
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isDark
                                      ? AppColors.borderDark
                                      : AppColors.borderLight,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tax Information Based on Mileage',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: isDark
                                          ? AppColors.textDark
                                          : AppColors.textLight,
                                    ),
                                  ),
                                  Obx(() => AnimatedRotation(
                                        turns:
                                            controller.taxInfoExpanded.value
                                                ? 0.5
                                                : 0,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          color: isDark
                                              ? AppColors.textDark
                                              : AppColors.textLight,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                          ),
                          Obx(() => controller.taxInfoExpanded.value
                              ? Padding(
                                  padding: const EdgeInsets.only(top: 12),
                                  child: Text(
                                    'Tax information based on mileage - To be implemented after consulting with Berken.',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isDark
                                          ? AppColors.mutedDark
                                          : AppColors.mutedLight,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink()),
                        ],
                      ),
                    ),
                    // Section 5: Photos
                    ExpandableSection(
                      sectionId: 'photos',
                      title: 'Photos',
                      subtitle: 'Add photos of your vehicle',
                      sectionNumber: 5,
                      isExpanded: controller.sectionExpanded['photos'] ?? true,
                      onToggle: () => controller.toggleSection('photos'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add photos of your vehicle. Good photos help your listing sell faster! You can select multiple images.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const ImageUploadWidget(),
                        ],
                      ),
                    ),
                    // Section 6: Description
                    ExpandableSection(
                      sectionId: 'description',
                      title: 'Description',
                      subtitle: 'Vehicle description',
                      sectionNumber: 6,
                      isExpanded:
                          controller.sectionExpanded['description'] ?? true,
                      onToggle: () =>
                          controller.toggleSection('description'),
                      child: TextFormField(
                        controller: controller.descriptionController,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          hintText: 'Enter vehicle description...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                    // Section 7: Seller Information
                    ExpandableSection(
                      sectionId: 'seller-info',
                      title: 'Seller Information',
                      subtitle: 'Your contact details',
                      sectionNumber: 7,
                      isExpanded:
                          controller.sectionExpanded['seller-info'] ?? true,
                      onToggle: () =>
                          controller.toggleSection('seller-info'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Phone
                          TextFormField(
                            controller: controller.sellerPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: 'Phone',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Phone number is required';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Address with autocomplete
                          Stack(
                            children: [
                              TextFormField(
                                controller: controller.sellerAddressController,
                                decoration: InputDecoration(
                                  labelText: 'Location',
                                  hintText: 'Your address',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.searchLocations(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Address is required';
                                  }
                                  return null;
                                },
                              ),
                              Obx(() => controller.showLocationSuggestions.value
                                  ? Positioned(
                                      top: 60,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        constraints: const BoxConstraints(
                                          maxHeight: 200,
                                        ),
                                        decoration: BoxDecoration(
                                          color: isDark
                                              ? AppColors.cardDark
                                              : AppColors.cardLight,
                                          border: Border.all(
                                            color: isDark
                                                ? AppColors.borderDark
                                                : AppColors.borderLight,
                                          ),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: controller
                                              .locationSuggestions.length,
                                          itemBuilder: (context, index) {
                                            final location = controller
                                                .locationSuggestions[index];
                                            return ListTile(
                                              title: Text(location.displayName),
                                              onTap: () =>
                                                  controller.selectLocation(
                                                      location),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  : const SizedBox.shrink()),
                            ],
                          ),
                          const SizedBox(height: 16),
                          // Postal Code
                          TextFormField(
                            controller: controller.sellerPostcodeController,
                            decoration: InputDecoration(
                              labelText: 'Postal Code',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Postal code is required';
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    // Section 8: Packages
                    ExpandableSection(
                      sectionId: 'packages',
                      title: 'Packages',
                      subtitle: 'Select a package for your listing',
                      sectionNumber: 8,
                      isExpanded:
                          controller.sectionExpanded['packages'] ?? true,
                      onToggle: () => controller.toggleSection('packages'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select a package to enhance your vehicle listing. Each package includes different features.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const PlanSelection(),
                        ],
                      ),
                    ),
                    // Submit Section
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: isDark
                            ? AppColors.surfaceDark
                            : AppColors.mutedBackground,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Ready to publish your listing?',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Review your information and click the button below to publish your vehicle listing.',
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isSubmitting
                                  ? null
                                  : controller.submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.primaryForeground,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: isSubmitting
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                          AppColors.primaryForeground,
                                        ),
                                      ),
                                    )
                                  : const Text(
                                      'Publish Vehicle Listing',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  String _getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return months[month - 1];
  }
}
