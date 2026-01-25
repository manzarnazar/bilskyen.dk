import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/app_colors.dart';
import '../../models/vehicle_model/vehicle_model.dart';
import '../widgets/cached_image.dart';


class FeaturedVehicleCard extends StatelessWidget {
  final VehicleModel vehicle;

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
      return '$priceString €';
    }

    final reversed = priceString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversed[i]);
    }

    return '${buffer.toString().split('').reversed.join()} €';
  }

  @override
  Widget build(BuildContext context) {
      return GestureDetector(
        onTap: () {
          Get.toNamed('/vehicle-detail/${vehicle.id}');
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
                  child: _buildVehicleImage(),
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
                // Price at Top Left
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _formatPrice(vehicle.price),
                      style: TextStyle(
                        color: AppColors.primaryForeground,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
                // Heart Icon at Top Right
                Positioned(
                  top: 16,
                  right: 16,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: Colors.white,
                        size: 18,
                      ),
                      onPressed: () {
                        // Handle favorite action
                      },
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                    ),
                  ),
                ),
                // Bottom Content
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Tags Row (km, HP, Year, Gear Type, Fuel Type)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            if (vehicle.kmDriven != null)
                              _buildTag(
                                icon: Icons.speed,
                                text: '${_formatMileage(vehicle.kmDriven)} km',
                              ),
                            if (vehicle.enginePowerHp != null && vehicle.enginePowerHp! > 0)
                              _buildTag(
                                icon: Icons.bolt,
                                text: '${vehicle.enginePowerHp!.toStringAsFixed(0)} HP',
                              ),
                            if (_getYearFromRegistrationDate().isNotEmpty)
                              _buildTag(
                                icon: Icons.calendar_today,
                                text: _getYearFromRegistrationDate(),
                              ),
                            if (vehicle.gearTypeName != null && vehicle.gearTypeName!.isNotEmpty)
                              _buildTag(
                                icon: Icons.settings,
                                text: vehicle.gearTypeName!,
                              ),
                            if (vehicle.fuelTypeName != null && vehicle.fuelTypeName!.isNotEmpty)
                              _buildTag(
                                icon: Icons.local_gas_station,
                                text: vehicle.fuelTypeName!,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        // Vehicle Title
                        Text(
                          _getFullTitle(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }

  Widget _buildTag({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 14,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  String _getFullTitle() {
    final title = vehicle.title;
    final version = vehicle.version;
    if (version != null && version.isNotEmpty) {
      return '$title $version';
    }
    return title;
  }

  String _getYearFromRegistrationDate() {
    final registrationDate = vehicle.firstRegistrationDate;
    if (registrationDate.isEmpty) {
      return '';
    }
    
    // Extract year from date string (format: '1999-01-08')
    try {
      if (registrationDate.contains('-')) {
        return registrationDate.split('-')[0];
      }
      return registrationDate;
    } catch (e) {
      return '';
    }
  }

  Widget _buildVehicleImage() {
    final imageUrl = vehicle.imageUrl;

    if (imageUrl.isEmpty) {
      return Container(
        color: AppColors.carPlaceholderBg,
        child: const Center(
          child: Icon(Icons.directions_car, size: 80, color: AppColors.gray400),
        ),
      );
    }

    return CustomCachedImage(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }
}


