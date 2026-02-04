import '../../utils/validation_utils.dart';

class SellVehicleRequestModel {
  // Required fields
  final String registration;
  final int price;
  final int fuelTypeId;
  final int kmDriven;

  // Optional basic fields
  final String? title;
  final String? vin;
  final int? mileage;
  final int? listingTypeId;
  final int? categoryId;
  final int? brandId;
  final int? modelId;
  final int? modelYearId;
  final String? brandName;
  final String? modelName;
  final String? modelYearName;
  final String? modelYear;

  // Vehicle details
  final String? description;
  final String? vinLocation;
  final String? vehicleExternalId;
  final int? typeId;
  final String? typeName;
  final String? version;
  final String? registrationStatus;
  final String? registrationStatusUpdatedDate;
  final String? expireDate;
  final String? statusUpdatedDate;

  // Vehicle specifications
  final int? variantId;
  final String? variantName;
  final int? colorId;
  final int? useId;
  final int? bodyTypeId;
  final int? priceTypeId;
  final int? conditionId;
  final int? gearTypeId;
  final int? salesTypeId;

  // Dates
  final int? firstRegistrationMonth;
  final int? firstRegistrationYear;
  final String? firstRegistrationDate;
  final int? lastInspectionMonth;
  final int? lastInspectionYear;
  final String? lastInspectionDate;
  final String? lastInspectionResult;
  final int? lastInspectionOdometer;
  final String? leasingPeriodStart;
  final String? leasingPeriodEnd;

  // Weight and dimensions
  final int? totalWeight;
  final int? vehicleWeight;
  final int? technicalTotalWeight;
  final int? towingWeight;
  final int? towingWeightBrakes;
  final int? minimumWeight;
  final int? grossCombinationWeight;

  // Engine specifications
  final int? enginePower;
  final int? engineDisplacement;
  final int? engineCylinders;
  final String? engineCode;
  final double? fuelEfficiency;
  final String? euronorm;
  final int? euronomId;
  final String? euronomName;

  // Electric vehicle fields
  final int? batteryCapacity;
  final int? rangeKm;
  final String? chargingType;

  // Other specifications
  final int? ownershipTax;
  final double? annualTax;
  final int? doors;
  final int? minimumSeats;
  final int? maximumSeats;
  final int? topSpeed;
  final int? wheels;
  final int? axles;
  final int? driveAxles;
  final int? wheelbase;
  final String? category;
  final String? typeApprovalCode;
  final String? extraEquipment;
  final String? dispensations;
  final String? permits;
  final int? airbags;
  final int? integratedChildSeats;
  final int? seatBeltAlarms;
  final bool? ncapFive;
  final bool? coupling;

  // Equipment and features
  final List<int>? equipmentIds;
  final String? servicebog; // 'Yes', 'No', 'Default'

  // Seller information (these are handled separately, not sent to backend)
  final String? sellerPhone;
  final String? sellerAddress;
  final String? sellerPostcode;
  final int? planId;

  SellVehicleRequestModel({
    required this.registration,
    required this.price,
    required this.fuelTypeId,
    required this.kmDriven,
    this.title,
    this.vin,
    this.mileage,
    this.listingTypeId,
    this.categoryId,
    this.brandId,
    this.modelId,
    this.modelYearId,
    this.brandName,
    this.modelName,
    this.modelYearName,
    this.modelYear,
    this.description,
    this.vinLocation,
    this.vehicleExternalId,
    this.typeId,
    this.typeName,
    this.version,
    this.registrationStatus,
    this.registrationStatusUpdatedDate,
    this.expireDate,
    this.statusUpdatedDate,
    this.variantId,
    this.variantName,
    this.colorId,
    this.useId,
    this.bodyTypeId,
    this.priceTypeId,
    this.conditionId,
    this.gearTypeId,
    this.salesTypeId,
    this.firstRegistrationMonth,
    this.firstRegistrationYear,
    this.firstRegistrationDate,
    this.lastInspectionMonth,
    this.lastInspectionYear,
    this.lastInspectionDate,
    this.lastInspectionResult,
    this.lastInspectionOdometer,
    this.leasingPeriodStart,
    this.leasingPeriodEnd,
    this.totalWeight,
    this.vehicleWeight,
    this.technicalTotalWeight,
    this.towingWeight,
    this.towingWeightBrakes,
    this.minimumWeight,
    this.grossCombinationWeight,
    this.enginePower,
    this.engineDisplacement,
    this.engineCylinders,
    this.engineCode,
    this.fuelEfficiency,
    this.euronorm,
    this.euronomId,
    this.euronomName,
    this.batteryCapacity,
    this.rangeKm,
    this.chargingType,
    this.ownershipTax,
    this.annualTax,
    this.doors,
    this.minimumSeats,
    this.maximumSeats,
    this.topSpeed,
    this.wheels,
    this.axles,
    this.driveAxles,
    this.wheelbase,
    this.category,
    this.typeApprovalCode,
    this.extraEquipment,
    this.dispensations,
    this.permits,
    this.airbags,
    this.integratedChildSeats,
    this.seatBeltAlarms,
    this.ncapFive,
    this.coupling,
    this.equipmentIds,
    this.servicebog,
    this.sellerPhone,
    this.sellerAddress,
    this.sellerPostcode,
    this.planId,
  });

