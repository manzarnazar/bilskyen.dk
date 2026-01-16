import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/vehicle_model.dart';
import '../models/vehicle_image_model.dart';
import '../utils/app_colors.dart';
import '../viewmodels/vehicle_controller.dart';
import '../widgets/contact_seller_bottom_sheet.dart';

class CarDetailsView extends StatefulWidget {
  final VehicleModel? vehicle;
  final int? vehicleId;

  const CarDetailsView({
    super.key,
    this.vehicle,
    this.vehicleId,
  }) : assert(vehicle != null || vehicleId != null, 'Either vehicle or vehicleId must be provided');

  @override
  State<CarDetailsView> createState() => _CarDetailsViewState();
}

class _CarDetailsViewState extends State<CarDetailsView> {
  @override
  void initState() {
    super.initState();
    // If vehicleId is provided but vehicle is not, fetch the vehicle
    if (widget.vehicleId != null && widget.vehicle == null) {
      final controller = Get.find<VehicleController>();
      controller.loadVehicleById(widget.vehicleId!);
    }
  }

  VehicleModel? get vehicle {
    // If vehicle is provided directly, use it
    if (widget.vehicle != null) {
      return widget.vehicle;
    }
    // Otherwise, use the current vehicle from controller
    final controller = Get.find<VehicleController>();
    return controller.currentVehicle.value;
  }

