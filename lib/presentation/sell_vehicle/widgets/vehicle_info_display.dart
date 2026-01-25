import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import '../../../controllers/app_controller/app_controller.dart';
import '../../../controllers/sell_vehicle_controller.dart';

class VehicleInfoDisplay extends StatelessWidget {
  const VehicleInfoDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    // Controller should be initialized by parent view
    final controller = Get.isRegistered<SellVehicleController>()
        ? Get.find<SellVehicleController>()
        : Get.put(SellVehicleController());
    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;
      final vehicleData = controller.vehicleData;

      if (vehicleData == null) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
          border: Border.all(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildInfoItem(
              icon: Icons.check_circle,
              label: 'Brand',
              value: vehicleData.brand?.name ?? '—',
              isDark: isDark,
            ),
            _buildInfoItem(
              icon: Icons.description,
              label: 'Model',
              value: vehicleData.model?.name ?? '—',
              isDark: isDark,
            ),
            _buildInfoItem(
              icon: Icons.calendar_today,
              label: 'Year',
              value: vehicleData.modelYear?.name ?? '—',
              isDark: isDark,
            ),
            _buildInfoItem(
              icon: Icons.local_gas_station,
              label: 'Fuel Type',
              value: vehicleData.fuelType?.name ?? '—',
              isDark: isDark,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildInfoItem({
    required IconData icon,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label.toUpperCase(),
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
