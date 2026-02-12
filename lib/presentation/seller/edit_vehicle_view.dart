import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            'Edit Vehicle',
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
                            subtitle: 'Title, variant, and color',
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
                                Obx(() => DropdownButtonFormField<int>(
                                      value: controller.variantId.value,
                                      decoration: InputDecoration(
                                        labelText: 'Variant',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        filled: true,
                                        fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                      ),
                                      items: controller.variants
                                          .map((v) => DropdownMenuItem<int>(value: v.id, child: Text(v.name)))
                                          .toList(),
                                      onChanged: (v) => controller.variantId.value = v,
                                    )),
                                const SizedBox(height: 16),
                                Obx(() => DropdownButtonFormField<int>(
                                      value: controller.colorId.value,
                                      decoration: InputDecoration(
                                        labelText: 'Color',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        filled: true,
                                        fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                      ),
                                      items: controller.colors
                                          .map((c) => DropdownMenuItem<int>(value: c.id, child: Text(c.name)))
                                          .toList(),
                                      onChanged: (v) => controller.colorId.value = v,
                                    )),
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
                                      child: Obx(() => DropdownButtonFormField<int>(
                                            value: controller.firstRegistrationMonth.value,
                                            decoration: InputDecoration(
                                              labelText: 'First reg. month',
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                              filled: true,
                                              fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                            ),
                                            items: List.generate(12, (i) => i + 1)
                                                .map((m) => DropdownMenuItem<int>(
                                                      value: m,
                                                      child: Text(_monthName(m)),
                                                    ))
                                                .toList(),
                                            onChanged: (v) => controller.firstRegistrationMonth.value = v,
                                          )),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Obx(() => DropdownButtonFormField<int>(
                                            value: controller.firstRegistrationYear.value,
                                            decoration: InputDecoration(
                                              labelText: 'First reg. year',
                                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                              filled: true,
                                              fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                            ),
                                            items: List.generate(30, (i) => DateTime.now().year - 29 + i)
                                                .reversed
                                                .map((y) => DropdownMenuItem<int>(value: y, child: Text('$y')))
                                                .toList(),
                                            onChanged: (v) => controller.firstRegistrationYear.value = v,
                                          )),
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
                                    labelText: 'Fuel efficiency',
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                    filled: true,
                                    fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Obx(() => DropdownButtonFormField<int>(
                                      value: controller.euronomId.value,
                                      decoration: InputDecoration(
                                        labelText: 'Euronom',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                        filled: true,
                                        fillColor: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
                                      ),
                                      items: [
                                        const DropdownMenuItem<int>(value: null, child: Text('—')),
                                        ...controller.euronorms
                                            .map((e) => DropdownMenuItem<int>(value: e.id, child: Text(e.name))),
                                      ],
                                      onChanged: (v) => controller.euronomId.value = v,
                                    )),
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
                            sectionId: 'pricing',
                            title: 'Pricing',
                            subtitle: 'Price',
                            sectionNumber: 4,
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
                            sectionNumber: 5,
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
                            sectionNumber: 6,
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
