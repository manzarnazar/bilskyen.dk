import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import 'contact_seller_bottom_sheet.dart';

class CarCard extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const CarCard({super.key, required this.vehicle});

  String _formatMileage(int? mileage) {
    if (mileage == null) return 'N/A';
    // Danish format: dots as thousand separators
    final mileageString = mileage.toString();
    if (mileageString.length <= 3) {
      return mileageString;
    }

    final reversed = mileageString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversed[i]);
    }

    return buffer.toString().split('').reversed.join();
  }

  @override
  Widget build(BuildContext context) {

    final appController = Get.find<AppController>();

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Card(
        margin: const EdgeInsets.only(bottom: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image Section
            Stack(
              children: [
                Container(
                  height: 220,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.carPlaceholderBg
                        : AppColors.gray200,
                  ),
                  child: _buildVehicleImage(vehicle),
                ),
                // Registration Number Badge (Top Right)
                if (vehicle['registration'] != null && vehicle['registration'].toString().isNotEmpty)
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        vehicle['registration'].toString(),
                        style: TextStyle(
                          color: isDark ? AppColors.textDark : Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                // Favorite Icon (Top Left)
                Positioned(
                  top: 12,
                  left: 12,
                  child: GestureDetector(
                    onTap: (){},
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Car Details Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Price Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          vehicle['title'] ?? '',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            height: 1.2,
                            color: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                          ),
                        ),
                      ),
                      Text(
                        _formatPrice(vehicle['price'] ?? 0),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                  // Sub-details (Brand/Category) and Tags
                  Builder(
                    builder: (context) {
                      final brandName = vehicle['brandName']?.toString() ?? '';
                      final categoryName = vehicle['categoryName']?.toString() ?? '';
                      final colorName = vehicle['colorName']?.toString();
                      
                      final subDetail = brandName != 'Unknown' && brandName.isNotEmpty
                          ? brandName 
                          : categoryName != 'Unknown' && categoryName.isNotEmpty
                              ? categoryName 
                              : '';
                      
                      final hasTags = (colorName != null &&
                              colorName != 'Unknown' &&
                              colorName.isNotEmpty) ||
                          (categoryName != 'Unknown' &&
                              categoryName.isNotEmpty);
                      
                      if (subDetail.isEmpty && !hasTags) {
                        return const SizedBox.shrink();
                      }
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (subDetail.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              subDetail,
                              style: TextStyle(
                                fontSize: 13,
                                color: isDark
                                    ? AppColors.mutedDark
                                    : AppColors.mutedLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                          if (hasTags) ...[
                            SizedBox(height: subDetail.isNotEmpty ? 12 : 6),
                            // Tags (Color and Category)
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                if (colorName != null &&
                                    colorName != 'Unknown' &&
                                    colorName.isNotEmpty)
                                  _TagChip(
                                    label: colorName,
                                    isDark: isDark,
                                  ),
                                if (categoryName != 'Unknown' &&
                                    categoryName.isNotEmpty)
                                  _TagChip(
                                    label: categoryName,
                                    isDark: isDark,
                                  ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                  // Specifications Row (Year, Mileage, Fuel, Location)
                  Builder(
                    builder: (context) {
                      final specItems = <Widget>[];
                      
                      // Year
                      final modelYearName = vehicle['modelYearName']?.toString() ?? '';
                      if (modelYearName != 'Unknown' && modelYearName.isNotEmpty) {
                        specItems.add(
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.calendar_today,
                              text: modelYearName,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }
                      
                      // Mileage
                      if (vehicle['mileage'] != null) {
                        specItems.add(
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.speed,
                              text: '${_formatMileage(vehicle['mileage'])} km',
                              isDark: isDark,
                            ),
                          ),
                        );
                      }
                      
                      // Fuel Type
                      final fuelTypeName = vehicle['fuelTypeName']?.toString() ?? '';
                      if (fuelTypeName != 'Unknown' && fuelTypeName.isNotEmpty) {
                        specItems.add(
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.local_gas_station,
                              text: fuelTypeName,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }
                      
                      // Location
                      final location = vehicle['location'];
                      final city = location is Map ? location['city']?.toString() : null;
                      if (city != null && city.isNotEmpty) {
                        specItems.add(
                          Expanded(
                            child: _SpecItem(
                              icon: Icons.location_on,
                              text: city,
                              isDark: isDark,
                            ),
                          ),
                        );
                      }
                      
                      // Only show if we have at least one spec item
                      if (specItems.isEmpty) {
                        return const SizedBox.shrink();
                      }
                      
                      return Row(children: specItems);
                    },
                  ),
                  const SizedBox(height: 16),
                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            // Get.to(() => CarDetailsView(vehicleId: vehicle.id));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark
                                ? Colors.white
                                : Colors.black,
                            foregroundColor: isDark
                                ? Colors.black
                                : Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'View Details',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              isDismissible: true,
                              enableDrag: true,
                              barrierColor: Colors.black.withOpacity(0.8),
                              builder: (context) =>
                                  ContactSellerBottomSheet(vehicle: vehicle),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: isDark
                                ? AppColors.textDark
                                : AppColors.textLight,
                            side: BorderSide(
                              color: isDark
                                  ? AppColors.borderDark
                                  : AppColors.borderLight,
                              width: 1.5,
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Contact',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
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
      );
    });
  }

  Widget _buildVehicleImage(Map<String, dynamic> vehicle) {
    // Check if we have a valid image URL
    final imageUrl = vehicle['imageUrl']?.toString();

    if (imageUrl == null || imageUrl.isEmpty) {
      return const Center(
        child: Icon(Icons.directions_car, size: 64, color: AppColors.gray400),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          const Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => const Icon(
        Icons.directions_car,
        size: 64,
        color: AppColors.gray400,
      ),
    );
  }
  
  String _formatPrice(int price) {
    final priceString = price.toString();
    if (priceString.length <= 3) {
      return 'kr $priceString';
    }

    final reversed = priceString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversed[i]);
    }

    return 'kr ${buffer.toString().split('').reversed.join()}';
  }
}

class _SpecItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isDark;

  const _SpecItem({
    required this.icon,
    required this.text,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 14,
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
        ),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.textDark : AppColors.textLight,
              fontWeight: FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}

class _TagChip extends StatelessWidget {
  final String label;
  final bool isDark;

  const _TagChip({required this.label, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray200,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray300,
          width: 1,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.textDark : AppColors.textLight,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
