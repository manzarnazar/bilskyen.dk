import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/edit_vehicle_controller.dart';
import '../sell_vehicle/widgets/expandable_section.dart';
class EditVehicleView extends StatelessWidget {
  const EditVehicleView({super.key});

  @override
  Widget build(BuildContext context) {
    final idStr = Get.parameters['id'];
    final id = int.tryParse(idStr ?? '');
    if (id == null || id == 0) {
      return Scaffold(
        body: Center(child: Text('Invalid vehicle id', style: TextStyle(color: AppColors.textLight))),
      );
    }

    final controller = Get.put(EditVehicleController(vehicleId: id));
    final appController = Get.find<AppController>();
    final l10n = AppLocalizations.of(context)!;

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          scrolledUnderElevation: 0,
          foregroundColor: AppColors.primary,
          iconTheme: const IconThemeData(color: AppColors.primary),
          elevation: 0,
          automaticallyImplyLeading: Navigator.canPop(context),
          title: Text(
            l10n.editVehicle,
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            if (!controller.isLoading.value && controller.loadError.value.isEmpty)
              TextButton(
                onPressed: controller.isSubmitting.value ? null : () => controller.save(),
                child: controller.isSubmitting.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      )
                    : Text(
                        'Save',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
          ],
        ),
        body: controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.loadError.value.isNotEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.loadError.value,
                            style: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          TextButton(
                            onPressed: () => Get.back(),
                            child: const Text('Go back'),
                          ),
                        ],
                      ),
                    ),
                  )
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ExpandableSection(
                            sectionId: 'basic-info',
                            title: 'Basic Vehicle Information',
                            subtitle: 'Title, variant, color, and fuel type',
                            sectionNumber: 1,
                            isExpanded: controller.sectionExpanded['basic-info'] ?? true,
                            onToggle: () => controller.toggleSection('basic-info'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: controller.titleController,
                                  decoration: InputDecoration(
                                    labelText: 'Title',
                                    hintText: 'Vehicle title',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Obx(() {
                                      if (controller.isLoadingVariants.value) {
                                        return InputDecorator(
                                          decoration: InputDecoration(
                                            labelText: 'Variant',
                                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                            filled: true,
                                            fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                          ),
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
                                              const SizedBox(width: 10),
                                              Text(
                                                'Loading variants…',
                                                style: TextStyle(
                                                  fontSize: 14,
                                                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      final vid = controller.variantId.value;
                                      final variantItems = controller.variants
                                          .map((v) => DropdownMenuItem<int>(value: v.id, child: Text(v.name)))
                                          .toList();
                                      if (vid != null &&
                                          !controller.variants.any((v) => v.id == vid)) {
                                        variantItems.add(
                                          DropdownMenuItem<int>(
                                            value: vid,
                                            child: Text(
                                              controller.initialVariantName ?? 'Variant $vid',
                                            ),
                                          ),
                                        );
                                      }
                                      final variantValue =
                                          vid != null && variantItems.any((e) => e.value == vid) ? vid : null;
                                      return DropdownButtonFormField<int>(
                                        value: variantValue,
                                        decoration: InputDecoration(
                                          labelText: 'Variant',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          filled: true,
                                          fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                        ),
                                        items: variantItems,
                                        onChanged: variantItems.isEmpty
                                            ? null
                                            : (v) => controller.variantId.value = v,
                                      );
                                    }),
                                const SizedBox(height: 16),
                                Obx(() {
                                      final colorItems = controller.colors
                                          .map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.name)))
                                          .toList();
                                      final colorValue = controller.colorId.value != null &&
                                          controller.colors.any((c) => c.id == controller.colorId.value)
                                          ? controller.colorId.value
                                          : null;
                                      return DropdownButtonFormField<int>(
                                        value: colorValue,
                                        decoration: InputDecoration(
                                          labelText: 'Color',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          filled: true,
                                          fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                        ),
                                        items: colorItems,
                                        onChanged: (v) => controller.colorId.value = v,
                                      );
                                    }),
                                const SizedBox(height: 16),
                                Obx(() {
                                      final fid = controller.fuelTypeId.value;
                                      final fuelItems = controller.fuelTypes
                                          .map((f) => DropdownMenuItem<int>(
                                                value: f.id,
                                                child: Text(f.name),
                                              ))
                                          .toList();
                                      if (fid != null && !controller.fuelTypes.any((f) => f.id == fid)) {
                                        fuelItems.add(
                                          DropdownMenuItem<int>(
                                            value: fid,
                                            child: Text(
                                              controller.initialFuelTypeName ?? 'Fuel $fid',
                                            ),
                                          ),
                                        );
                                      }
                                      final fuelValue =
                                          fid != null && fuelItems.any((e) => e.value == fid) ? fid : null;
                                      return DropdownButtonFormField<int>(
                                        value: fuelValue,
                                        decoration: InputDecoration(
                                          labelText: 'Fuel type',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          filled: true,
                                          fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                        ),
                                        items: fuelItems,
                                        onChanged: fuelItems.isEmpty
                                            ? null
                                            : (v) => controller.fuelTypeId.value = v,
                                      );
                                    }),
                              ],
                            ),
                          ),
                          ExpandableSection(
                            sectionId: 'specifications',
                            title: 'Vehicle Specifications',
                            subtitle: 'Kilometer driven, registration date, and technical details',
                            sectionNumber: 2,
                            isExpanded: controller.sectionExpanded['specifications'] ?? true,
                            onToggle: () => controller.toggleSection('specifications'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: controller.kmDrivenController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Kilometer driven *',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                  validator: (v) {
                                    if (v == null || v.trim().isEmpty) return 'Required';
                                    if (int.tryParse(v.trim()) == null) return 'Enter a number';
                                    return null;
                                  },
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                            const monthItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
                                            final monthValue = controller.firstRegistrationMonth.value != null &&
                                                monthItems.contains(controller.firstRegistrationMonth.value)
                                                ? controller.firstRegistrationMonth.value
                                                : null;
                                            return DropdownButtonFormField<int>(
                                              value: monthValue,
                                              decoration: InputDecoration(
                                                labelText: 'First reg. month',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                filled: true,
                                                fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                              ),
                                              items: monthItems
                                                  .map((m) => DropdownMenuItem<int>(
                                                        value: m,
                                                        child: Text(_monthName(m)),
                                                      ))
                                                  .toList(),
                                              onChanged: (v) => controller.firstRegistrationMonth.value = v,
                                            );
                                          }),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Obx(() {
                                            final yearItems = List.generate(30, (i) => DateTime.now().year - 29 + i)
                                                .reversed
                                                .toList();
                                            final yearValue = controller.firstRegistrationYear.value != null &&
                                                yearItems.contains(controller.firstRegistrationYear.value)
                                                ? controller.firstRegistrationYear.value
                                                : null;
                                            return DropdownButtonFormField<int>(
                                              value: yearValue,
                                              decoration: InputDecoration(
                                                labelText: 'First reg. year',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                filled: true,
                                                fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                              ),
                                              items: yearItems
                                                  .map((y) => DropdownMenuItem<int>(value: y, child: Text('$y')))
                                                  .toList(),
                                              onChanged: (v) => controller.firstRegistrationYear.value = v,
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Obx(() {
                                            const monthItems = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12];
                                            final monthValue = controller.lastInspectionMonth.value != null &&
                                                monthItems.contains(controller.lastInspectionMonth.value)
                                                ? controller.lastInspectionMonth.value
                                                : null;
                                            return DropdownButtonFormField<int>(
                                              value: monthValue,
                                              decoration: InputDecoration(
                                                labelText: 'Last inspection month',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                filled: true,
                                                fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                              ),
                                              items: monthItems
                                                  .map((m) => DropdownMenuItem<int>(
                                                        value: m,
                                                        child: Text(_monthName(m)),
                                                      ))
                                                  .toList(),
                                              onChanged: (v) => controller.lastInspectionMonth.value = v,
                                            );
                                          }),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Obx(() {
                                            final yearItems = List.generate(30, (i) => DateTime.now().year - 29 + i)
                                                .reversed
                                                .toList();
                                            final yearValue = controller.lastInspectionYear.value != null &&
                                                yearItems.contains(controller.lastInspectionYear.value)
                                                ? controller.lastInspectionYear.value
                                                : null;
                                            return DropdownButtonFormField<int>(
                                              value: yearValue,
                                              decoration: InputDecoration(
                                                labelText: 'Last inspection year',
                                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                                filled: true,
                                                fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                              ),
                                              items: yearItems
                                                  .map((y) => DropdownMenuItem<int>(value: y, child: Text('$y')))
                                                  .toList(),
                                              onChanged: (v) => controller.lastInspectionYear.value = v,
                                            );
                                          }),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: controller.technicalTotalWeightController,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: 'Technical total weight (kg)',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: controller.fuelEfficiencyController,
                                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                  decoration: InputDecoration(
                                    labelText: 'Fuel efficiency (km/l)',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Obx(() {
                                      final euronomItems = [
                                        const DropdownMenuItem<int>(value: null, child: Text('—')),
                                        ...controller.euronorms
                                            .map((e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name))),
                                      ];
                                      final euronomValue = controller.euronomId.value != null &&
                                          controller.euronorms.any((e) => e.id == controller.euronomId.value)
                                          ? controller.euronomId.value
                                          : null;
                                      return DropdownButtonFormField<int>(
                                        value: euronomValue,
                                        decoration: InputDecoration(
                                          labelText: 'Euronom',
                                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                          filled: true,
                                          fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                        ),
                                        items: euronomItems,
                                        onChanged: (v) => controller.euronomId.value = v,
                                      );
                                    }),
                              ],
                            ),
                          ),
                          ExpandableSection(
                            sectionId: 'equipment',
                            title: 'Equipment',
                            subtitle: 'Select equipment and features',
                            sectionNumber: 3,
                            isExpanded: controller.sectionExpanded['equipment'] ?? true,
                            onToggle: () => controller.toggleSection('equipment'),
                            child: _buildEquipmentSection(controller, isDark),
                          ),
                          ExpandableSection(
                            sectionId: 'servicebog',
                            title: 'Service book',
                            subtitle: 'Service history',
                            sectionNumber: 4,
                            isExpanded: controller.sectionExpanded['servicebog'] ?? true,
                            onToggle: () => controller.toggleSection('servicebog'),
                            child: Obx(() {
                              return Wrap(
                                spacing: 8,
                                runSpacing: 8,
                                children: ['Yes', 'No', 'Default'].map((v) {
                                  final selected = controller.servicebog.value == v;
                                  return ChoiceChip(
                                    label: Text(v),
                                    selected: selected,
                                    onSelected: (_) => controller.servicebog.value = v,
                                    selectedColor: AppColors.primary.withOpacity(0.3),
                                    labelStyle: TextStyle(
                                      color: selected
                                          ? AppColors.primary
                                          : (isDark ? AppColors.textDark : AppColors.textLight),
                                    ),
                                  );
                                }).toList(),
                              );
                            }),
                          ),
                          ExpandableSection(
                            sectionId: 'pricing',
                            title: 'Pricing',
                            subtitle: 'Price',
                            sectionNumber: 5,
                            isExpanded: controller.sectionExpanded['pricing'] ?? true,
                            onToggle: () => controller.toggleSection('pricing'),
                            child: TextFormField(
                              controller: controller.priceController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Price (kr.) *',
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) return 'Required';
                                final n = int.tryParse(v.trim());
                                if (n == null || n < 0) return 'Enter a valid price';
                                return null;
                              },
                            ),
                          ),
                          ExpandableSection(
                            sectionId: 'description',
                            title: 'Description',
                            subtitle: 'Vehicle description',
                            sectionNumber: 6,
                            isExpanded: controller.sectionExpanded['description'] ?? true,
                            onToggle: () => controller.toggleSection('description'),
                            child: TextFormField(
                              controller: controller.descriptionController,
                              maxLines: 4,
                              decoration: InputDecoration(
                                labelText: 'Description',
                                alignLabelWithHint: true,
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                filled: true,
                                fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                              ),
                            ),
                          ),
                          ExpandableSection(
                            sectionId: 'seller-info',
                            title: 'Seller Information',
                            subtitle: 'Contact and address',
                            sectionNumber: 7,
                            isExpanded: controller.sectionExpanded['seller-info'] ?? true,
                            onToggle: () => controller.toggleSection('seller-info'),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextFormField(
                                  controller: controller.sellerPhoneController,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    labelText: 'Phone',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: controller.sellerAddressController,
                                  decoration: InputDecoration(
                                    labelText: 'Address',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                TextFormField(
                                  controller: controller.sellerPostcodeController,
                                  decoration: InputDecoration(
                                    labelText: 'Postcode',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: controller.isSubmitting.value ? null : () => controller.save(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.primaryForeground,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                              ),
                              child: controller.isSubmitting.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                    )
                                  : const Text('Save changes'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      );
    });
  }

  Widget _buildEquipmentSection(EditVehicleController controller, bool isDark) {
    return Obx(() {
      if (controller.equipmentTypes.isEmpty && controller.equipment.isEmpty) {
        return Text(
          'No equipment available',
          style: TextStyle(color: isDark ? AppColors.mutedDark : AppColors.mutedLight),
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...controller.equipmentTypes.map((type) {
            final list = controller.getEquipmentByType(type.id);
            if (list.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    type.name.toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: list.map((item) {
                      final isSelected = controller.selectedEquipmentIds.contains(item.id);
                      return InkWell(
                        onTap: () => controller.toggleEquipment(item.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : (isDark ? AppColors.borderDark : AppColors.borderLight),
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSelected ? Icons.check_circle : Icons.circle_outlined,
                                size: 16,
                                color: isSelected
                                    ? AppColors.primaryForeground
                                    : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                item.name,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: isSelected
                                      ? AppColors.primaryForeground
                                      : (isDark ? AppColors.textDark : AppColors.textLight),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }),
          if (controller.getEquipmentByType(null).isNotEmpty) ...[
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: controller.getEquipmentByType(null).map((item) {
                final isSelected = controller.selectedEquipmentIds.contains(item.id);
                return InkWell(
                  onTap: () => controller.toggleEquipment(item.id),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : (isDark ? AppColors.backgroundDark : AppColors.backgroundLight),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle : Icons.circle_outlined,
                          size: 16,
                          color: isSelected
                              ? AppColors.primaryForeground
                              : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected
                                ? AppColors.primaryForeground
                                : (isDark ? AppColors.textDark : AppColors.textLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      );
    });
  }

  static const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
  String _monthName(int month) => month >= 1 && month <= 12 ? _months[month - 1] : '$month';
}
