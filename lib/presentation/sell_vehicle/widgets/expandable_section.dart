import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../controllers/app_controller/app_controller.dart';

class ExpandableSection extends StatelessWidget {
  final String sectionId;
  final String title;
  final String subtitle;
  final int sectionNumber;
  final Widget child;
  final bool isExpanded;
  final VoidCallback onToggle;

  const ExpandableSection({
    super.key,
    required this.sectionId,
    required this.title,
    required this.subtitle,
    required this.sectionNumber,
    required this.child,
    required this.isExpanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final isDark = appController.isDarkMode.value;

    return Obx(() {
      final isDarkMode = appController.isDarkMode.value;
      return Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.cardDark : AppColors.cardLight,
          border: Border.all(
            color: isDarkMode ? AppColors.borderDark : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            // Section Header
            InkWell(
              onTap: onToggle,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.surfaceDark
                      : AppColors.mutedBackground,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: isExpanded ? Radius.zero : Radius.circular(8),
                    bottomRight: isExpanded ? Radius.zero : Radius.circular(8),
                  ),
                ),
                child: Row(
                  children: [
                    // Section Number
                    Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDarkMode
                            ? AppColors.backgroundDark
                            : AppColors.backgroundLight,
                      ),
                      child: Center(
                        child: Text(
                          '$sectionNumber',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: isDarkMode
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Title and Subtitle
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: isDarkMode
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 10,
                              color: isDarkMode
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Expand/Collapse Icon
                    AnimatedRotation(
                      turns: isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: Icon(
                        Icons.keyboard_arrow_down,
                        size: 16,
                        color: isDarkMode
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Section Content
            AnimatedCrossFade(
              firstChild: Container(
                padding: const EdgeInsets.all(16),
                child: child,
              ),
              secondChild: const SizedBox.shrink(),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 300),
            ),
          ],
        ),
      );
    });
  }
}
