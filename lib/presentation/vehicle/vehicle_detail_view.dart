import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/vehicle_detail_controller.dart';
import '../../models/vehicle_detail_model/vehicle_detail_model.dart';
import '../widgets/vehicle_image_gallery.dart';
import '../widgets/detail_section_card.dart';

class VehicleDetailView extends StatelessWidget {
  const VehicleDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(VehicleDetailController());

    return Obx(() {
      final isDark = appController.isDarkMode.value;

      return Scaffold(
        backgroundColor: isDark
            ? AppColors.backgroundDark
            : AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: isDark
              ? AppColors.backgroundDark
              : AppColors.backgroundLight,
          foregroundColor: AppColors.primary,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AppColors.primary,
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    strokeWidth: 3,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Loading vehicle details...',
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                    ),
                  ),
                ],
              ),
            );
          }

          // Error state
          if (controller.errorMessage.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: isDark ? AppColors.textDark : AppColors.textLight,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      controller.errorMessage.value,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        final vehicleId = Get.parameters['id'];
                        if (vehicleId != null) {
                          controller.fetchVehicleDetail(int.parse(vehicleId));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: AppColors.primaryForeground,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state
          final vehicle = controller.vehicleDetail.value;
          if (vehicle == null) {
            return const Center(
              child: Text('No vehicle data available'),
            );
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery Section - At the top
                VehicleImageGallery(
                  images: vehicle.images,
                  isDark: isDark,
                ),

                // Hero Section - Title and Price
                Container(
                  margin: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Badge for listing type
                      if (vehicle.listingTypeName != null)
                        Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            vehicle.listingTypeName!,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      Text(
                        vehicle.title,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                          height: 1.2,
                          letterSpacing: -0.6,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formatPrice(vehicle.price),
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: AppColors.primary,
                              letterSpacing: -0.8,
                              height: 1,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: isDark 
                                    ? AppColors.cardDark 
                                    : AppColors.mutedBackground,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Listed Price',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: isDark 
                                      ? AppColors.mutedDark 
                                      : AppColors.mutedLight,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Vehicle Specifications Card
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: DetailSectionCard(
                    title: 'Vehicle Specifications',
                    isDark: isDark,
                    items: [
                    if (vehicle.brandName != null)
                      DetailItem(label: 'Brand', value: vehicle.brandName!),
                    if (vehicle.modelName != null)
                      DetailItem(label: 'Model', value: vehicle.modelName!),
                    if (vehicle.fuelTypeName != null)
                      DetailItem(label: 'Fuel Type', value: vehicle.fuelTypeName!),
                    if (vehicle.details?.annualTax != null)
                      DetailItem(label: 'Annual Tax', value: '${vehicle.details!.annualTax} kr.'),
                    if (vehicle.firstRegistrationDate != null)
                      DetailItem(
                        label: 'First Registration',
                        value: _formatDate(vehicle.firstRegistrationDate),
                      ),
                  ],
                  ),
                ),

                // Description Section
                if (vehicle.details?.description != null &&
                    vehicle.details!.description!.isNotEmpty) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 20,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(
                                Icons.description,
                                size: 20,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Description',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: isDark ? AppColors.textDark : AppColors.textLight,
                                letterSpacing: -0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          vehicle.details!.description!,
                          style: TextStyle(
                            fontSize: 15,
                            color: isDark ? AppColors.textDark : AppColors.textLight,
                            height: 1.6,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // Detailed Specifications Card
                if (vehicle.details != null) ...[
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.cardDark : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: isDark 
                              ? Colors.black.withOpacity(0.3)
                              : Colors.black.withOpacity(0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Detailed Specifications',
                                style: TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700,
                                  color: isDark ? AppColors.textDark : AppColors.textLight,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Grid items with modern styling
                          Builder(
                            builder: (context) {
                              // Collect all specification items
                              final specItems = <Map<String, String>>[];
                              
                              if (vehicle.details!.typeNameResolved != null)
                                specItems.add({'label': 'Type', 'value': vehicle.details!.typeNameResolved!});
                              if (vehicle.details!.useName != null)
                                specItems.add({'label': 'Use', 'value': vehicle.details!.useName!});
                              if (vehicle.details!.colorName != null)
                                specItems.add({'label': 'Color', 'value': vehicle.details!.colorName!});
                              if (vehicle.details!.variantId != null)
                                specItems.add({'label': 'Variant', 'value': vehicle.details!.variantId.toString()});
                              if (vehicle.details!.totalWeight != null)
                                specItems.add({'label': 'Total Weight', 'value': '${vehicle.details!.totalWeight!.toStringAsFixed(0)} kg'});
                              if (vehicle.details!.vehicleWeight != null)
                                specItems.add({'label': 'Vehicle Weight', 'value': '${vehicle.details!.vehicleWeight!.toStringAsFixed(0)} kg'});
                              if (vehicle.details!.technicalTotalWeight != null)
                                specItems.add({'label': 'Technical Total Weight', 'value': '${vehicle.details!.technicalTotalWeight!.toStringAsFixed(0)} kg'});
                              if (vehicle.fuelEfficiency != null)
                                specItems.add({'label': 'Fuel Efficiency', 'value': '${vehicle.fuelEfficiency} km/l'});
                              if (vehicle.details!.ncapFive == true)
                                specItems.add({'label': 'NCAP 5-Star', 'value': 'Yes'});
                              if (vehicle.details!.euronomId != null)
                                specItems.add({'label': 'Euro Norm', 'value': vehicle.details!.euronomId.toString()});
                              if (vehicle.details!.axles != null)
                                specItems.add({'label': 'Axles', 'value': vehicle.details!.axles.toString()});

                              return GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 12,
                                  mainAxisSpacing: 12,
                                  childAspectRatio: 1.6,
                                ),
                                itemCount: specItems.length,
                                itemBuilder: (context, index) {
                                  final item = specItems[index];
                                  return _buildSpecItem(
                                    context,
                                    item['label']!,
                                    item['value']!,
                                    isDark,
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                  ),
                ],

                // Registration & Status Card
                if (vehicle.details != null)
                  DetailSectionCard(
                    title: 'Registration & Status',
                    isDark: isDark,
                    items: [
                      if (vehicle.details!.registrationStatus != null)
                        DetailItem(
                          label: 'Registration Status',
                          value: vehicle.details!.registrationStatus!,
                        ),
                      if (vehicle.details!.registrationStatusUpdatedDate != null)
                        DetailItem(
                          label: 'Registration Status Updated',
                          value: _formatDate(vehicle.details!.registrationStatusUpdatedDate),
                        ),
                      if (vehicle.details!.expireDate != null)
                        DetailItem(
                          label: 'Expire Date',
                          value: _formatDate(vehicle.details!.expireDate),
                        ),
                      if (vehicle.details!.statusUpdatedDate != null)
                        DetailItem(
                          label: 'Status Updated',
                          value: _formatDate(vehicle.details!.statusUpdatedDate),
                        ),
                    ],
                  ),

                // Inspection Details Card
                if (vehicle.details != null)
                  DetailSectionCard(
                    title: 'Inspection Details',
                    isDark: isDark,
                    items: [
                      if (vehicle.details!.lastInspectionDate != null)
                        DetailItem(
                          label: 'Last Inspection Date',
                          value: _formatDate(vehicle.details!.lastInspectionDate),
                        ),
                      if (vehicle.details!.lastInspectionResult != null)
                        DetailItem(
                          label: 'Last Inspection Result',
                          value: vehicle.details!.lastInspectionResult!,
                        ),
                      if (vehicle.details!.lastInspectionOdometer != null)
                        DetailItem(
                          label: 'Last Inspection Odometer',
                          value: _formatMileage(vehicle.details!.lastInspectionOdometer),
                        ),
                    ],
                  ),

                // Seller Information Card
                _buildSellerInfoCard(vehicle, isDark),

                // Pricing Card (Modern Gradient)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryDark,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Listed Price',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: AppColors.primaryForeground.withOpacity(0.9),
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _formatPrice(vehicle.price),
                              style: const TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.w900,
                                color: AppColors.primaryForeground,
                                letterSpacing: -1.5,
                                height: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.primaryForeground.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.attach_money_rounded,
                          color: AppColors.primaryForeground,
                          size: 32,
                        ),
                      ),
                    ],
                  ),
                ),

                // Listing Information Card
                if (vehicle.publishedAt != null)
                  DetailSectionCard(
                    title: 'Listing Information',
                    isDark: isDark,
                    items: [
                      DetailItem(
                        label: 'Added to Listing',
                        value: _formatDaysAgo(vehicle.publishedAt),
                      ),
                    ],
                  ),

                // Interested? Section
                _buildInterestedSection(isDark, vehicle),

                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildSellerInfoCard(VehicleDetailModel vehicle, bool isDark) {
    final sellerPhone = vehicle.details?.sellerPhone ?? vehicle.user?.phone;
    final sellerAddress = vehicle.details?.sellerAddress;
    final sellerPostcode = vehicle.details?.sellerPostcode;
    final sellerName = vehicle.user?.name ?? 'Unknown Seller';

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.person_outline,
                  size: 24,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Seller Information',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // Seller name
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark 
                  ? Colors.white.withOpacity(0.05)
                  : AppColors.mutedBackground,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.person,
                    size: 24,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seller',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sellerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.textDark : AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (sellerAddress != null || sellerPostcode != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.mutedBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (sellerAddress != null)
                          Text(
                            sellerAddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                        if (sellerPostcode != null)
                          Text(
                            sellerPostcode,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: isDark ? AppColors.textDark : AppColors.textLight,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          if (sellerPhone != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark 
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.mutedBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: _PhoneNumberWidget(phone: sellerPhone, isDark: isDark),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterestedSection(bool isDark, VehicleDetailModel vehicle) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.3)
                : AppColors.primary.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.favorite_outline,
                  size: 24,
                  color: AppColors.primaryForeground,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Interested?',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: isDark ? AppColors.textDark : AppColors.textLight,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Take the next steps to make this vehicle yours.',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Modern bullet points
          _buildModernBulletPoint(
            Icons.history,
            'Request detailed vehicle history',
            isDark,
          ),
          _buildModernBulletPoint(
            Icons.check_circle_outline,
            'Schedule inspection',
            isDark,
          ),
          _buildModernBulletPoint(
            Icons.account_balance_wallet_outlined,
            'Discuss financing options',
            isDark,
          ),
          _buildModernBulletPoint(
            Icons.directions_car_outlined,
            'Arrange test drive',
            isDark,
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // TODO: Implement contact seller functionality
                Get.snackbar(
                  'Contact Seller',
                  'Contact seller functionality coming soon',
                  snackPosition: SnackPosition.BOTTOM,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: AppColors.primaryForeground,
                padding: const EdgeInsets.symmetric(vertical: 18),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.message_outlined, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Contact Seller',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModernBulletPoint(IconData icon, String text, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              size: 18,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppColors.textDark : AppColors.textLight,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStat(IconData icon, String label, String value, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              size: 24,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSpecItem(BuildContext context, String label, String value, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isDark 
            ? Colors.white.withOpacity(0.05)
            : AppColors.mutedBackground,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark 
              ? Colors.white.withOpacity(0.1)
              : Colors.black.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 0.3,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.textDark : AppColors.textLight,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Format price with commas and "kr." suffix
  String _formatPrice(int price) {
    final priceStr = price.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < priceStr.length; i++) {
      if (i > 0 && (priceStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(priceStr[i]);
    }
    return '${buffer.toString()} kr.';
  }

  /// Format ISO date string to readable format (e.g., "November 1, 2004")
  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final months = [
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December'
      ];
      return '${months[date.month - 1]} ${date.day}, ${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  /// Extract year from date string
  String _formatYear(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      return date.year.toString();
    } catch (e) {
      return dateString;
    }
  }

  /// Calculate "X days ago" from published_at date
  String _formatDaysAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      final days = difference.inDays;
      if (days == 0) {
        return 'Today';
      } else if (days == 1) {
        return '1 day ago';
      } else {
        return '$days days ago';
      }
    } catch (e) {
      return dateString;
    }
  }

  /// Format mileage with thousand separators
  String _formatMileage(int? mileage) {
    if (mileage == null) return '';
    final mileageStr = mileage.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < mileageStr.length; i++) {
      if (i > 0 && (mileageStr.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(mileageStr[i]);
    }
    return '${buffer.toString()} km';
  }
}

/// Widget to show/hide phone number
class _PhoneNumberWidget extends StatefulWidget {
  final String phone;
  final bool isDark;

  const _PhoneNumberWidget({
    required this.phone,
    required this.isDark,
  });

  @override
  State<_PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<_PhoneNumberWidget> {
  bool _showPhone = false;

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri.parse('tel:$phone');
    try {
      if (!await launchUrl(phoneUri, mode: LaunchMode.platformDefault)) {
        Get.snackbar(
          'Error',
          'Could not open phone dialer',
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Could not open phone dialer',
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.phone, size: 20, color: AppColors.primary),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _showPhone
              ? GestureDetector(
                  onTap: () => _launchPhone(widget.phone),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.isDark 
                              ? AppColors.mutedDark 
                              : AppColors.mutedLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        widget.phone,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _showPhone = true;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: widget.isDark 
                              ? AppColors.mutedDark 
                              : AppColors.mutedLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            'Show Phone Number',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.arrow_forward_ios,
                            size: 14,
                            color: AppColors.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ],
    );
  }
}