  /// Converts month/year to date string if both are provided
  /// Returns the provided date string if available, otherwise converts from month/year
  String? _getFirstRegistrationDate() {
    if (firstRegistrationDate != null) {
      return firstRegistrationDate;
    }
    return ValidationUtils.formatDateFromMonthYear(
      firstRegistrationMonth,
      firstRegistrationYear,
    );
  }

  /// Converts month/year to date string if both are provided
  String? _getLastInspectionDate() {
    if (lastInspectionDate != null) {
      return lastInspectionDate;
    }
    return ValidationUtils.formatDateFromMonthYear(
      lastInspectionMonth,
      lastInspectionYear,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      // Required fields
      'registration': registration,
      'price': price,
      'fuel_type_id': fuelTypeId,
      'km_driven': kmDriven,
    };

    // Optional fields
    if (title != null && title!.isNotEmpty) json['title'] = title;

    // Optional basic fields
    if (vin != null) json['vin'] = vin;
    if (mileage != null) json['mileage'] = mileage;
    if (listingTypeId != null) json['listing_type_id'] = listingTypeId;
    if (categoryId != null) json['category_id'] = categoryId;
    if (brandId != null) json['brand_id'] = brandId;
    if (modelId != null) json['model_id'] = modelId;
    if (modelYearId != null) json['model_year_id'] = modelYearId;
    if (brandName != null) json['brand_name'] = brandName;
    if (modelName != null) json['model_name'] = modelName;
    if (modelYearName != null) json['model_year_name'] = modelYearName;
    if (modelYear != null) json['model_year'] = modelYear;

    // Vehicle details
    if (description != null) json['description'] = description;
    if (vinLocation != null) json['vin_location'] = vinLocation;
    if (vehicleExternalId != null)
      json['vehicle_external_id'] = vehicleExternalId;
    if (typeId != null) json['type_id'] = typeId;
    if (typeName != null) json['type_name'] = typeName;
    if (version != null) json['version'] = version;
    if (registrationStatus != null)
      json['registration_status'] = registrationStatus;
    if (registrationStatusUpdatedDate != null)
      json['registration_status_updated_date'] = registrationStatusUpdatedDate;
    if (expireDate != null) json['expire_date'] = expireDate;
    if (statusUpdatedDate != null)
      json['status_updated_date'] = statusUpdatedDate;

    // Vehicle specifications
    if (variantId != null) json['variant_id'] = variantId;
    if (variantName != null) json['variant_name'] = variantName;
    if (colorId != null) json['color_id'] = colorId;
    if (useId != null) json['use_id'] = useId;
    if (bodyTypeId != null) json['body_type_id'] = bodyTypeId;
    if (priceTypeId != null) json['price_type_id'] = priceTypeId;
    if (conditionId != null) json['condition_id'] = conditionId;
    if (gearTypeId != null) json['gear_type_id'] = gearTypeId;
    if (salesTypeId != null) json['sales_type_id'] = salesTypeId;

    // Dates - convert month/year to date strings
    final firstRegDate = _getFirstRegistrationDate();
    if (firstRegDate != null) {
      json['first_registration_date'] = firstRegDate;
    }

    final lastInspDate = _getLastInspectionDate();
    if (lastInspDate != null) {
      json['last_inspection_date'] = lastInspDate;
    }
    if (lastInspectionResult != null)
      json['last_inspection_result'] = lastInspectionResult;
    if (lastInspectionOdometer != null)
      json['last_inspection_odometer'] = lastInspectionOdometer;
    if (leasingPeriodStart != null)
      json['leasing_period_start'] = leasingPeriodStart;
    if (leasingPeriodEnd != null) json['leasing_period_end'] = leasingPeriodEnd;

    // Weight and dimensions
    if (totalWeight != null) json['total_weight'] = totalWeight;
    if (vehicleWeight != null) json['vehicle_weight'] = vehicleWeight;
    if (technicalTotalWeight != null)
      json['technical_total_weight'] = technicalTotalWeight;
    if (towingWeight != null) json['towing_weight'] = towingWeight;
    if (towingWeightBrakes != null)
      json['towing_weight_brakes'] = towingWeightBrakes;
    if (minimumWeight != null) json['minimum_weight'] = minimumWeight;
    if (grossCombinationWeight != null)
      json['gross_combination_weight'] = grossCombinationWeight;

    // Engine specifications
    if (enginePower != null) json['engine_power'] = enginePower;
    if (engineDisplacement != null)
      json['engine_displacement'] = engineDisplacement;
    if (engineCylinders != null) json['engine_cylinders'] = engineCylinders;
    if (engineCode != null) json['engine_code'] = engineCode;
    if (fuelEfficiency != null) json['fuel_efficiency'] = fuelEfficiency;
    if (euronorm != null) json['euronorm'] = euronorm;
    if (euronomId != null) json['euronom_id'] = euronomId;
    if (euronomName != null) json['euronom_name'] = euronomName;

    // Electric vehicle fields
    if (batteryCapacity != null) json['battery_capacity'] = batteryCapacity;
    if (rangeKm != null) json['range_km'] = rangeKm;
    if (chargingType != null) json['charging_type'] = chargingType;

    // Other specifications
    if (ownershipTax != null) json['ownership_tax'] = ownershipTax;
    if (annualTax != null) json['annual_tax'] = annualTax;
    if (doors != null) json['doors'] = doors;
    if (minimumSeats != null) json['minimum_seats'] = minimumSeats;
    if (maximumSeats != null) json['maximum_seats'] = maximumSeats;
    if (topSpeed != null) json['top_speed'] = topSpeed;
    if (wheels != null) json['wheels'] = wheels;
    if (axles != null) json['axles'] = axles;
    if (driveAxles != null) json['drive_axles'] = driveAxles;
    if (wheelbase != null) json['wheelbase'] = wheelbase;
    if (category != null) json['category'] = category;
    if (typeApprovalCode != null)
      json['type_approval_code'] = typeApprovalCode;
    if (extraEquipment != null) json['extra_equipment'] = extraEquipment;
    // Handle dispensations and permits - convert arrays to JSON strings if needed
    if (dispensations != null) {
      // If it's already a JSON string, use it; otherwise convert array to JSON
      json['dispensations'] = dispensations;
    }
    if (permits != null) {
      // If it's already a JSON string, use it; otherwise convert array to JSON
      json['permits'] = permits;
    }
    if (airbags != null) json['airbags'] = airbags;
    if (integratedChildSeats != null)
      json['integrated_child_seats'] = integratedChildSeats;
    if (seatBeltAlarms != null) json['seat_belt_alarms'] = seatBeltAlarms;
    // Convert booleans to integers (0 or 1)
    if (ncapFive != null) json['ncap_five'] = ncapFive! ? 1 : 0;
    if (coupling != null) json['coupling'] = coupling! ? 1 : 0;

    // Equipment and features
    if (equipmentIds != null && equipmentIds!.isNotEmpty)
      json['equipment_ids'] = equipmentIds;
    if (servicebog != null) json['servicebog'] = servicebog;

    // Seller information (required by backend)
    if (sellerPhone != null && sellerPhone!.isNotEmpty)
      json['seller_phone'] = sellerPhone;
    if (sellerAddress != null && sellerAddress!.isNotEmpty)
      json['seller_address'] = sellerAddress;
    if (sellerPostcode != null && sellerPostcode!.isNotEmpty)
      json['seller_postcode'] = sellerPostcode;

    // Note: plan_id is handled separately and not sent in the main request body

    return json;
  }
}
