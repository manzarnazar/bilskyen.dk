import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/sell_vehicle_controller.dart';
import 'widgets/expandable_section.dart';
import 'widgets/license_plate_lookup.dart';
import 'widgets/vehicle_info_display.dart';
import 'widgets/image_upload_widget.dart';
import 'widgets/equipment_selection.dart';
import 'widgets/plan_selection.dart';

class SellVehicleView extends StatefulWidget {
  const SellVehicleView({super.key});

  @override
  State<SellVehicleView> createState() => _SellVehicleViewState();
}

class _SellVehicleViewState extends State<SellVehicleView> {
  @override
  void dispose() {
    // Defer controller deletion to next frame so the element tree is fully torn down first.
    // Deleting synchronously in dispose() can cause _InactiveElements.remove assertion when
    // GlobalKeys are still attached to elements being disposed.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<SellVehicleController>()) {
        Get.delete<SellVehicleController>(force: true);
      }
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellVehicleController());
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final isFormVisible = controller.isFormVisible.value;
      final isSubmitting = controller.isSubmitting.value;
      

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          title: Text(
            l10n.sellYourCar,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: AppColors.primary,
          elevation: 0,
          surfaceTintColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Text(
                    l10n.sellYourCarOnDenmarkMarket,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.sellYourCarSubtitle,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // License Plate Lookup
                  SizedBox(key: controller.sectionScrollKeys['license'], child: const LicensePlateLookup()),
                  // Form (visible after successful lookup or manual entry)
                  if (isFormVisible) ...[
                    const SizedBox(height: 24),
                    // Start over link
                    Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: GestureDetector(
                              onTap: controller.startOver,
                              child: Text(
                                l10n.startOver,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w500,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                    // Success Badge (only when from lookup, not manual entry)
                    Obx(() => !controller.isManualEntryMode.value
                        ? Container(
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
                                    l10n.vehicleInfoLoadedSuccess,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox.shrink()),
                    // Vehicle Info Display (only when from lookup)
                    Obx(() => !controller.isManualEntryMode.value
                        ? const VehicleInfoDisplay()
                        : const SizedBox.shrink()),
                    // Section 1: Basic Vehicle Information
                    ExpandableSection(
                      key: controller.sectionScrollKeys['basic-info'],
                      sectionId: 'basic-info',
                      title: l10n.sellSectionBasicInfoTitle,
                      subtitle: l10n.sellSectionBasicInfoSubtitle,
                      sectionNumber: 1,
                      isExpanded: controller.sectionExpanded['basic-info'] ?? true,
                      onToggle: () => controller.toggleSection('basic-info'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sellSectionBasicInfoDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Manual entry fields (when no registration number)
                          Obx(() => controller.isManualEntryMode.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.enterManuallyLead,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: isDark
                                            ? AppColors.mutedDark
                                            : AppColors.mutedLight,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    if (controller.isLoadingManualDropdowns.value)
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 12),
                                        child: Row(
                                          children: [
                                            SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                                color: AppColors.primary,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Loading options…',
                                              style: TextStyle(
                                                fontSize: 12,
                                                color: isDark
                                                    ? AppColors.mutedDark
                                                    : AppColors.mutedLight,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    // Brand (DMR)
                                    DropdownButtonFormField<int>(
                                      value: controller.manualBrandId.value,
                                      decoration: InputDecoration(
                                        labelText: l10n.brandRequired,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: controller.dmrManualBrands
                                          .map((b) => DropdownMenuItem<int>(
                                                value: b.id,
                                                child: Text(
                                                  b.name,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: controller.isLoadingManualDropdowns.value
                                          ? null
                                          : (v) => controller.onManualBrandChanged(v),
                                    ),
                                    const SizedBox(height: 16),
                                    // Model (DMR, after brand)
                                    Obx(() {
                                      final modelList = controller.dmrManualModels;
                                      return DropdownButtonFormField<int>(
                                        value: controller.manualModelId.value,
                                        decoration: InputDecoration(
                                          labelText: l10n.modelRequired,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        items: modelList
                                            .map((m) => DropdownMenuItem<int>(
                                                  value: m.id,
                                                  child: Text(
                                                    m.name,
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ))
                                            .toList(),
                                        onChanged: controller.manualBrandId.value == null ||
                                                controller.isLoadingManualDropdowns.value
                                            ? null
                                            : (v) => controller.onManualModelChanged(v),
                                      );
                                    }),
                                    const SizedBox(height: 16),
                                    // Model year (integer year, matches DMR `model_aar`)
                                    DropdownButtonFormField<int>(
                                      value: controller.manualModelYearId.value,
                                      decoration: InputDecoration(
                                        labelText: l10n.yearRequired,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: List.generate(
                                        DateTime.now().year - 1974,
                                        (index) {
                                          final year = DateTime.now().year - index;
                                          return DropdownMenuItem<int>(
                                            value: year,
                                            child: Text('$year'),
                                          );
                                        },
                                      ),
                                      onChanged: (v) =>
                                          controller.manualModelYearId.value = v,
                                    ),
                                    const SizedBox(height: 16),
                                    // Fuel Type (DMR drive energies)
                                    DropdownButtonFormField<int>(
                                      value: controller.manualFuelTypeId.value,
                                      decoration: InputDecoration(
                                        labelText: l10n.fuelTypeRequired,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      items: controller.dmrManualFuelTypes
                                          .map((f) => DropdownMenuItem<int>(
                                                value: f.id,
                                                child: Text(
                                                  f.name,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ))
                                          .toList(),
                                      onChanged: (v) =>
                                          controller.manualFuelTypeId.value = v,
                                    ),
                                    const SizedBox(height: 24),
                                  ],
                                )
                              : const SizedBox.shrink()),
                          // Title Display (when from lookup)
                          Obx(() => !controller.isManualEntryMode.value
                              ? Container(
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
                                            : l10n.vehicleTitleAutoGenerated,
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
                              )
                              : const SizedBox.shrink()),
                          Obx(() => !controller.isManualEntryMode.value
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 8),
                                    Text(
                                      l10n.sellTitleHelp,
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? AppColors.mutedDark
                                            : AppColors.mutedLight,
                                      ),
                                    ),
                                  ],
                                )
                              : const SizedBox.shrink()),
                          // Fuel type (lookup flow — editable; manual flow uses DMR fuel above)
                          Obx(() {
                            if (controller.isManualEntryMode.value ||
                                controller.vehicleData.value == null) {
                              return const SizedBox.shrink();
                            }
                            final effectiveId = controller.lookupFuelTypeId.value ??
                                controller.vehicleData.value?.fuelType?.id;
                            final fuelTypeItems = <DropdownMenuItem<int>>[
                              ...controller.fuelTypes.map(
                                (f) => DropdownMenuItem<int>(
                                  value: f.id,
                                  child: Text(
                                    f.name,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ];
                            if (effectiveId != null &&
                                !controller.fuelTypes.any((f) => f.id == effectiveId)) {
                              fuelTypeItems.add(
                                DropdownMenuItem<int>(
                                  value: effectiveId,
                                  child: Text(
                                    controller.vehicleData.value?.fuelType?.name ??
                                        '$effectiveId',
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              );
                            }
                            final value = effectiveId != null &&
                                    (controller.fuelTypes.any((f) => f.id == effectiveId) ||
                                        effectiveId ==
                                            controller.vehicleData.value?.fuelType?.id)
                                ? effectiveId
                                : null;
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: DropdownButtonFormField<int>(
                                value: value,
                                decoration: InputDecoration(
                                  labelText: l10n.fuelTypeRequired,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: isDark
                                      ? AppColors.surfaceDark
                                      : AppColors.mutedBackground,
                                ),
                                items: fuelTypeItems,
                                onChanged: (v) => controller.lookupFuelTypeId.value = v,
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          // Variant Dropdown
                          Obx(() {
                            // Get variant items from the variants list
                            final variantItems = controller.variants.map((variant) {
                              return DropdownMenuItem<int>(
                                value: variant.id,
                                child: Text(variant.name),
                              );
                            }).toList();
                            
                            // If variant from lookup API is not in the list, add it
                            if (controller.variantId.value != null &&
                                controller.vehicleData.value?.variant != null) {
                              final lookupVariant = controller.vehicleData.value!.variant!;
                              final variantExists = controller.variants
                                  .any((v) => v.id == lookupVariant.id);
                              
                              if (!variantExists) {
                                variantItems.add(
                                  DropdownMenuItem<int>(
                                    value: lookupVariant.id,
                                    child: Text(lookupVariant.name),
                                  ),
                                );
                              }
                            }
                            
                            return DropdownButtonFormField<int>(
                              value: controller.variantId.value,
                              decoration: InputDecoration(
                                labelText: l10n.sellVariantLabel,
                                hintText: l10n.selectVariant,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.mutedBackground,
                              ),
                              items: variantItems,
                              onChanged: (value) => controller.variantId.value = value,
                            );
                          }),
                          const SizedBox(height: 16),
                          // Color Dropdown
                          DropdownButtonFormField<int>(
                            value: controller.colorId.value,
                            decoration: InputDecoration(
                              labelText: l10n.sellColorLabel,
                              hintText: l10n.selectColor,
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
                      key: controller.sectionScrollKeys['specifications'],
                      sectionId: 'specifications',
                      title: l10n.sellSectionSpecsTitle,
                      subtitle: l10n.sellSectionSpecsSubtitle,
                      sectionNumber: 2,
                      isExpanded:
                          controller.sectionExpanded['specifications'] ?? true,
                      onToggle: () =>
                          controller.toggleSection('specifications'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sellSectionSpecsDescription,
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
                            key: controller.formFieldKeys[0],
                            controller: controller.kmDrivenController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.kilometerDrivenRequired,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.kmDrivenRequired;
                              }
                              if (int.tryParse(value) == null) {
                                return l10n.pleaseEnterValidNumber;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Gear Type
                          Obx(() {
                            final gearTypeItems = controller.gearTypes.map((gt) {
                              return DropdownMenuItem<int>(
                                value: gt.id,
                                child: Text(gt.name),
                              );
                            }).toList();
                            return DropdownButtonFormField<int>(
                              value: controller.gearTypeId.value,
                              decoration: InputDecoration(
                                labelText: l10n.gearType,
                                hintText: l10n.selectGearType,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: isDark
                                    ? AppColors.surfaceDark
                                    : AppColors.mutedBackground,
                              ),
                              items: gearTypeItems,
                              onChanged: (value) =>
                                  controller.gearTypeId.value = value,
                            );
                          }),
                          const SizedBox(height: 16),
                          // First Registration
                          Row(
                            children: [
                              Expanded(
                                child: DropdownButtonFormField<int>(
                                  value: controller.firstRegistrationMonth.value,
                                  decoration: InputDecoration(
                                    labelText: l10n.firstRegistrationMonth,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: List.generate(12, (index) {
                                    final month = index + 1;
                                    return DropdownMenuItem<int>(
                                      value: month,
                                      child: Text(_getMonthName(context, month)),
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
                                    labelText: l10n.firstRegistrationYear,
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
                                    labelText: l10n.lastInspectionMonth,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  items: List.generate(12, (index) {
                                    final month = index + 1;
                                    return DropdownMenuItem<int>(
                                      value: month,
                                      child: Text(_getMonthName(context, month)),
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
                                    labelText: l10n.lastInspectionYear,
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
                          // Fuel Efficiency (label changes based on fuel type)
                          Obx(() {
                            String labelText;
                            String hintText;

                            if (controller.isManualEntryMode.value &&
                                controller.manualFuelTypeId.value != null) {
                              String name = '';
                              for (final f in controller.dmrManualFuelTypes) {
                                if (f.id == controller.manualFuelTypeId.value) {
                                  name = f.name.toLowerCase();
                                  break;
                                }
                              }
                              if (name.contains('hybrid') || name.contains('plug')) {
                                labelText = l10n.electricRangeOrKmPerL;
                                hintText = '0.00';
                              } else if (name.contains('el') ||
                                  name.contains('electric') ||
                                  name.contains('battery')) {
                                labelText = l10n.electricRangeKm;
                                hintText = '0';
                              } else {
                                labelText = l10n.kmPerL;
                                hintText = '0.00';
                              }
                            } else {
                              final fuelTypeId = controller
                                      .lookupFuelTypeId.value ??
                                  controller.vehicleData.value?.fuelType?.id;
                              const electricFuelTypes = [3, 7];
                              const hybridFuelTypes = [4, 5];
                              if (fuelTypeId != null &&
                                  electricFuelTypes.contains(fuelTypeId)) {
                                labelText = l10n.electricRangeKm;
                                hintText = '0';
                              } else if (fuelTypeId != null &&
                                  hybridFuelTypes.contains(fuelTypeId)) {
                                labelText = l10n.electricRangeOrKmPerL;
                                hintText = '0.00';
                              } else {
                                labelText = l10n.kmPerL;
                                hintText = '0.00';
                              }
                            }
                            
                            return TextFormField(
                              controller: controller.fuelEfficiencyController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(decimal: true),
                              decoration: InputDecoration(
                                labelText: labelText,
                                hintText: hintText,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(height: 16),
                          // Technical Total Weight
                          TextFormField(
                            controller: controller.technicalTotalWeightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.technicalTotalWeightKg,
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
                              labelText: l10n.euronom,
                              hintText: l10n.selectEuronom,
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
                      key: controller.sectionScrollKeys['equipment'],
                      sectionId: 'equipment',
                      title: l10n.sellSectionEquipmentTitle,
                      subtitle: l10n.sellSectionEquipmentSubtitle,
                      sectionNumber: 3,
                      isExpanded: controller.sectionExpanded['equipment'] ?? true,
                      onToggle: () => controller.toggleSection('equipment'),
                      child: const EquipmentSelection(),
                    ),
                    // Section 4: Pricing & Tax
                    ExpandableSection(
                      key: controller.sectionScrollKeys['pricing'],
                      sectionId: 'pricing',
                      title: l10n.sellSectionPricingTitle,
                      subtitle: l10n.sellSectionPricingSubtitle,
                      sectionNumber: 4,
                      isExpanded: controller.sectionExpanded['pricing'] ?? true,
                      onToggle: () => controller.toggleSection('pricing'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Price
                          TextFormField(
                            key: controller.formFieldKeys[1],
                            controller: controller.priceController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: l10n.priceDkkRequired,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.priceRequired;
                              }
                              if (int.tryParse(value) == null) {
                                return l10n.pleaseEnterValidNumber;
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
                                    l10n.taxInfoTitle,
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
                                    l10n.taxInfoDescription,
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
                      key: controller.sectionScrollKeys['photos'],
                      sectionId: 'photos',
                      title: l10n.sellSectionPhotosTitle,
                      subtitle: l10n.sellSectionPhotosSubtitle,
                      sectionNumber: 5,
                      isExpanded: controller.sectionExpanded['photos'] ?? true,
                      onToggle: () => controller.toggleSection('photos'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sellSectionPhotosDescription,
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
                      key: controller.sectionScrollKeys['description'],
                      sectionId: 'description',
                      title: l10n.sellSectionDescriptionTitle,
                      subtitle: l10n.sellSectionDescriptionSubtitle,
                      sectionNumber: 6,
                      isExpanded:
                          controller.sectionExpanded['description'] ?? true,
                      onToggle: () =>
                          controller.toggleSection('description'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.sellSectionDescriptionDescription,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: controller.descriptionController,
                            maxLines: 6,
                            minLines: 4,
                            onChanged: (_) =>
                                controller.markDescriptionUserEdited(),
                            decoration: InputDecoration(
                              labelText: l10n.messageLabel,
                              hintText: l10n.enterVehicleDescription,
                              alignLabelWithHint: true,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.describeYourVehicle,
                            style: TextStyle(
                              fontSize: 11,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Section 7: Seller Information
                    ExpandableSection(
                      key: controller.sectionScrollKeys['seller-info'],
                      sectionId: 'seller-info',
                      title: l10n.sellSectionSellerTitle,
                      subtitle: l10n.sellSectionSellerSubtitle,
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
                            key: controller.formFieldKeys[2],
                            controller: controller.sellerPhoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: l10n.phone,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.phoneRequired;
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 16),
                          // Address with autocomplete
                          Stack(
                            children: [
                              TextFormField(
                                key: controller.formFieldKeys[3],
                                controller: controller.sellerAddressController,
                                decoration: InputDecoration(
                                  labelText: l10n.location,
                                  hintText: l10n.yourAddress,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                onChanged: (value) {
                                  controller.searchLocations(value);
                                },
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return l10n.addressRequired;
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
                            key: controller.formFieldKeys[4],
                            controller: controller.sellerPostcodeController,
                            decoration: InputDecoration(
                              labelText: l10n.postalCodeLabel,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return l10n.postalCodeRequired;
                              }
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    // Section 8: Packages
                    ExpandableSection(
                      key: controller.sectionScrollKeys['packages'],
                      sectionId: 'packages',
                      title: l10n.sellSectionPackagesTitle,
                      subtitle: l10n.sellSectionPackagesSubtitle,
                      sectionNumber: 8,
                      isExpanded:
                          controller.sectionExpanded['packages'] ?? true,
                      onToggle: () => controller.toggleSection('packages'),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.selectPackageDescription,
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
                            l10n.readyToPublish,
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
                            l10n.readyToPublishDescription,
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
                              child: Text(
                                l10n.publishVehicleListing,
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
              // Overlay loading indicator
              if (isSubmitting)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  String _getMonthName(BuildContext context, int month) {
    final locale = Localizations.localeOf(context).toString();
    final date = DateTime(2000, month, 1);
    return intl.DateFormat('MMMM', locale).format(date);
  }
}