  String _formatNumber(int? number) {
    if (number == null) return 'N/A';
    final numberString = number.toString();
    if (numberString.length <= 3) {
      return numberString;
    }
    
    // Danish format: dots as thousand separators
    final reversed = numberString.split('').reversed.toList();
    final buffer = StringBuffer();
    
    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversed[i]);
    }
    
    return buffer.toString().split('').reversed.join();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  String get _carColor => vehicle?.vehicleDetail?.colorName ?? 'Unknown';
  String get _bodyType => vehicle?.vehicleDetail?.bodyTypeName ?? 'Unknown';
  String get _status => vehicle?.vehicleListStatusName ?? 'Unknown';
  String get _vehicleOverview => vehicle?.vehicleDetail?.description ?? 
      'Well maintained ${vehicle?.fullName ?? 'vehicle'}. The vehicle is in excellent condition with a complete service history.';

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<VehicleController>();

    return Obx(() {
      final isDark = controller.isDarkMode.value;
      final isLoading = widget.vehicleId != null && widget.vehicle == null 
          ? controller.isLoadingVehicle.value 
          : false;
      final currentVehicle = this.vehicle;

      // Show loading state
      if (isLoading) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          body: SafeArea(
            child: Center(
              child: CircularProgressIndicator(
                color: isDark ? AppColors.textDark : AppColors.primaryDark,
              ),
            ),
          ),
        );
      }

      // Show error state if vehicle is null and we were trying to load it
      if (currentVehicle == null && widget.vehicleId != null) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          body: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Failed to load vehicle',
                    style: TextStyle(
                      fontSize: 18,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      controller.loadVehicleById(widget.vehicleId!);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      // Ensure we have a vehicle before rendering
      if (currentVehicle == null) {
        return Scaffold(
          backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
          body: SafeArea(
            child: Center(
              child: Text(
                'Vehicle not found',
                style: TextStyle(
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ),
          ),
        );
      }

      // Use currentVehicle for the rest of the build
      // At this point we know currentVehicle is not null due to the check above
      final vehicle = currentVehicle;

      return Scaffold(
        backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: (isDark ? AppColors.cardDark : Colors.white).withValues(alpha: 0.95),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Get.back(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const Text(
                      'Vehicle Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () => controller.toggleFavorite(vehicle.id),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Car Image Section
                      _buildCarImageSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Image Gallery (if multiple images)
                      if (vehicle.images != null && vehicle.images!.length > 1)
                        _buildImageGallerySection(vehicle, isDark),
                      if (vehicle.images != null && vehicle.images!.length > 1)
                        const SizedBox(height: 24),
                      // Car Title and Price
                      _buildCarTitleSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Tags (Fuel Type, Color, Body Type)
                      _buildTagsSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Basic Information
                      _buildBasicInfoSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Technical Specifications
                      _buildTechnicalSpecsSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Engine Details
                      _buildEngineDetailsSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Weight & Dimensions
                      _buildWeightDimensionsSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Safety Features
                      _buildSafetyFeaturesSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Registration & Inspection
                      _buildRegistrationInspectionSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Vehicle Overview
                      _buildVehicleOverviewSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Additional Details (if available)
                      if (vehicle.vehicleDetail?.extraEquipment != null || 
                          vehicle.vehicleDetail?.dispensations != null ||
                          vehicle.vehicleDetail?.permits != null)
                        _buildAdditionalDetailsSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Equipment Section
                      if (vehicle.equipment != null && vehicle.equipment!.isNotEmpty)
                        _buildEquipmentSection(vehicle, isDark),
                      const SizedBox(height: 24),
                      // Location Info
                      _buildLocationSection(context, vehicle, isDark),
                      const SizedBox(height: 24), // Space for bottom buttons
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        // Bottom Action Buttons
        bottomNavigationBar: _buildBottomButtons(context, vehicle, isDark),
      );
    });
  }

  Widget _buildCarImageSection(VehicleModel vehicle, bool isDark) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _buildVehicleImage(vehicle, isDark),
          ),
          // Registration Number Badge
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                vehicle.registration ?? 'N/A',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallerySection(VehicleModel vehicle, bool isDark) {
    if (vehicle.images == null || vehicle.images!.isEmpty) {
      return const SizedBox.shrink();
    }

    // Sort images by sortOrder
    final sortedImages = List<VehicleImageModel>.from(vehicle.images!)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.photo_library,
                size: 16,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
              const SizedBox(width: 8),
              Text(
                'IMAGE GALLERY (${sortedImages.length})',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 100,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: sortedImages.length,
              itemBuilder: (context, index) {
                final image = sortedImages[index];
                return Container(
                  width: 100,
                  margin: EdgeInsets.only(right: index < sortedImages.length - 1 ? 12 : 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: image.hasValidUrl
                        ? CachedNetworkImage(
                            imageUrl: image.thumbnailUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Center(
                              child: CircularProgressIndicator(
                                color: isDark ? AppColors.textDark : AppColors.primaryDark,
                                strokeWidth: 2,
                              ),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.broken_image,
                              size: 32,
                              color: isDark ? AppColors.gray400 : AppColors.gray600,
                            ),
                          )
                        : Icon(
                            Icons.image_not_supported,
                            size: 32,
                            color: isDark ? AppColors.gray400 : AppColors.gray600,
                          ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVehicleImage(VehicleModel vehicle, bool isDark) {
    // Check if we have a valid image URL
    final hasValidImage = vehicle.imageUrl != null && 
                          vehicle.images != null && 
                          vehicle.images!.isNotEmpty &&
                          vehicle.images!.first.hasValidUrl;

    if (!hasValidImage) {
      return Center(
        child: Icon(
          Icons.directions_car,
          size: 64,
          color: isDark ? AppColors.gray400 : AppColors.gray600,
        ),
      );
    }

    return CachedNetworkImage(
      imageUrl: vehicle.imageUrl!,
      fit: BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          color: isDark ? AppColors.textDark : AppColors.primaryDark,
        ),
      ),
      errorWidget: (context, url, error) => Icon(
        Icons.directions_car,
        size: 64,
        color: isDark ? AppColors.gray400 : AppColors.gray600,
      ),
    );
  }

  Widget _buildCarTitleSection(VehicleModel vehicle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vehicle.title,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.brandName,
                  style: TextStyle(
                    fontSize: 16,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  vehicle.displayInfo,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                vehicle.formattedPrice,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                ),
              ),
              if (vehicle.isPublished)
                const Text(
                  'Published',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTagsSection(VehicleModel vehicle, bool isDark) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          _buildTag(vehicle.fuelTypeName, isDark),
          _buildTag(_carColor, isDark),
          _buildTag(_bodyType, isDark),
        ],
      ),
    );
  }

  Widget _buildTag(String label, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isDark ? AppColors.gray800 : AppColors.gray200,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.gray700 : AppColors.gray300,
        ),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isDark ? AppColors.gray300 : AppColors.gray700,
        ),
      ),
    );
  }

  Widget _buildBasicInfoSection(VehicleModel vehicle, bool isDark) {
    final detail = vehicle.vehicleDetail;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'BASIC INFORMATION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildSpecItem(Icons.calendar_today, 'Model Year', vehicle.modelYearName, isDark),
              _buildSpecItem(Icons.category, 'Category', vehicle.categoryName, isDark),
              _buildSpecItem(Icons.branding_watermark, 'Brand', vehicle.brandName, isDark),
              _buildSpecItem(Icons.local_gas_station, 'Fuel Type', vehicle.fuelTypeName, isDark),
              _buildSpecItem(Icons.speed, 'Mileage', '${_formatNumber(vehicle.mileage)} km', isDark),
              _buildSpecItem(Icons.directions_car, 'Km Driven', '${_formatNumber(vehicle.kmDriven)} km', isDark),
              _buildSpecItem(Icons.assignment, 'Registration', vehicle.registration ?? 'N/A', isDark),
              _buildSpecItem(Icons.confirmation_number, 'VIN', vehicle.vin ?? 'N/A', isDark),
              _buildSpecItem(Icons.check_circle_outline, 'Status', _status, isDark, isStatus: true),
              _buildSpecItem(Icons.palette, 'Color', _carColor, isDark),
              _buildSpecItem(Icons.directions_car, 'Body Type', _bodyType, isDark),
              _buildSpecItem(Icons.location_on, 'Location', vehicle.location?.fullAddress ?? 'Unknown', isDark),
              if (vehicle.firstRegistrationDate != null)
                _buildSpecItem(Icons.event, 'First Registration', _formatDate(vehicle.firstRegistrationDate), isDark),
              if (detail?.useName != null)
                _buildSpecItem(Icons.info, 'Use Type', detail!.useName, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTechnicalSpecsSection(VehicleModel vehicle, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'TECHNICAL SPECIFICATIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildSpecItem(Icons.battery_charging_full, 'Battery Capacity', vehicle.batteryCapacity != null ? '${vehicle.batteryCapacity} kWh' : 'N/A', isDark),
              _buildSpecItem(Icons.speed, 'Engine Power', vehicle.enginePower != null ? '${vehicle.enginePower} HP' : 'N/A', isDark),
              _buildSpecItem(Icons.local_shipping, 'Towing Weight', vehicle.towingWeight != null ? '${_formatNumber(vehicle.towingWeight)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.receipt, 'Ownership Tax', vehicle.ownershipTax != null ? 'kr. ${_formatNumber(vehicle.ownershipTax)}' : 'N/A', isDark),
              if (vehicle.vehicleDetail != null) ...[
                _buildSpecItem(Icons.speed, 'Top Speed', vehicle.vehicleDetail!.topSpeed != null ? '${vehicle.vehicleDetail!.topSpeed} km/h' : 'N/A', isDark),
                _buildSpecItem(Icons.door_front_door, 'Doors', vehicle.vehicleDetail!.doors?.toString() ?? 'N/A', isDark),
                _buildSpecItem(Icons.event_seat, 'Seats', vehicle.vehicleDetail!.minimumSeats != null && vehicle.vehicleDetail!.maximumSeats != null
                    ? '${vehicle.vehicleDetail!.minimumSeats}-${vehicle.vehicleDetail!.maximumSeats}'
                    : (vehicle.vehicleDetail!.minimumSeats?.toString() ?? 'N/A'), isDark),
                _buildSpecItem(Icons.directions_car, 'Wheels', vehicle.vehicleDetail!.wheels?.toString() ?? 'N/A', isDark),
                _buildSpecItem(Icons.settings, 'Axles', vehicle.vehicleDetail!.axles?.toString() ?? 'N/A', isDark),
                _buildSpecItem(Icons.settings, 'Drive Axles', vehicle.vehicleDetail!.driveAxles?.toString() ?? 'N/A', isDark),
                _buildSpecItem(Icons.straighten, 'Wheelbase', vehicle.vehicleDetail!.wheelbase != null ? '${vehicle.vehicleDetail!.wheelbase} mm' : 'N/A', isDark),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEngineDetailsSection(VehicleModel vehicle, bool isDark) {
    final detail = vehicle.vehicleDetail;
    if (detail == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ENGINE DETAILS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildSpecItem(Icons.local_gas_station, 'Fuel Efficiency', detail.fuelEfficiency != null ? '${detail.fuelEfficiency!.toStringAsFixed(2)} L/100km' : 'N/A', isDark),
              _buildSpecItem(Icons.settings, 'Displacement', detail.engineDisplacement != null ? '${_formatNumber(detail.engineDisplacement)} cc' : 'N/A', isDark),
              _buildSpecItem(Icons.settings, 'Cylinders', detail.engineCylinders?.toString() ?? 'N/A', isDark),
              _buildSpecItem(Icons.code, 'Engine Code', detail.engineCode ?? 'N/A', isDark),
              _buildSpecItem(Icons.info, 'Version', detail.version ?? 'N/A', isDark),
              _buildSpecItem(Icons.category, 'Type', detail.typeNameResolved, isDark),
              if (detail.euronorm != null)
                _buildSpecItem(Icons.eco, 'Euro Norm', detail.euronorm!, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightDimensionsSection(VehicleModel vehicle, bool isDark) {
    final detail = vehicle.vehicleDetail;
    if (detail == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'WEIGHT & DIMENSIONS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildSpecItem(Icons.scale, 'Total Weight', detail.totalWeight != null ? '${_formatNumber(detail.totalWeight)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.scale, 'Vehicle Weight', detail.vehicleWeight != null ? '${_formatNumber(detail.vehicleWeight)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.scale, 'Technical Total Weight', detail.technicalTotalWeight != null ? '${_formatNumber(detail.technicalTotalWeight)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.scale, 'Minimum Weight', detail.minimumWeight != null ? '${_formatNumber(detail.minimumWeight)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.scale, 'Coupling Weight', detail.coupling != null ? '${_formatNumber(detail.coupling)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.local_shipping, 'Towing Weight (Brakes)', detail.towingWeightBrakes != null ? '${_formatNumber(detail.towingWeightBrakes)} kg' : 'N/A', isDark),
              _buildSpecItem(Icons.scale, 'Gross Combination Weight', detail.grossCombinationWeight != null ? '${_formatNumber(detail.grossCombinationWeight)} kg' : 'N/A', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyFeaturesSection(VehicleModel vehicle, bool isDark) {
    final detail = vehicle.vehicleDetail;
    if (detail == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'SAFETY FEATURES',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 3,
            children: [
              _buildSpecItem(Icons.security, 'NCAP 5-Star', detail.ncapFive == true ? 'Yes' : (detail.ncapFive == false ? 'No' : 'N/A'), isDark),
              _buildSpecItem(Icons.airline_seat_recline_normal, 'Airbags', detail.airbags?.toString() ?? 'N/A', isDark),
              _buildSpecItem(Icons.child_care, 'Child Seats', detail.integratedChildSeats?.toString() ?? 'N/A', isDark),
              _buildSpecItem(Icons.warning, 'Seat Belt Alarms', detail.seatBeltAlarms?.toString() ?? 'N/A', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRegistrationInspectionSection(VehicleModel vehicle, bool isDark) {
    final detail = vehicle.vehicleDetail;
    if (detail == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'REGISTRATION & INSPECTION',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 24,
            mainAxisSpacing: 16,
            childAspectRatio: 2.6,
            children: [
              _buildSpecItem(Icons.assignment, 'Registration Status', detail.registrationStatus ?? 'N/A', isDark),
              _buildSpecItem(Icons.event, 'Status Updated', detail.registrationStatusUpdatedDate != null ? _formatDate(detail.registrationStatusUpdatedDate) : 'N/A', isDark),
              _buildSpecItem(Icons.event, 'Expire Date', detail.expireDate != null ? _formatDate(detail.expireDate) : 'N/A', isDark),
              _buildSpecItem(Icons.event, 'Status Updated Date', detail.statusUpdatedDate != null ? _formatDate(detail.statusUpdatedDate) : 'N/A', isDark),
              _buildSpecItem(Icons.build, 'Last Inspection', detail.lastInspectionDate != null ? _formatDate(detail.lastInspectionDate) : 'N/A', isDark),
              _buildSpecItem(Icons.check_circle, 'Inspection Result', detail.lastInspectionResult ?? 'N/A', isDark),
              _buildSpecItem(Icons.speed, 'Inspection Odometer', detail.lastInspectionOdometer != null ? '${_formatNumber(detail.lastInspectionOdometer)} km' : 'N/A', isDark),
              _buildSpecItem(Icons.verified, 'Type Approval Code', detail.typeApprovalCode ?? 'N/A', isDark),
              if (detail.vinLocation != null)
                _buildSpecItem(Icons.location_on, 'VIN Location', detail.vinLocation!, isDark),
              if (detail.leasingPeriodStart != null || detail.leasingPeriodEnd != null)
                _buildSpecItem(Icons.event, 'Leasing Period', 
                    detail.leasingPeriodStart != null && detail.leasingPeriodEnd != null
                        ? '${_formatDate(detail.leasingPeriodStart)} - ${_formatDate(detail.leasingPeriodEnd)}'
                        : 'N/A', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(IconData icon, String label, String value, bool isDark, {bool isStatus = false}) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              Flexible(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isStatus && value == 'Sold Out'
                        ? Colors.red
                        : (isDark ? AppColors.textDark : AppColors.textLight),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleOverviewSection(VehicleModel vehicle, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'VEHICLE OVERVIEW',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            _vehicleOverview,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.gray300 : AppColors.gray600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () {
              // Show full description
            },
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Read more',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAdditionalDetailsSection(VehicleModel vehicle, bool isDark) {
    final detail = vehicle.vehicleDetail;
    if (detail == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'ADDITIONAL DETAILS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          if (detail.extraEquipment != null && detail.extraEquipment!.isNotEmpty) ...[
            _buildDetailRow('Extra Equipment', detail.extraEquipment!, isDark),
            const SizedBox(height: 12),
          ],
          if (detail.dispensations != null && detail.dispensations!.isNotEmpty) ...[
            _buildDetailRow('Dispensations', detail.dispensations!, isDark),
            const SizedBox(height: 12),
          ],
          if (detail.permits != null && detail.permits!.isNotEmpty) ...[
            _buildDetailRow('Permits', detail.permits!, isDark),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            color: isDark ? AppColors.gray300 : AppColors.gray700,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentSection(VehicleModel vehicle, bool isDark) {
    if (vehicle.equipment == null || vehicle.equipment!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.build,
                size: 16,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              ),
              const SizedBox(width: 8),
              Text(
                'EQUIPMENT',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: vehicle.equipment!.map((equipment) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.gray800 : AppColors.gray200,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isDark ? AppColors.gray700 : AppColors.gray300,
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 16,
                      color: isDark ? AppColors.gray400 : AppColors.gray600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      equipment.name,
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.gray300 : AppColors.gray700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationSection(BuildContext context, VehicleModel vehicle, bool isDark) {
    final location = vehicle.location;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isDark ? AppColors.gray700 : AppColors.gray300,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_on,
              color: isDark ? AppColors.gray400 : AppColors.gray600,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Location',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  location?.fullAddress ?? 'Location not available',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                  ),
                ),
                if (location != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Views: ${vehicle.vehicleDetail?.viewsCount ?? 0}',
                    style: TextStyle(
                      fontSize: 11,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                ],
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.chat_bubble_outline,
              color: Colors.blue,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                isDismissible: true,
                enableDrag: true,
                barrierColor: Colors.black.withOpacity(0.8),
                builder: (context) => ContactSellerBottomSheet(vehicle: vehicle),
              );
            },
            style: IconButton.styleFrom(
              backgroundColor: isDark ? AppColors.gray800 : AppColors.gray200,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context, VehicleModel vehicle, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
          ),
        ),
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {
                  Get.snackbar(
                    'Test Drive',
                    'Booking test drive for ${vehicle.fullName}',
                    snackPosition: SnackPosition.TOP,
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: BorderSide(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Book Test Drive',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    isDismissible: true,
                    enableDrag: true,
                    barrierColor: Colors.black.withOpacity(0.8),
                    builder: (context) => ContactSellerBottomSheet(vehicle: vehicle),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: isDark ? Colors.white : AppColors.gray900,
                  foregroundColor: isDark ? Colors.black : Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
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
      ),
    );
  }
}

