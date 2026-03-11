import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import '../../utils/app_colors.dart';
import '../../controllers/app_controller/app_controller.dart';
import '../../controllers/vehicle_detail_controller.dart';
import '../../main.dart';
import '../../models/vehicle_detail_model/vehicle_detail_model.dart';
import '../../repositories/vehicle/vehicle_repository.dart';
import '../widgets/vehicle_image_gallery.dart';
import '../widgets/detail_section_card.dart';
import '../widgets/expandable_section_card.dart';
import '../widgets/vehicle_detail_shimmer.dart';
import 'widgets/enquiry_form_bottom_sheet.dart';

class VehicleDetailView extends StatelessWidget {
  const VehicleDetailView({super.key});

  /// True when the listing belongs to the authenticated user (hide contact/enquiry).
  static bool _isOwnListing(VehicleDetailModel vehicle) {
    if (vehicle.userId == null) return false;
    try {
      final userJson = appStorage.read('user');
      if (userJson == null) return false;
      final userMap = jsonDecode(userJson.toString()) as Map<String, dynamic>;
      final currentId = userMap['id'];
      if (currentId == null) return false;
      final currentIdInt = currentId is int ? currentId : (currentId is num ? currentId.toInt() : null);
      return currentIdInt != null && vehicle.userId == currentIdInt;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final appController = Get.find<AppController>();
    final controller = Get.put(VehicleDetailController());
    final l10n = AppLocalizations.of(context)!;

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
            icon: Icon(Icons.arrow_back, color: AppColors.primary),
            onPressed: () => Get.back(),
          ),
        ),
        body: Obx(() {
          // Loading state - Show shimmer
          if (controller.isLoading.value) {
            return VehicleDetailShimmer(isDark: isDark);
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
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
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
                      child: Text(l10n.retry),
                    ),
                  ],
                ),
              ),
            );
          }

          // Success state
          final vehicle = controller.vehicleDetail.value;
          if (vehicle == null) {
            return Center(child: Text(l10n.noVehicleDataAvailable));
          }

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image Gallery Section - At the top
                VehicleImageGallery(images: vehicle.images, isDark: isDark),

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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
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
                          color: isDark
                              ? AppColors.textDark
                              : AppColors.textLight,
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
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? AppColors.cardDark
                                    : AppColors.mutedBackground,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                l10n.listedPrice,
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

                // Contact CTA at top (hidden for own listing)
                if (!_isOwnListing(vehicle))
                  _buildContactCtaAtTop(context, vehicle, isDark),

                // Basic Information Section
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: DetailSectionCard(
                    title: l10n.basicInformation,
                    isDark: isDark,
                    initiallyExpanded: true,
                    items: [
                      DetailItem(label: l10n.vehicleDetailTitleLabel, value: vehicle.title),
                      DetailItem(
                        label: l10n.priceLabel,
                        value: _formatPrice(vehicle.price),
                      ),
                      if (vehicle.listingTypeName != null)
                        DetailItem(
                          label: l10n.listingType,
                          value: vehicle.listingTypeName!,
                        ),
                    ],
                  ),
                ),

                // Vehicle Specifications Card
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: DetailSectionCard(
                    title: l10n.vehicleSpecifications,
                    isDark: isDark,
                    initiallyExpanded: true,
                    items: [
                      if (vehicle.brandName != null)
                        DetailItem(label: l10n.brand, value: vehicle.brandName!),
                      if (vehicle.modelName != null)
                        DetailItem(label: l10n.model, value: vehicle.modelName!),
                      if (vehicle.modelYearName != null)
                        DetailItem(
                          label: l10n.modelYear,
                          value: vehicle.modelYearName!,
                        ),
                      if (vehicle.fuelTypeName != null)
                        DetailItem(
                          label: l10n.fuelType,
                          value: vehicle.fuelTypeName!,
                        ),
                      if (vehicle.enginePowerHp != null &&
                          vehicle.enginePowerHp! > 0)
                        DetailItem(
                          label: l10n.enginePower,
                          value:
                              '${vehicle.enginePowerHp!.toStringAsFixed(0)} HP',
                        ),
                      if (vehicle.kmDriven != null)
                        DetailItem(
                          label: l10n.kilometersDriven,
                          value: _formatMileage(vehicle.kmDriven),
                        ),
                      if (vehicle.batteryCapacity != null)
                        DetailItem(
                          label: l10n.batteryCapacityKwh,
                          value: '${vehicle.batteryCapacity} kWh',
                        ),
                      if (vehicle.rangeKm != null)
                        DetailItem(
                          label: l10n.rangeKm,
                          value: _formatMileage(vehicle.rangeKm),
                        ),
                      if (vehicle.chargingType != null)
                        DetailItem(
                          label: l10n.chargingType,
                          value: vehicle.chargingType!,
                        ),
                      if (vehicle.towingWeight != null &&
                          vehicle.towingWeight! > 0)
                        DetailItem(
                          label: l10n.towingWeightKg,
                          value:
                              '${vehicle.towingWeight!.toStringAsFixed(0)} kg',
                        ),
                      if (vehicle.ownershipTax != null)
                        DetailItem(
                          label: l10n.ownerTax,
                          value: vehicle.ownershipTax!,
                        ),
                      if (vehicle.details?.annualTax != null)
                        DetailItem(
                          label: l10n.annualTax,
                          value: '${vehicle.details!.annualTax} kr.',
                        ),
                      if (vehicle.firstRegistrationDate != null)
                        DetailItem(
                          label: l10n.firstRegistration,
                          value: _formatDate(context, vehicle.firstRegistrationDate),
                        ),
                    ],
                  ),
                ),

                // Description Section
                if (vehicle.details?.description != null &&
                    vehicle.details!.description!.isNotEmpty)
                  ExpandableSectionCard(
                    title: l10n.description,
                    icon: Icons.description,
                    isDark: isDark,
                    initiallyExpanded: true,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Text(
                      vehicle.details!.description!,
                      style: TextStyle(
                        fontSize: 15,
                        color: isDark
                            ? AppColors.textDark
                            : AppColors.textLight,
                        height: 1.6,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                // Seller Information Card (hidden for own listing)
                if (!_isOwnListing(vehicle))
                  _buildSellerInfoCard(context, vehicle, isDark),

                // Registration & Status Card
                if (vehicle.details != null)
                  DetailSectionCard(
                    title: l10n.registrationAndStatus,
                    isDark: isDark,
                    initiallyExpanded: false,
                    items: [
                      if (vehicle.details!.registrationStatus != null)
                        DetailItem(
                          label: l10n.registrationStatus,
                          value: vehicle.details!.registrationStatus!,
                        ),
                      if (vehicle.details!.registrationStatusUpdatedDate !=
                          null)
                        DetailItem(
                          label: l10n.registrationStatusUpdated,
                          value: _formatDate(
                            context,
                            vehicle.details!.registrationStatusUpdatedDate,
                          ),
                        ),
                      if (vehicle.details!.expireDate != null)
                        DetailItem(
                          label: l10n.expireDate,
                          value: _formatDate(context, vehicle.details!.expireDate),
                        ),
                      if (vehicle.details!.statusUpdatedDate != null)
                        DetailItem(
                          label: l10n.statusUpdated,
                          value: _formatDate(
                            context,
                            vehicle.details!.statusUpdatedDate,
                          ),
                        ),
                    ],
                  ),

                // Inspection Details Card
                if (vehicle.details != null)
                  DetailSectionCard(
                    title: l10n.inspectionDetails,
                    isDark: isDark,
                    initiallyExpanded: false,
                    items: [
                      if (vehicle.details!.lastInspectionDate != null)
                        DetailItem(
                          label: l10n.lastInspectionDate,
                          value: _formatDate(
                            context,
                            vehicle.details!.lastInspectionDate,
                          ),
                        ),
                      if (vehicle.details!.lastInspectionResult != null)
                        DetailItem(
                          label: l10n.lastInspectionResult,
                          value: vehicle.details!.lastInspectionResult!,
                        ),
                      if (vehicle.details!.lastInspectionOdometer != null)
                        DetailItem(
                          label: l10n.lastInspectionOdometer,
                          value: _formatMileage(
                            vehicle.details!.lastInspectionOdometer,
                          ),
                        ),
                    ],
                  ),

                // Leasing Information Section
                if (vehicle.details != null &&
                    (vehicle.details!.leasingPeriodStart != null ||
                        vehicle.details!.leasingPeriodEnd != null))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: DetailSectionCard(
                      title: l10n.leasingInformation,
                      isDark: isDark,
                      initiallyExpanded: false,
                      items: [
                        if (vehicle.details!.leasingPeriodStart != null)
                          DetailItem(
                            label: l10n.leasingPeriodStart,
                            value: _formatDate(
                              context,
                              vehicle.details!.leasingPeriodStart,
                            ),
                          ),
                        if (vehicle.details!.leasingPeriodEnd != null)
                          DetailItem(
                            label: l10n.leasingPeriodEnd,
                            value: _formatDate(
                              context,
                              vehicle.details!.leasingPeriodEnd,
                            ),
                          ),
                      ],
                    ),
                  ),

                // Equipment & Features Section
                if (vehicle.equipment.isNotEmpty)
                  ExpandableSectionCard(
                    title: l10n.equipmentAndFeatures,
                    icon: Icons.checklist_outlined,
                    isDark: isDark,
                    initiallyExpanded: false,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: vehicle.equipment
                          .map(
                            (e) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isDark
                                    ? Colors.white.withOpacity(0.08)
                                    : AppColors.mutedBackground,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isDark
                                      ? Colors.white.withOpacity(0.12)
                                      : Colors.black.withOpacity(0.08),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.check_circle_outline,
                                    size: 16,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    e.name,
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: isDark
                                          ? AppColors.textDark
                                          : AppColors.textLight,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),

                // Detailed Specifications Card
                if (vehicle.details != null)
                  ExpandableSectionCard(
                    title: l10n.detailedSpecifications,
                    icon: Icons.info_outline,
                    isDark: isDark,
                    initiallyExpanded: false,
                    margin: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 6,
                    ),
                    child: Builder(
                      builder: (context) {
                        final specL10n = AppLocalizations.of(context)!;
                        // Collect all specification items
                        final specItems = <Map<String, String>>[];

                        if (vehicle.details!.typeNameResolved != null)
                          specItems.add({
                            'label': specL10n.type,
                            'value': vehicle.details!.typeNameResolved!,
                          });
                        if (vehicle.details!.useName != null)
                          specItems.add({
                            'label': specL10n.use,
                            'value': vehicle.details!.useName!,
                          });
                        if (vehicle.details!.colorName != null)
                          specItems.add({
                            'label': specL10n.color,
                            'value': vehicle.details!.colorName!,
                          });
                        if (vehicle.details!.bodyTypeName != null)
                          specItems.add({
                            'label': specL10n.bodyType,
                            'value': vehicle.details!.bodyTypeName!,
                          });
                        final variantDisplay = vehicle.details!.variantName ??
                            (vehicle.details!.variantId != null
                                ? vehicle.details!.variantId.toString()
                                : null);
                        if (variantDisplay != null)
                          specItems.add({
                            'label': specL10n.variant,
                            'value': variantDisplay,
                          });
                        if (vehicle.details!.priceTypeName != null)
                          specItems.add({
                            'label': specL10n.priceType,
                            'value': vehicle.details!.priceTypeName!,
                          });
                        if (vehicle.details!.conditionName != null)
                          specItems.add({
                            'label': specL10n.condition,
                            'value': vehicle.details!.conditionName!,
                          });
                        if (vehicle.gearTypeName != null)
                          specItems.add({
                            'label': specL10n.gearType,
                            'value': vehicle.gearTypeName!,
                          });
                        if (vehicle.details!.transmissionName != null)
                          specItems.add({
                            'label': specL10n.transmission,
                            'value': vehicle.details!.transmissionName!,
                          });
                        if (vehicle.details!.salesTypeName != null)
                          specItems.add({
                            'label': specL10n.salesType,
                            'value': vehicle.details!.salesTypeName!,
                          });
                        if (vehicle.details!.servicebog != null &&
                            vehicle.details!.servicebog != 'Default')
                          specItems.add({
                            'label': specL10n.serviceBook,
                            'value': vehicle.details!.servicebog!,
                          });
                        if (vehicle.version != null)
                          specItems.add({
                            'label': specL10n.version,
                            'value': vehicle.version!,
                          });
                        if (vehicle.details!.vinLocation != null)
                          specItems.add({
                            'label': specL10n.vinLocation,
                            'value': vehicle.details!.vinLocation!,
                          });
                        if (vehicle.details!.totalWeight != null &&
                            vehicle.details!.totalWeight! > 0)
                          specItems.add({
                            'label': specL10n.totalWeight,
                            'value':
                                '${vehicle.details!.totalWeight!.toStringAsFixed(0)} kg',
                          });
                        if (vehicle.details!.technicalTotalWeight != null &&
                            vehicle.details!.technicalTotalWeight! > 0)
                          specItems.add({
                            'label': specL10n.technicalTotalWeight,
                            'value':
                                '${vehicle.details!.technicalTotalWeight!.toStringAsFixed(0)} kg',
                          });
                        if (vehicle.details!.minimumWeight != null &&
                            vehicle.details!.minimumWeight! > 0)
                          specItems.add({
                            'label': specL10n.minimumWeight,
                            'value':
                                '${vehicle.details!.minimumWeight!.toStringAsFixed(0)} kg',
                          });
                        if (vehicle.details!.grossCombinationWeight != null &&
                            vehicle.details!.grossCombinationWeight! > 0)
                          specItems.add({
                            'label': specL10n.grossCombinationWeight,
                            'value':
                                '${vehicle.details!.grossCombinationWeight!.toStringAsFixed(0)} kg',
                          });
                        if (vehicle.details!.towingWeightBrakes != null &&
                            vehicle.details!.towingWeightBrakes! > 0)
                          specItems.add({
                            'label': specL10n.towingWeightBrakes,
                            'value':
                                '${vehicle.details!.towingWeightBrakes!.toStringAsFixed(0)} kg',
                          });
                        if (vehicle.details!.engineDisplacement != null &&
                            vehicle.details!.engineDisplacement! > 0)
                          specItems.add({
                            'label': specL10n.engineDisplacementCc,
                            'value':
                                '${vehicle.details!.engineDisplacement!.toStringAsFixed(0)} cc',
                          });
                        if (vehicle.details!.engineCode != null)
                          specItems.add({
                            'label': specL10n.engineCode,
                            'value': vehicle.details!.engineCode!,
                          });
                        if (vehicle.details!.engineCylinders != null &&
                            vehicle.details!.engineCylinders! > 0)
                          specItems.add({
                            'label': specL10n.engineCylinders,
                            'value':
                                vehicle.details!.engineCylinders.toString(),
                          });
                        if (vehicle.details!.doors != null &&
                            vehicle.details!.doors! > 0)
                          specItems.add({
                            'label': specL10n.doors,
                            'value': vehicle.details!.doors.toString(),
                          });
                        if (vehicle.details!.minimumSeats != null &&
                            vehicle.details!.minimumSeats! > 0)
                          specItems.add({
                            'label': specL10n.minimumSeats,
                            'value':
                                vehicle.details!.minimumSeats.toString(),
                          });
                        if (vehicle.details!.maximumSeats != null &&
                            vehicle.details!.maximumSeats! > 0)
                          specItems.add({
                            'label': specL10n.maximumSeats,
                            'value':
                                vehicle.details!.maximumSeats.toString(),
                          });
                        if (vehicle.details!.topSpeed != null &&
                            vehicle.details!.topSpeed! > 0)
                          specItems.add({
                            'label': specL10n.topSpeedKmh,
                            'value':
                                '${vehicle.details!.topSpeed!.toStringAsFixed(0)} km/h',
                          });
                        if (vehicle.fuelEfficiency != null)
                          specItems.add({
                            'label': specL10n.fuelEfficiency,
                            'value': '${vehicle.fuelEfficiency} km/l',
                          });
                        if (vehicle.details!.airbags != null &&
                            vehicle.details!.airbags! > 0)
                          specItems.add({
                            'label': specL10n.airbags,
                            'value': vehicle.details!.airbags.toString(),
                          });
                        if (vehicle.details!.ncapFive != null)
                          specItems.add({
                            'label': specL10n.ncapFiveStar,
                            'value':
                                vehicle.details!.ncapFive! ? specL10n.yes : specL10n.no,
                          });
                        if (vehicle.details!.integratedChildSeats != null &&
                            vehicle.details!.integratedChildSeats! > 0)
                          specItems.add({
                            'label': specL10n.integratedChildSeats,
                            'value': vehicle.details!.integratedChildSeats
                                .toString(),
                          });
                        if (vehicle.details!.seatBeltAlarms != null &&
                            vehicle.details!.seatBeltAlarms! > 0)
                          specItems.add({
                            'label': specL10n.seatBeltAlarms,
                            'value':
                                vehicle.details!.seatBeltAlarms.toString(),
                          });
                        final euronomDisplay = vehicle.details!.euronomName ??
                            (vehicle.details!.euronomId != null
                                ? vehicle.details!.euronomId.toString()
                                : null);
                        if (euronomDisplay != null)
                          specItems.add({
                            'label': specL10n.euroNorm,
                            'value': euronomDisplay,
                          });
                        if (vehicle.details!.wheels != null)
                          specItems.add({
                            'label': specL10n.wheels,
                            'value': vehicle.details!.wheels!,
                          });
                        if (vehicle.details!.axles != null &&
                            vehicle.details!.axles! > 0)
                          specItems.add({
                            'label': specL10n.axles,
                            'value': vehicle.details!.axles.toString(),
                          });
                        if (vehicle.details!.driveAxles != null &&
                            vehicle.details!.driveAxles! > 0)
                          specItems.add({
                            'label': specL10n.driveAxles,
                            'value':
                                vehicle.details!.driveAxles.toString(),
                          });
                        if (vehicle.details!.wheelbase != null &&
                            vehicle.details!.wheelbase! > 0)
                          specItems.add({
                            'label': specL10n.wheelbase,
                            'value':
                                '${vehicle.details!.wheelbase!.toStringAsFixed(0)} mm',
                          });
                        if (vehicle.details!.category != null)
                          specItems.add({
                            'label': specL10n.category,
                            'value': vehicle.details!.category!,
                          });

                        // Long-text fields shown as full-width rows (not in grid)
                        final extraEquipmentText = vehicle.details!
                                    .extraEquipment != null &&
                                vehicle.details!.extraEquipment!.isNotEmpty
                            ? vehicle.details!.extraEquipment
                            : null;
                        final dispensationsText =
                            vehicle.details!.dispensations != null &&
                                    vehicle.details!.dispensations!.isNotEmpty
                                ? vehicle.details!.dispensations
                                : null;
                        final permitsText = vehicle.details!.permits != null &&
                                vehicle.details!.permits!.isNotEmpty
                            ? vehicle.details!.permits
                            : null;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
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
                            ),
                            if (extraEquipmentText != null) ...[
                              const SizedBox(height: 12),
                              _buildSpecItemFullWidth(
                                context,
                                specL10n.extraEquipment,
                                extraEquipmentText,
                                isDark,
                              ),
                            ],
                            if (dispensationsText != null) ...[
                              const SizedBox(height: 12),
                              _buildSpecItemFullWidth(
                                context,
                                specL10n.dispensations,
                                dispensationsText,
                                isDark,
                              ),
                            ],
                            if (permitsText != null) ...[
                              const SizedBox(height: 12),
                              _buildSpecItemFullWidth(
                                context,
                                specL10n.permits,
                                permitsText,
                                isDark,
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),

                // Pricing Card (Modern Gradient) - kept non-expandable for prominence
                
                // Listing Information Card
                if (vehicle.publishedAt != null)
                  DetailSectionCard(
                    title: l10n.listingInformation,
                    isDark: isDark,
                    initiallyExpanded: false,
                    items: [
                      DetailItem(
                        label: l10n.addedToListing,
                        value: _formatDaysAgo(context, vehicle.publishedAt),
                      ),
                    ],
                  ),

                // Interested? Section (hidden for own listing)
                if (!_isOwnListing(vehicle))
                  _buildInterestedSection(context, isDark, vehicle),

                const SizedBox(height: 24),
              ],
            ),
          );
        }),
      );
    });
  }

  Widget _buildContactCtaAtTop(
      BuildContext context, VehicleDetailModel vehicle, bool isDark) {
    final hasContact = vehicle.user != null || vehicle.dealerId != null;
    if (!hasContact) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showContactActionsBottomSheet(context, vehicle, isDark),
          borderRadius: BorderRadius.circular(16),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 56),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.85),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.contact_phone_outlined,
                  size: 24,
                  color: AppColors.primaryForeground,
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    AppLocalizations.of(context)!.contactSeller,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryForeground,
                      letterSpacing: 0.2,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: AppColors.primaryForeground.withOpacity(0.9),
                ),
              ],
            ),
          ),
        ),
        ),
      ),
    );
  }

  void _showContactActionsBottomSheet(
      BuildContext context, VehicleDetailModel vehicle, bool isDark) {
    final hasContact = vehicle.user != null || vehicle.dealerId != null;
    if (!hasContact) return;

    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 12),
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark
                        ? Colors.white.withOpacity(0.3)
                        : Colors.black.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 8),
                child: Text(
                  AppLocalizations.of(context)!.contactSeller,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                child: Column(
                  children: [
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.chat_bubble_outline,
                      label: AppLocalizations.of(context)!.sendEnquiry,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.enquiry),
                    ),
                    const SizedBox(height: 12),
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.swap_horiz,
                      label: AppLocalizations.of(context)!.exchangeRequest,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.exchange),
                    ),
                    const SizedBox(height: 12),
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.directions_car_outlined,
                      label: AppLocalizations.of(context)!.requestTestDrive,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.testDrive),
                    ),
                    const SizedBox(height: 12),
                    _buildContactSheetTile(
                      context: context,
                      vehicle: vehicle,
                      isDark: isDark,
                      icon: Icons.attach_money,
                      label: AppLocalizations.of(context)!.priceNegotiation,
                      onTap: () => _openEnquiryForm(context, vehicle, EnquiryFormType.priceNegotiation),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void _openEnquiryForm(
    BuildContext context,
    VehicleDetailModel vehicle,
    EnquiryFormType type,
  ) {
    Get.back();
    final maxHeight = MediaQuery.of(context).size.height * 0.8;
    Get.bottomSheet(
      ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: EnquiryFormBottomSheet(
          vehicleId: vehicle.id,
          vehicleTitle: vehicle.title,
          type: type,
          brandName: vehicle.brandName,
          modelName: vehicle.modelName,
          price: vehicle.price,
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Widget _buildContactSheetTile({
    required BuildContext context,
    required VehicleDetailModel vehicle,
    required bool isDark,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.surfaceDark : AppColors.mutedBackground,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 22, color: AppColors.primary),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textDark : AppColors.textLight,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchEmail(BuildContext context, VehicleDetailModel vehicle) async {
    final l10n = AppLocalizations.of(context)!;
    final email = vehicle.user?.email;
    if (email == null || email.trim().isEmpty) {
      Get.snackbar(
        l10n.sendEmail,
        l10n.noEmailAddressAvailable,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    // Best-effort lead tracking (non-blocking)
    try {
      await VehicleRepository().createLead(vehicle.id, 'email_clicked');
    } catch (_) {}
    final subject = Uri.encodeComponent('Enquiry about: ${vehicle.title}');
    final body = Uri.encodeComponent(
      'Hello,\n\nI am interested in this vehicle: ${vehicle.title}\n\nPlease contact me with more information.\n\nThank you!',
    );
    final uri = Uri.parse('mailto:${email.trim()}?subject=$subject&body=$body');
    try {
      if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
        Get.snackbar(
          l10n.sendEmail,
          l10n.couldNotOpenEmailApp,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        l10n.sendEmail,
        l10n.couldNotOpenEmailApp,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  Widget _buildSellerInfoCard(BuildContext context, VehicleDetailModel vehicle, bool isDark) {
    final l10n = AppLocalizations.of(context)!;
    final sellerPhone = vehicle.details?.sellerPhone ?? vehicle.user?.phone;
    final sellerAddress =
        vehicle.sellerAddress ?? vehicle.details?.sellerAddress;
    final sellerPostcode =
        vehicle.sellerPostcode ?? vehicle.details?.sellerPostcode;
    final sellerName = vehicle.user?.name ?? l10n.unknownSeller;

    return ExpandableSectionCard(
      title: l10n.sellerInformation,
      icon: Icons.person_outline,
      isDark: isDark,
      initiallyExpanded: false,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
                        l10n.seller,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? AppColors.mutedDark
                              : AppColors.mutedLight,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        sellerName,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                          l10n.location,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? AppColors.mutedDark
                                : AppColors.mutedLight,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(height: 4),
                        if (sellerAddress != null)
                          Text(
                            sellerAddress,
                            style: TextStyle(
                              fontSize: 14,
                              color: isDark
                                  ? AppColors.textDark
                                  : AppColors.textLight,
                            ),
                          ),
                        if (sellerPostcode != null)
                          Text(
                            sellerPostcode,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
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
              child: _PhoneNumberWidget(
                phone: sellerPhone,
                isDark: isDark,
                context: context,
                vehicleId: vehicle.id,
              ),
            ),
          ],
          if (vehicle.user?.email != null &&
              vehicle.user!.email.trim().isNotEmpty) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark
                    ? Colors.white.withOpacity(0.05)
                    : AppColors.mutedBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: InkWell(
                onTap: () => _launchEmail(context, vehicle),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.email_outlined,
                        size: 20,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.emailLabel,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isDark
                                  ? AppColors.mutedDark
                                  : AppColors.mutedLight,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.sendEmail,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildInterestedSection(BuildContext context, bool isDark, VehicleDetailModel vehicle) {
    final l10n = AppLocalizations.of(context)!;
    return ExpandableSectionCard(
      title: l10n.interestedTitle,
      icon: Icons.favorite_outline,
      isDark: isDark,
      initiallyExpanded: false,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          Text(
            l10n.takeNextSteps,
            style: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
            ),
          ),
          const SizedBox(height: 16),
          // Modern bullet points
          _buildModernBulletPoint(
            Icons.history,
            l10n.requestVehicleHistory,
            isDark,
          ),
          _buildModernBulletPoint(
            Icons.check_circle_outline,
            l10n.scheduleInspection,
            isDark,
          ),
          _buildModernBulletPoint(
            Icons.account_balance_wallet_outlined,
            l10n.discussFinancing,
            isDark,
          ),
          _buildModernBulletPoint(
            Icons.directions_car_outlined,
            l10n.arrangeTestDrive,
            isDark,
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
            child: Icon(icon, size: 18, color: AppColors.primary),
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

  Widget _buildSpecItem(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
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

  /// Full-width spec row for long text (e.g. Extra Equipment, Dispensations, Permits).
  Widget _buildSpecItemFullWidth(
    BuildContext context,
    String label,
    String value,
    bool isDark,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isDark ? AppColors.mutedDark : AppColors.mutedLight,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isDark ? AppColors.textDark : AppColors.textLight,
              height: 1.4,
            ),
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

  /// Format ISO date string to readable format (e.g., "November 1, 2004") using locale
  String _formatDate(BuildContext context, String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final date = DateTime.parse(dateString);
      final locale = Localizations.localeOf(context).toString();
      return intl.DateFormat('MMMM d, y', locale).format(date);
    } catch (e) {
      return dateString;
    }
  }

  /// Calculate "X days ago" from published_at date
  String _formatDaysAgo(BuildContext context, String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final l10n = AppLocalizations.of(context)!;
      final date = DateTime.parse(dateString);
      final now = DateTime.now();
      final difference = now.difference(date);
      final days = difference.inDays;
      if (days == 0) {
        return l10n.today;
      } else if (days == 1) {
        return l10n.oneDayAgo;
      } else {
        return l10n.daysAgo(days);
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
  final BuildContext context;
  final int vehicleId;

  const _PhoneNumberWidget({
    required this.phone,
    required this.isDark,
    required this.context,
    required this.vehicleId,
  });

  @override
  State<_PhoneNumberWidget> createState() => _PhoneNumberWidgetState();
}

class _PhoneNumberWidgetState extends State<_PhoneNumberWidget> {
  bool _showPhone = false;

  Future<void> _launchPhone(String phone) async {
    final l10n = AppLocalizations.of(widget.context)!;
    final Uri phoneUri = Uri.parse('tel:$phone');
    try {
      try {
        await VehicleRepository().createLead(widget.vehicleId, 'phone_shown');
      } catch (_) {}
      if (!await launchUrl(phoneUri, mode: LaunchMode.platformDefault)) {
        Get.snackbar(
          l10n.error,
          l10n.couldNotOpenPhoneDialer,
          snackPosition: SnackPosition.TOP,
        );
      }
    } catch (e) {
      Get.snackbar(
        l10n.error,
        l10n.couldNotOpenPhoneDialer,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(widget.context)!;
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
                        l10n.phone,
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
                        l10n.phone,
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
                            l10n.showPhoneNumber,
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
