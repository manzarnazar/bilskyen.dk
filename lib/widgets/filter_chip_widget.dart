import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget? trailing;
  final double? height;
  final double? fontSize;
  final EdgeInsets? padding;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.trailing,
    this.height,
    this.fontSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      
      return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 48, // Match search bar height (12 vertical padding * 2 + text height)
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryLight
              : (isDark ? AppColors.cardDark : AppColors.cardLight),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryLight
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
          borderRadius: BorderRadius.circular(12), // Match search bar border radius
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label == 'Filters')
              const Icon(
                Icons.filter_list,
                size: 16,
                color: Colors.black,
              ),
            if (label == 'Filters') const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: fontSize ?? 12,
                fontWeight: FontWeight.w500,
                color: isSelected
                    ? Colors.black
                    : (isDark ? AppColors.textDark : AppColors.textLight),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: 4),
              trailing!,
            ] else if (label != 'Filters')
              Icon(
                Icons.keyboard_arrow_down,
                size: 16,
                color: isSelected
                    ? Colors.black
                    : (isDark ? AppColors.textDark : AppColors.textLight),
              ),
          ],
        ),
      ),
    );
    });
  }
}

