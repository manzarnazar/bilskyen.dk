class VehicleDetailModel {
  final int id;
  final String title;
  final String? registration;
  final String? vin;
  final int? dealerId;
  final int? userId;
  final int? categoryId;
  final int? brandId;
  final int? modelId;
  final int? modelYearId;
  final int? fuelTypeId;
  final int? vehicleListStatusId;
  final int? listingTypeId;
  final int? kmDriven;
  final int price;
  final String? batteryCapacity;
  final int? rangeKm;
  final String? chargingType;
  final double? enginePower;
  final double? towingWeight;
  final String? ownershipTax;
  final String? firstRegistrationDate;
  final String? version;
  final int? gearTypeId;
  final String? fuelEfficiency;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;
  final String? categoryName;
  final String? brandName;
  final String? modelName;
  final String? modelYearName;
  final String? fuelTypeName;
  final String? gearTypeName;
  final double? enginePowerHp;
  final String? vehicleListStatusName;
  final String? listingTypeName;
  final VehicleUser? user;
  final List<VehicleImage> images;
  final VehicleDetails? details;
  final List<VehicleEquipment> equipment;

  VehicleDetailModel({
    required this.id,
    required this.title,
    this.registration,
    this.vin,
    this.dealerId,
    this.userId,
    this.categoryId,
    this.brandId,
    this.modelId,
    this.modelYearId,
    this.fuelTypeId,
    this.vehicleListStatusId,
    this.listingTypeId,
    this.kmDriven,
    required this.price,
    this.batteryCapacity,
    this.rangeKm,
    this.chargingType,
    this.enginePower,
    this.towingWeight,
    this.ownershipTax,
    this.firstRegistrationDate,
    this.version,
    this.gearTypeId,
    this.fuelEfficiency,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categoryName,
    this.brandName,
    this.modelName,
    this.modelYearName,
    this.fuelTypeName,
    this.gearTypeName,
    this.enginePowerHp,
    this.vehicleListStatusName,
    this.listingTypeName,
    this.user,
    required this.images,
    this.details,
    required this.equipment,
  });

  factory VehicleDetailModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailModel(
      id: json['id'] as int,
      title: json['title'] as String,
      registration: json['registration'] as String?,
      vin: json['vin'] as String?,
      dealerId: json['dealer_id'] as int?,
      userId: json['user_id'] as int?,
      categoryId: json['category_id'] as int?,
      brandId: json['brand_id'] as int?,
      modelId: json['model_id'] as int?,
      modelYearId: json['model_year_id'] as int?,
      fuelTypeId: json['fuel_type_id'] as int?,
      vehicleListStatusId: json['vehicle_list_status_id'] as int?,
      listingTypeId: json['listing_type_id'] as int?,
      kmDriven: json['km_driven'] as int?,
      price: json['price'] as int,
      batteryCapacity: json['battery_capacity'] as String?,
      rangeKm: json['range_km'] as int?,
      chargingType: json['charging_type'] as String?,
      enginePower: (json['engine_power'] as num?)?.toDouble(),
      towingWeight: (json['towing_weight'] as num?)?.toDouble(),
      ownershipTax: json['ownership_tax'] as String?,
      firstRegistrationDate: json['first_registration_date'] as String?,
      version: json['version'] as String?,
      gearTypeId: json['gear_type_id'] as int?,
      fuelEfficiency: json['fuel_efficiency'] as String?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      categoryName: json['category_name'] as String?,
      brandName: json['brand_name'] as String?,
      modelName: json['model_name'] as String?,
      modelYearName: json['model_year_name'] as String?,
      fuelTypeName: json['fuel_type_name'] as String?,
      gearTypeName: json['gear_type_name'] as String?,
      enginePowerHp: (json['engine_power_hp'] as num?)?.toDouble(),
      vehicleListStatusName: json['vehicle_list_status_name'] as String?,
      listingTypeName: json['listing_type_name'] as String?,
      user: json['user'] != null
          ? VehicleUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((img) => VehicleImage.fromJson(img as Map<String, dynamic>))
              .toList() ??
          [],
      details: json['details'] != null
          ? VehicleDetails.fromJson(json['details'] as Map<String, dynamic>)
          : null,
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((eq) => VehicleEquipment.fromJson(eq as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class VehicleUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? postcode;
  final String? emailVerifiedAt;
  final String? createdAt;
  final String? updatedAt;

  VehicleUser({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.postcode,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleUser.fromJson(Map<String, dynamic> json) {
    return VehicleUser(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      postcode: json['postcode'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class VehicleImage {
  final int id;
  final int vehicleId;
  final String imagePath;
  final String thumbnailPath;
  final int sortOrder;

  VehicleImage({
    required this.id,
    required this.vehicleId,
    required this.imagePath,
    required this.thumbnailPath,
    required this.sortOrder,
  });

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      imagePath: json['image_path'] as String,
      thumbnailPath: json['thumbnail_path'] as String,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  /// Build full image URL
  String get imageUrl => 'https://bilskyen.dk/storage/$imagePath';

  /// Build full thumbnail URL
  String get thumbnailUrl => 'https://bilskyen.dk/storage/$thumbnailPath';
}

class VehicleDetails {
  final int id;
  final int vehicleId;
  final String? vehicleExternalId;
  final String? description;
  final int? viewsCount;
  final String? vinLocation;
  final int? typeId;
  final String? typeName;
  final String? registrationStatus;
  final String? registrationStatusUpdatedDate;
  final String? expireDate;
  final String? statusUpdatedDate;
  final double? totalWeight;
  final double? vehicleWeight;
  final double? technicalTotalWeight;
  final bool? coupling;
  final double? towingWeightBrakes;
  final double? minimumWeight;
  final double? grossCombinationWeight;
  final double? engineDisplacement;
  final int? engineCylinders;
  final String? engineCode;
  final String? category;
  final String? lastInspectionDate;
  final String? lastInspectionResult;
  final int? lastInspectionOdometer;
  final String? typeApprovalCode;
  final double? topSpeed;
  final int? doors;
  final int? minimumSeats;
  final int? maximumSeats;
  final String? wheels;
  final String? extraEquipment;
  final int? axles;
  final int? driveAxles;
  final double? wheelbase;
  final String? leasingPeriodStart;
  final String? leasingPeriodEnd;
  final int? useId;
  final int? colorId;
  final int? bodyTypeId;
  final int? variantId;
  final String? dispensations;
  final String? permits;
  final bool? ncapFive;
  final int? airbags;
  final int? integratedChildSeats;
  final int? seatBeltAlarms;
  final int? euronomId;
  final String? servicebog;
  final int? priceTypeId;
  final int? conditionId;
  final int? salesTypeId;
  final String? sellerPhone;
  final String? sellerAddress;
  final String? sellerPostcode;
  final String? annualTax;
  final String? owners;
  final String? createdAt;
  final String? updatedAt;
  final String? typeNameResolved;
  final String? useName;
  final String? colorName;
  final String? bodyTypeName;
  final String? priceTypeName;
  final String? conditionName;
  final String? salesTypeName;

  VehicleDetails({
    required this.id,
    required this.vehicleId,
    this.vehicleExternalId,
    this.description,
    this.viewsCount,
    this.vinLocation,
    this.typeId,
    this.typeName,
    this.registrationStatus,
    this.registrationStatusUpdatedDate,
    this.expireDate,
    this.statusUpdatedDate,
    this.totalWeight,
    this.vehicleWeight,
    this.technicalTotalWeight,
    this.coupling,
    this.towingWeightBrakes,
    this.minimumWeight,
    this.grossCombinationWeight,
    this.engineDisplacement,
    this.engineCylinders,
    this.engineCode,
    this.category,
    this.lastInspectionDate,
    this.lastInspectionResult,
    this.lastInspectionOdometer,
    this.typeApprovalCode,
    this.topSpeed,
    this.doors,
    this.minimumSeats,
    this.maximumSeats,
    this.wheels,
    this.extraEquipment,
    this.axles,
    this.driveAxles,
    this.wheelbase,
    this.leasingPeriodStart,
    this.leasingPeriodEnd,
    this.useId,
    this.colorId,
    this.bodyTypeId,
    this.variantId,
    this.dispensations,
    this.permits,
    this.ncapFive,
    this.airbags,
    this.integratedChildSeats,
    this.seatBeltAlarms,
    this.euronomId,
    this.servicebog,
    this.priceTypeId,
    this.conditionId,
    this.salesTypeId,
    this.sellerPhone,
    this.sellerAddress,
    this.sellerPostcode,
    this.annualTax,
    this.owners,
    this.createdAt,
    this.updatedAt,
    this.typeNameResolved,
    this.useName,
    this.colorName,
    this.bodyTypeName,
    this.priceTypeName,
    this.conditionName,
    this.salesTypeName,
  });

  factory VehicleDetails.fromJson(Map<String, dynamic> json) {
    return VehicleDetails(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      vehicleExternalId: json['vehicle_external_id'] as String?,
      description: json['description'] as String?,
      viewsCount: json['views_count'] as int?,
      vinLocation: json['vin_location'] as String?,
      typeId: json['type_id'] as int?,
      typeName: json['type_name'] as String?,
      registrationStatus: json['registration_status'] as String?,
      registrationStatusUpdatedDate: json['registration_status_updated_date'] as String?,
      expireDate: json['expire_date'] as String?,
      statusUpdatedDate: json['status_updated_date'] as String?,
      totalWeight: (json['total_weight'] as num?)?.toDouble(),
      vehicleWeight: (json['vehicle_weight'] as num?)?.toDouble(),
      technicalTotalWeight: (json['technical_total_weight'] as num?)?.toDouble(),
      coupling: json['coupling'] as bool?,
      towingWeightBrakes: (json['towing_weight_brakes'] as num?)?.toDouble(),
      minimumWeight: (json['minimum_weight'] as num?)?.toDouble(),
      grossCombinationWeight: (json['gross_combination_weight'] as num?)?.toDouble(),
      engineDisplacement: (json['engine_displacement'] as num?)?.toDouble(),
      engineCylinders: json['engine_cylinders'] as int?,
      engineCode: json['engine_code'] as String?,
      category: json['category'] as String?,
      lastInspectionDate: json['last_inspection_date'] as String?,
      lastInspectionResult: json['last_inspection_result'] as String?,
      lastInspectionOdometer: json['last_inspection_odometer'] as int?,
      typeApprovalCode: json['type_approval_code'] as String?,
      topSpeed: (json['top_speed'] as num?)?.toDouble(),
      doors: json['doors'] as int?,
      minimumSeats: json['minimum_seats'] as int?,
      maximumSeats: json['maximum_seats'] as int?,
      wheels: json['wheels'] as String?,
      extraEquipment: json['extra_equipment'] as String?,
      axles: json['axles'] as int?,
      driveAxles: json['drive_axles'] as int?,
      wheelbase: (json['wheelbase'] as num?)?.toDouble(),
      leasingPeriodStart: json['leasing_period_start'] as String?,
      leasingPeriodEnd: json['leasing_period_end'] as String?,
      useId: json['use_id'] as int?,
      colorId: json['color_id'] as int?,
      bodyTypeId: json['body_type_id'] as int?,
      variantId: json['variant_id'] as int?,
      dispensations: json['dispensations'] as String?,
      permits: json['permits'] as String?,
      ncapFive: json['ncap_five'] as bool?,
      airbags: json['airbags'] as int?,
      integratedChildSeats: json['integrated_child_seats'] as int?,
      seatBeltAlarms: json['seat_belt_alarms'] as int?,
      euronomId: json['euronom_id'] as int?,
      servicebog: json['servicebog'] as String?,
      priceTypeId: json['price_type_id'] as int?,
      conditionId: json['condition_id'] as int?,
      salesTypeId: json['sales_type_id'] as int?,
      sellerPhone: json['seller_phone'] as String?,
      sellerAddress: json['seller_address'] as String?,
      sellerPostcode: json['seller_postcode'] as String?,
      annualTax: json['annual_tax'] as String?,
      owners: json['owners'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      typeNameResolved: json['type_name_resolved'] as String?,
      useName: json['use_name'] as String?,
      colorName: json['color_name'] as String?,
      bodyTypeName: json['body_type_name'] as String?,
      priceTypeName: json['price_type_name'] as String?,
      conditionName: json['condition_name'] as String?,
      salesTypeName: json['sales_type_name'] as String?,
    );
  }
}

class VehicleEquipment {
  final int id;
  final String name;
  final int equipmentTypeId;

  VehicleEquipment({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
  });

  factory VehicleEquipment.fromJson(Map<String, dynamic> json) {
    return VehicleEquipment(
      id: json['id'] as int,
      name: json['name'] as String,
      equipmentTypeId: json['equipment_type_id'] as int,
    );
  }
}
