import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/vehicle_model.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../views/car_details_view.dart';

class RecommendedCarsList extends StatelessWidget {
  final RxList<VehicleModel> vehicles;

  const RecommendedCarsList({super.key, required this.vehicles});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final vehiclesList = vehicles;

      if (vehiclesList.isEmpty) {
        return SizedBox(
          height: 200,
          child: Center(
            child: Text(
              'No recommended cars available',
              style: TextStyle(
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
            ),
          ),
        );
      }

      return SizedBox(
        height: 240,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: vehiclesList.length,
          itemBuilder: (context, index) {
            final vehicle = vehiclesList[index];
            return _RecommendedCarCard(
              vehicle: vehicle,
              onTap: () {
                Get.to(() => CarDetailsView(vehicleId: vehicle.id));
              },
            );
          },
        ),
      );
    });
  }
}

class _RecommendedCarCard extends StatelessWidget {
  final VehicleModel vehicle;
  final VoidCallback onTap;

  const _RecommendedCarCard({
    required this.vehicle,
    required this.onTap,
  });

  String _formatPrice(int price) {
    final priceString = price.toString();
    if (priceString.length <= 3) {
      return '\$$priceString';
    }

    final reversed = priceString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(reversed[i]);
    }

    return '\$${buffer.toString().split('').reversed.join()}';
  }

  String _formatMileage(int? mileage) {
    if (mileage == null) return 'N/A';
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
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;

      return GestureDetector(
        onTap: onTap,
        child: Container(
          width: 200,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.cardDark : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Car Image
              ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: isDark
                      ? AppColors.carPlaceholderBg
                      : AppColors.gray200,
                  child: _buildVehicleImage(vehicle),
                ),
              ),
              // Car Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vehicle.brandName,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      vehicle.title,
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.mutedDark
                            : AppColors.mutedLight,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${vehicle.modelYearName} • ${_formatMileage(vehicle.mileage)} km',
                            style: TextStyle(
                              fontSize: 10,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _formatPrice(vehicle.price),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildVehicleImage(VehicleModel vehicle) {
    final hasValidImage =
        vehicle.imageUrl != null &&
        vehicle.images != null &&
        vehicle.images!.isNotEmpty &&
        vehicle.images!.first.hasValidUrl;

    if (!hasValidImage) {
      return const Center(
        child: Icon(Icons.directions_car, size: 48, color: AppColors.gray400),
      );
    }

    return CachedNetworkImage(
      imageUrl: vehicle.imageUrl!,
      fit: BoxFit.cover,
      placeholder: (context, url) => const Center(
        child: CircularProgressIndicator(),
      ),
      errorWidget: (context, url, error) => const Icon(
        Icons.directions_car,
        size: 48,
        color: AppColors.gray400,
      ),
    );
  }
}

