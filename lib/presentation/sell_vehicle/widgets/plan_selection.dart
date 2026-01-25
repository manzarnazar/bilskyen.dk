import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../controllers/app_controller/app_controller.dart';
import '../../../controllers/sell_vehicle_controller.dart';
import '../../../models/sell_vehicle_model/plan_model.dart';

class PlanSelection extends StatelessWidget {
  const PlanSelection({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller should be initialized by parent view
    final controller = Get.isRegistered<SellVehicleController>()
        ? Get.find<SellVehicleController>()
        : Get.put(SellVehicleController());
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final plans = controller.plans;
      final selectedPlanId = controller.selectedPlanId.value;

      if (plans.isEmpty) {
        return Text(
          'No plans available',
          style: TextStyle(
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        );
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemCount: plans.length,
        itemBuilder: (context, index) {
          final plan = plans[index];
          final isSelected = selectedPlanId == plan.id;

          return InkWell(
            onTap: () => controller.selectedPlanId.value = plan.id,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : (isDark ? AppColors.cardDark : AppColors.cardLight),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primary
                      : (isDark ? AppColors.borderDark : AppColors.borderLight),
                  width: isSelected ? 2 : 1,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          plan.name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryForeground
                                : (isDark
                                    ? AppColors.textDark
                                    : AppColors.textLight),
                          ),
                        ),
                      ),
                      Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_unchecked,
                        color: isSelected
                            ? AppColors.primaryForeground
                            : (isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight),
                      ),
                    ],
                  ),
                  if (plan.description != null && plan.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      plan.description!,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected
                            ? AppColors.primaryForeground.withOpacity(0.9)
                            : (isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight),
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  if (plan.planFeatures != null &&
                      plan.planFeatures!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Features:',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryForeground.withOpacity(0.8)
                            : (isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight),
                      ),
                    ),
                    const SizedBox(height: 4),
                    ...plan.planFeatures!.take(3).map((feature) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          '• ${feature.feature.description ?? feature.feature.key}: ${feature.value}',
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected
                                ? AppColors.primaryForeground.withOpacity(0.8)
                                : (isDark
                                    ? AppColors.mutedDark
                                    : AppColors.mutedLight),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          );
        },
      );
    });
  }
}
