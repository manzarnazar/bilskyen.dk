import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../controllers/app_controller/app_controller.dart';
import '../../../controllers/sell_vehicle_controller.dart';
import '../../../models/sell_vehicle_model/vehicle_lookup_response_model.dart';

class EquipmentSelection extends StatelessWidget {
  const EquipmentSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SellVehicleController());
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final equipmentTypes = controller.equipmentTypes;
      final selectedIds = controller.selectedEquipmentIds;

      if (equipmentTypes.isEmpty && controller.equipment.isEmpty) {
        return Text(
          'No equipment available',
          style: TextStyle(
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        );
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Equipment by type
          ...equipmentTypes.map((type) {
            final equipmentList = controller.getEquipmentByType(type.id);
            if (equipmentList.isEmpty) return const SizedBox.shrink();

            return _EquipmentTypeGroup(
              type: type,
              equipment: equipmentList,
              selectedIds: selectedIds,
              onToggle: controller.toggleEquipment,
            );
          }),
          // Equipment without type
          if (controller.getEquipmentByType(null).isNotEmpty)
            _EquipmentTypeGroup(
              type: null,
              equipment: controller.getEquipmentByType(null),
              selectedIds: selectedIds,
              onToggle: controller.toggleEquipment,
            ),
          const SizedBox(height: 16),
          // Servicebog Radio Buttons
          Text(
            'Servicebog',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _ServicebogRadio(
                value: 'Yes',
                selectedValue: controller.servicebog.value,
                onChanged: (value) => controller.servicebog.value = value,
              ),
              const SizedBox(width: 12),
              _ServicebogRadio(
                value: 'No',
                selectedValue: controller.servicebog.value,
                onChanged: (value) => controller.servicebog.value = value,
              ),
              const SizedBox(width: 12),
              _ServicebogRadio(
                value: 'Default',
                selectedValue: controller.servicebog.value,
                onChanged: (value) => controller.servicebog.value = value,
              ),
            ],
          ),
        ],
      );
    });
  }
}

class _EquipmentTypeGroup extends StatelessWidget {
  final EquipmentTypeModel? type;
  final List<EquipmentModel> equipment;
  final RxList<int> selectedIds;
  final Function(int) onToggle;

  const _EquipmentTypeGroup({
    required this.type,
    required this.equipment,
    required this.selectedIds,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    // Controller should be initialized by parent view
    final controller = Get.isRegistered<SellVehicleController>()
        ? Get.find<SellVehicleController>()
        : Get.put(SellVehicleController());

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final typeKey = type != null ? 'equipment_type_${type!.id}' : 'equipment_type_none';
      final isTypeExpanded = controller.sectionExpanded[typeKey] ?? true;

      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (type != null)
              InkWell(
                onTap: () {
                  controller.sectionExpanded[typeKey] = !isTypeExpanded;
                },
                child: Row(
                  children: [
                    Text(
                      type!.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: isTypeExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            if (type == null || isTypeExpanded) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: equipment.map((item) {
                  final isSelected = selectedIds.contains(item.id);
                  return InkWell(
                    onTap: () => onToggle(item.id),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.backgroundDark
                                : AppColors.backgroundLight),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : (isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight),
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
                                : (isDark
                                    ? AppColors.mutedDark
                                    : AppColors.mutedLight),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 12,
                              color: isSelected
                                  ? AppColors.primaryForeground
                                  : (isDark
                                      ? AppColors.textDark
                                      : AppColors.textLight),
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
        ),
      );
    });
  }
}

class _ServicebogRadio extends StatelessWidget {
  final String value;
  final String selectedValue;
  final Function(String) onChanged;

  const _ServicebogRadio({
    required this.value,
    required this.selectedValue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final isSelected = selectedValue == value;

      return InkWell(
        onTap: () => onChanged(value),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
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
                isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                size: 16,
                color: isSelected
                    ? AppColors.primaryForeground
                    : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  color: isSelected
                      ? AppColors.primaryForeground
                      : (isDark ? AppColors.textDark : AppColors.textLight),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
