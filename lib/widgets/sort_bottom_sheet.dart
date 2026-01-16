import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';

class SortBottomSheet extends StatefulWidget {
  const SortBottomSheet({super.key});

  @override
  State<SortBottomSheet> createState() => _SortBottomSheetState();
}

class _SortBottomSheetState extends State<SortBottomSheet> {
  late DraggableScrollableController _draggableController;

  @override
  void initState() {
    super.initState();
    _draggableController = DraggableScrollableController();
    _draggableController.addListener(() {
      if (_draggableController.size <= 0.15) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _draggableController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final selectedSort = controller.selectedSort.value;

      return DraggableScrollableSheet(
        controller: _draggableController,
        initialChildSize: 0.6,
        minChildSize: 0.3,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Column(
              children: [
                // Drag Handle
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.gray600 : AppColors.gray400,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                // Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sort_rounded,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                        size: 24,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Standard',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                // Scrollable Content
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSortOption(
                          label: 'Standard',
                          subtitle: '(Default sorting)',
                          sortValue: 'standard',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('standard');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Price:',
                          subtitle: '(lowest first)',
                          sortValue: 'price_asc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('price_asc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Price:',
                          subtitle: '(Highest first)',
                          sortValue: 'price_desc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('price_desc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Date:',
                          subtitle: '(Newest first)',
                          sortValue: 'date_desc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('date_desc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Date:',
                          subtitle: '(Oldest first)',
                          sortValue: 'date_asc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('date_asc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Model Year:',
                          subtitle: '(Newest first)',
                          sortValue: 'year_desc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('year_desc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Model Year:',
                          subtitle: '(Oldest First)',
                          sortValue: 'year_asc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('year_asc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Mileage:',
                          subtitle: '(Highest first)',
                          sortValue: 'mileage_desc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('mileage_desc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Mileage:',
                          subtitle: '(Lowest first)',
                          sortValue: 'mileage_asc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('mileage_asc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Km/l:',
                          subtitle: '(Highest first)',
                          sortValue: 'fuel_efficiency_desc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('fuel_efficiency_desc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Km/l:',
                          subtitle: '(Lowest first)',
                          sortValue: 'fuel_efficiency_asc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('fuel_efficiency_asc');
                            Navigator.of(context).pop();
                          },
                        ),
                        const SizedBox(height: 12),
                        _buildSortOption(
                          label: 'Range:',
                          subtitle: '(Highest first)',
                          sortValue: 'range_desc',
                          selectedSort: selectedSort,
                          isDark: isDark,
                          onTap: () {
                            controller.setSort('range_desc');
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }

  Widget _buildSortOption({
    required String label,
    required String subtitle,
    required String sortValue,
    required String selectedSort,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    final isSelected = selectedSort == sortValue;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? Colors.white : Colors.black)
              : (isDark ? AppColors.gray900 : AppColors.gray200),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected
                          ? (isDark ? Colors.black : Colors.white)
                          : (isDark ? AppColors.textDark : AppColors.textLight),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: isSelected
                          ? (isDark ? Colors.black87 : Colors.white70)
                          : (isDark ? AppColors.mutedDark : AppColors.mutedLight),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle_rounded,
                color: isDark ? Colors.black : Colors.white,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }
}

