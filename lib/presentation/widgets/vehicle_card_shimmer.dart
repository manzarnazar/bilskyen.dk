import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../utils/app_colors.dart';

class VehicleCardShimmer extends StatelessWidget {
  final bool isDark;
  final bool isHorizontalLayout;

  const VehicleCardShimmer({
    super.key,
    required this.isDark,
    this.isHorizontalLayout = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isHorizontalLayout) {
      return _buildHorizontalLayout();
    }
    return _buildVerticalLayout();
  }

  Widget _buildHorizontalLayout() {
    final baseColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final highlightColor = isDark 
        ? AppColors.surfaceDark
        : AppColors.mutedBackground;
    final shimmerColor = isDark ? AppColors.surfaceDark : AppColors.gray300;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section: Image on left, Details on right
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image section (40% width)
                Expanded(
                  flex: 4,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      color: shimmerColor,
                    ),
                  ),
                ),
                // Details section (60% width)
                Expanded(
                  flex: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title (single line)
                        Container(
                          height: 16,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Price
                        Container(
                          height: 22,
                          width: 100,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 6),
                        // Tags (single row)
                        Row(
                          children: List.generate(3, (index) {
                            return Padding(
                              padding: EdgeInsets.only(right: index < 2 ? 4 : 0),
                              child: Container(
                                height: 20,
                                width: index == 0 ? 50 : (index == 1 ? 45 : 55),
                                decoration: BoxDecoration(
                                  color: shimmerColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        // Buttons
                        Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: shimmerColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Container(
                                height: 32,
                                decoration: BoxDecoration(
                                  color: shimmerColor,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Bottom section: Location and Dealer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Location
                  Row(
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        height: 12,
                        width: 80,
                        decoration: BoxDecoration(
                          color: shimmerColor,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  // Dealer/Seller
                  Container(
                    height: 12,
                    width: 60,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalLayout() {
    final baseColor = isDark ? AppColors.cardDark : AppColors.cardLight;
    final highlightColor = isDark 
        ? AppColors.surfaceDark
        : AppColors.mutedBackground;
    final shimmerColor = isDark ? AppColors.surfaceDark : AppColors.gray300;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: baseColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
          width: 1,
        ),
      ),
      child: Shimmer.fromColors(
        baseColor: shimmerColor,
        highlightColor: highlightColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image section with heart icon
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    color: shimmerColor,
                  ),
                ),
                // Heart icon placeholder (top-right)
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (single line)
                  Container(
                    height: 20,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Price
                  Container(
                    height: 28,
                    width: 150,
                    decoration: BoxDecoration(
                      color: shimmerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Tags (single row)
                  Row(
                    children: List.generate(4, (index) {
                      return Padding(
                        padding: EdgeInsets.only(right: index < 3 ? 8 : 0),
                        child: Container(
                          height: 24,
                          width: index == 0 ? 60 : (index == 1 ? 50 : (index == 2 ? 55 : 50)),
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 16),
                  // Buttons
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 48,
                          decoration: BoxDecoration(
                            color: shimmerColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
