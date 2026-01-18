import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../utils/app_colors.dart';


class FeaturedVehicleCard extends StatelessWidget {
  final Map<String, dynamic> vehicle;

  const FeaturedVehicleCard({super.key, required this.vehicle});

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

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          // Get.to(() => CarDetailsView(vehicleId: vehicle.id));
        },
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          height: 320,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Stack(
              children: [
                // Car Image
                Positioned.fill(
                  child: _buildVehicleImage(vehicle),
                ),
                // Gradient Overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                        stops: const [0.4, 1.0],
                      ),
                    ),
                  ),
                ),
                // TOP DEAL Badge
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'TOP DEAL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Navigation Arrow Button
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        // Get.to(() => CarDetailsView(vehicleId: vehicle.id));
                      },
                    ),
                  ),
                ),
                // Car Details at Bottom
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Brand Name
                        Text(
                          vehicle['brandName'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        // Model Name
                        Text(
                          vehicle['title'] ?? '',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Year and Mileage
                        Text(
                          '${vehicle['modelYearName'] ?? ''} • ${_formatMileage(vehicle['mileage'])} km',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Price at Bottom Right
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Text(
                    _formatPrice(vehicle['price'] ?? 0),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildVehicleImage(Map<String, dynamic> vehicle) {
    final imageUrl = vehicle['imageUrl'];

    if (imageUrl == null || imageUrl.toString().isEmpty) {
      return Container(
        color: AppColors.carPlaceholderBg,
        child: const Center(
          child: Icon(Icons.directions_car, size: 80, color: AppColors.gray400),
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: imageUrl.toString(),
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(
        color: AppColors.carPlaceholderBg,
        child: const Center(child: CircularProgressIndicator()),
      ),
      errorWidget: (context, url, error) => Container(
        color: AppColors.carPlaceholderBg,
        child: const Icon(
          Icons.directions_car,
          size: 80,
          color: AppColors.gray400,
        ),
      ),
    );
  }
}

