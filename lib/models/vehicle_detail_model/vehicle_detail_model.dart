// Models aligned with Laravel VehicleDetailPresentationService::buildDetailPayload
// and VehicleController::show JSON (flat payload, no nested `details`).

class VehicleDetailModel {
  final int id;
  final String? slug;
  final String title;
  final String? registration;
  final String? vin;
  final int? dealerId;
  final int? userId;
  final int price;
  final String? description;
  final String? servicebog;
  final String? sellerPhone;
  final String? annualTax;
  final int? viewsCount;
  final String? engineType;
  final String? publishedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  final int? categoryId;
  final int? brandId;
  final int? modelId;
  final int? modelYearId;
  final int? fuelTypeId;
  final int? listStatusId;
  final int? listingTypeId;
  final int? salesTypeId;
  final int? priceTypeId;
  final int? conditionId;
  final int? gearTypeId;
  final int? colourId;
  final int? emissionNormId;

  final int? kmDriven;
  final double? kmPerLiter;
  final double? co2Emission;
  final double? electricalConsumption;
  final double? noxEmission;
  final double? fuelConsumptionWltp;
  final double? fuelConsumptionNedc;
  final double? enginePowerKw;
  final double? enginePowerHp;
  final int? engineSizeCc;
  final double? engineDisplacementLitres;
  final double? calculatedOwnershipTax;
  final double? towingWeight;
  final String? chargingType;
  final double? maxSpeed;
  final int? doorCount;
  final int? seatsMin;
  final int? seatsMax;
  final int? axleCount;
  final int? gearCount;
  final bool? ncapTest;
  final bool? particleFilter;
  final int? maximumWeightKg;
  final String? registrationStatus;
  final String? lastRegistrationChange;
  final String? firstRegistrationDate;
  final int? firstRegistrationYear;
  final String? lastInspectionDate;
  final String? productionDate;
  final String? modelYearName;
  final String? modelYearDisplay;

  final bool? isImport;
  final bool? isFactoryNew;

  final String? brandName;
  final String? modelName;
  final String? variantName;
  final String? fuelTypeName;
  final String? colourName;
  final String? bodyTypeName;
  final String? useName;
  final String? emissionNormName;
  final String? measurementNormName;
  final String? gearTypeName;
  final String? conditionName;
  final String? vehicleListStatusName;
  final String? listingTypeName;
  final String? salesTypeName;
  final String? priceTypeName;
  final String? categoryName;

  final String? batteryCapacity;
  final int? rangeKm;
  final String? address;
  final String? postcode;

  final double? wholesalePrice;
  final double? internalCostPrice;
  final double? priceWithoutTax;
  final bool? wholesalePriceIncludesDelivery;

  final bool? leasingEnabled;
  final String? leasingType;
  final String? leasingCustomerType;
  final double? leasingMonthlyPayment;
  final double? leasingFirstPayment;
  final double? leasingResidualValue;
  final int? leasingDuration;
  final int? leasingAnnualMileage;
  final double? leasingTotalCost;

  final double? technicalTotalWeightKg;

  final VehicleUser? user;
  final DealerDetail? dealer;
  final List<VehicleImage> images;
  final List<VehicleEquipment> equipment;
  final List<VehicleSpecification> specifications;
  final List<VehicleSpecDefinition> specDefinitions;
  final VehicleDmr? dmr;
  final String? sellerType;

  final String? contactWhatsapp;
  final String? sellerAddress;
  final String? sellerPostcode;

  /// Legacy: `fuel_efficiency` if API ever sends it; prefer [kmPerLiter].
  final String? fuelEfficiency;

  VehicleDetailModel({
    required this.id,
    this.slug,
    required this.title,
    this.registration,
    this.vin,
    this.dealerId,
    this.userId,
    required this.price,
    this.description,
    this.servicebog,
    this.sellerPhone,
    this.annualTax,
    this.viewsCount,
    this.engineType,
    this.publishedAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.categoryId,
    this.brandId,
    this.modelId,
    this.modelYearId,
    this.fuelTypeId,
    this.listStatusId,
    this.listingTypeId,
    this.salesTypeId,
    this.priceTypeId,
    this.conditionId,
    this.gearTypeId,
    this.colourId,
    this.emissionNormId,
    this.kmDriven,
    this.kmPerLiter,
    this.co2Emission,
    this.electricalConsumption,
    this.noxEmission,
    this.fuelConsumptionWltp,
    this.fuelConsumptionNedc,
    this.enginePowerKw,
    this.enginePowerHp,
    this.engineSizeCc,
    this.engineDisplacementLitres,
    this.calculatedOwnershipTax,
    this.towingWeight,
    this.chargingType,
    this.maxSpeed,
    this.doorCount,
    this.seatsMin,
    this.seatsMax,
    this.axleCount,
    this.gearCount,
    this.ncapTest,
    this.particleFilter,
    this.maximumWeightKg,
    this.registrationStatus,
    this.lastRegistrationChange,
    this.firstRegistrationDate,
    this.firstRegistrationYear,
    this.lastInspectionDate,
    this.productionDate,
    this.modelYearName,
    this.modelYearDisplay,
    this.isImport,
    this.isFactoryNew,
    this.brandName,
    this.modelName,
    this.variantName,
    this.fuelTypeName,
    this.colourName,
    this.bodyTypeName,
    this.useName,
    this.emissionNormName,
    this.measurementNormName,
    this.gearTypeName,
    this.conditionName,
    this.vehicleListStatusName,
    this.listingTypeName,
    this.salesTypeName,
    this.priceTypeName,
    this.categoryName,
    this.batteryCapacity,
    this.rangeKm,
    this.address,
    this.postcode,
    this.wholesalePrice,
    this.internalCostPrice,
    this.priceWithoutTax,
    this.wholesalePriceIncludesDelivery,
    this.leasingEnabled,
    this.leasingType,
    this.leasingCustomerType,
    this.leasingMonthlyPayment,
    this.leasingFirstPayment,
    this.leasingResidualValue,
    this.leasingDuration,
    this.leasingAnnualMileage,
    this.leasingTotalCost,
    this.technicalTotalWeightKg,
    this.user,
    this.dealer,
    required this.images,
    required this.equipment,
    required this.specifications,
    this.specDefinitions = const [],
    this.dmr,
    this.sellerType,
    this.contactWhatsapp,
    this.sellerAddress,
    this.sellerPostcode,
    this.fuelEfficiency,
  });

  /// Year label: prefers API `model_year_display` / `model_year_name`.
  String? get effectiveModelYearLabel =>
      (modelYearDisplay != null && modelYearDisplay!.isNotEmpty)
          ? modelYearDisplay
          : (modelYearName != null && modelYearName!.isNotEmpty)
              ? modelYearName
              : null;

  factory VehicleDetailModel.fromJson(Map<String, dynamic> json) {
    final dmrJson = json['dmr'];
    return VehicleDetailModel(
      id: json['id'] as int,
      slug: json['slug'] as String?,
      title: json['title'] as String,
      registration: json['registration'] as String?,
      vin: json['vin'] as String?,
      dealerId: json['dealer_id'] as int?,
      userId: json['user_id'] as int?,
      price: _parseInt(json['price']) ?? 0,
      description: json['description'] as String?,
      servicebog: json['servicebog'] as String?,
      sellerPhone: json['seller_phone'] as String?,
      annualTax: json['annual_tax']?.toString(),
      viewsCount: _parseInt(json['views_count']),
      engineType: json['engine_type'] as String?,
      publishedAt: json['published_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      deletedAt: json['deleted_at'] as String?,
      categoryId: _parseInt(json['category_id']),
      brandId: _parseInt(json['brand_id']),
      modelId: _parseInt(json['model_id']),
      modelYearId: _parseInt(json['model_year_id']),
      fuelTypeId: _parseInt(json['fuel_type_id']),
      listStatusId: _parseInt(json['list_status_id'] ?? json['vehicle_list_status_id']),
      listingTypeId: _parseInt(json['listing_type_id']),
      salesTypeId: _parseInt(json['sales_type_id']),
      priceTypeId: _parseInt(json['price_type_id']),
      conditionId: _parseInt(json['condition_id']),
      gearTypeId: _parseInt(json['gear_type_id']),
      colourId: _parseInt(json['colour_id']),
      emissionNormId: _parseInt(json['emission_norm_id']),
      kmDriven: _parseInt(json['km_driven']),
      kmPerLiter: _parseDouble(json['km_per_liter']),
      co2Emission: _parseDouble(json['co2_emission']),
      electricalConsumption: _parseDouble(json['electrical_consumption']),
      noxEmission: _parseDouble(json['nox_emission']),
      fuelConsumptionWltp: _parseDouble(json['fuel_consumption_wltp']),
      fuelConsumptionNedc: _parseDouble(json['fuel_consumption_nedc']),
      enginePowerKw: _parseDouble(json['engine_power_kw']),
      enginePowerHp: _parseDouble(json['engine_power_hp']),
      engineSizeCc: _parseInt(json['engine_size_cc']),
      engineDisplacementLitres: _parseDouble(json['engine_displacement_litres']),
      calculatedOwnershipTax: _parseDouble(json['calculated_ownership_tax'] ?? json['ownership_tax']),
      towingWeight: _parseDouble(json['towing_weight']),
      chargingType: json['charging_type'] as String?,
      maxSpeed: _parseDouble(json['max_speed']),
      doorCount: _parseInt(json['door_count']),
      seatsMin: _parseInt(json['seats_min']),
      seatsMax: _parseInt(json['seats_max']),
      axleCount: _parseInt(json['axle_count']),
      gearCount: _parseInt(json['gear_count']),
      ncapTest: _parseBool(json['ncap_test']),
      particleFilter: _parseBool(json['particle_filter']),
      maximumWeightKg: _parseInt(json['maximum_weight_kg']),
      registrationStatus: json['registration_status'] as String?,
      lastRegistrationChange: json['last_registration_change'] as String?,
      firstRegistrationDate: json['first_registration_date'] as String?,
      firstRegistrationYear: _parseInt(json['first_registration_year']),
      lastInspectionDate: json['last_inspection_date'] as String?,
      productionDate: json['production_date'] as String?,
      modelYearName: json['model_year_name']?.toString(),
      modelYearDisplay: json['model_year_display']?.toString(),
      isImport: _parseBool(json['is_import']),
      isFactoryNew: _parseBool(json['is_factory_new']),
      brandName: json['brand_name'] as String?,
      modelName: json['model_name'] as String?,
      variantName: json['variant_name'] as String?,
      fuelTypeName: json['fuel_type_name'] as String?,
      colourName: json['colour_name'] as String?,
      bodyTypeName: json['body_type_name'] as String?,
      useName: json['use_name'] as String?,
      emissionNormName: json['emission_norm_name'] as String?,
      measurementNormName: json['measurement_norm_name'] as String?,
      gearTypeName: json['gear_type_name'] as String?,
      conditionName: json['condition_name'] as String?,
      vehicleListStatusName: json['vehicle_list_status_name'] as String?,
      listingTypeName: json['listing_type_name'] as String?,
      salesTypeName: json['sales_type_name'] as String?,
      priceTypeName: json['price_type_name'] as String?,
      categoryName: json['category_name'] as String?,
      batteryCapacity: json['battery_capacity']?.toString(),
      rangeKm: _parseInt(json['range_km']),
      address: json['address'] as String?,
      postcode: json['postcode'] as String?,
      wholesalePrice: _parseDouble(json['wholesale_price']),
      internalCostPrice: _parseDouble(json['internal_cost_price']),
      priceWithoutTax: _parseDouble(json['price_without_tax']),
      wholesalePriceIncludesDelivery: _parseBool(json['wholesale_price_includes_delivery']),
      leasingEnabled: _parseBool(json['leasing_enabled']),
      leasingType: json['leasing_type'] as String?,
      leasingCustomerType: json['leasing_customer_type'] as String?,
      leasingMonthlyPayment: _parseDouble(json['leasing_monthly_payment']),
      leasingFirstPayment: _parseDouble(json['leasing_first_payment']),
      leasingResidualValue: _parseDouble(json['leasing_residual_value']),
      leasingDuration: _parseInt(json['leasing_duration']),
      leasingAnnualMileage: _parseInt(json['leasing_annual_mileage']),
      leasingTotalCost: _parseDouble(json['leasing_total_cost']),
      technicalTotalWeightKg: _parseDouble(json['technical_total_weight_kg']),
      user: json['user'] != null
          ? VehicleUser.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      dealer: json['dealer'] != null
          ? DealerDetail.fromJson(json['dealer'] as Map<String, dynamic>)
          : null,
      images: (json['images'] as List<dynamic>?)
              ?.map((img) => VehicleImage.fromJson(img as Map<String, dynamic>))
              .toList() ??
          [],
      equipment: (json['equipment'] as List<dynamic>?)
              ?.map((eq) => VehicleEquipment.fromJson(eq as Map<String, dynamic>))
              .toList() ??
          [],
      specifications: (json['specifications'] as List<dynamic>?)
              ?.map((s) => VehicleSpecification.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      specDefinitions: (json['spec_definitions'] as List<dynamic>?)
              ?.map((d) => VehicleSpecDefinition.fromJson(d as Map<String, dynamic>))
              .toList() ??
          [],
      dmr: dmrJson is Map<String, dynamic> ? VehicleDmr.fromJson(dmrJson) : null,
      sellerType: json['seller_type'] as String?,
      contactWhatsapp: json['contact_whatsapp'] as String?,
      sellerAddress: json['seller_address'] as String?,
      sellerPostcode: json['seller_postcode'] as String?,
      fuelEfficiency: json['fuel_efficiency'] as String?,
    );
  }

  static int? _parseInt(dynamic v) {
    if (v == null) return null;
    if (v is int) return v;
    if (v is num) return v.toInt();
    return int.tryParse(v.toString());
  }

  static double? _parseDouble(dynamic v) {
    if (v == null) return null;
    if (v is double) return v;
    if (v is int) return v.toDouble();
    if (v is num) return v.toDouble();
    return double.tryParse(v.toString());
  }

  static bool? _parseBool(dynamic v) {
    if (v == null) return null;
    if (v is bool) return v;
    if (v is int) return v != 0;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == '1' || s == 'true') return true;
      if (s == '0' || s == 'false') return false;
    }
    return null;
  }
}

class VehicleSpecification {
  final String name;
  final int count;

  VehicleSpecification({required this.name, required this.count});

  factory VehicleSpecification.fromJson(Map<String, dynamic> json) {
    return VehicleSpecification(
      name: json['name'] as String? ?? '',
      count: VehicleDetailModel._parseInt(json['count']) ?? 1,
    );
  }
}

class VehicleSpecDefinition {
  final String name;
  final String? value;

  VehicleSpecDefinition({required this.name, this.value});

  factory VehicleSpecDefinition.fromJson(Map<String, dynamic> json) {
    return VehicleSpecDefinition(
      name: json['name'] as String? ?? '',
      value: json['value']?.toString(),
    );
  }
}

class VehicleDmr {
  final String? extraEquipment;
  final double? technicalTotalWeightKg;
  final String? registrationStatusName;

  VehicleDmr({
    this.extraEquipment,
    this.technicalTotalWeightKg,
    this.registrationStatusName,
  });

  factory VehicleDmr.fromJson(Map<String, dynamic> json) {
    return VehicleDmr(
      extraEquipment: json['extra_equipment'] as String?,
      technicalTotalWeightKg: VehicleDetailModel._parseDouble(json['technical_total_weight_kg']),
      registrationStatusName: json['registration_status_name'] as String?,
    );
  }
}

class DealerDetail {
  final int id;
  final String? slug;
  final String? cvr;
  final String? address;
  final String? city;
  final String? postcode;
  final String? logoUrl;
  final DealerOwner? owner;

  DealerDetail({
    required this.id,
    this.slug,
    this.cvr,
    this.address,
    this.city,
    this.postcode,
    this.logoUrl,
    this.owner,
  });

  factory DealerDetail.fromJson(Map<String, dynamic> json) {
    return DealerDetail(
      id: json['id'] as int,
      slug: json['slug'] as String?,
      cvr: json['cvr'] as String?,
      address: json['address'] as String?,
      city: json['city'] as String?,
      postcode: json['postcode'] as String?,
      logoUrl: json['logo_url'] as String?,
      owner: json['owner'] != null
          ? DealerOwner.fromJson(json['owner'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DealerOwner {
  final int id;
  final String name;
  final String? email;
  final String? phone;
  final String? whatsappNumber;

  DealerOwner({
    required this.id,
    required this.name,
    this.email,
    this.phone,
    this.whatsappNumber,
  });

  factory DealerOwner.fromJson(Map<String, dynamic> json) {
    return DealerOwner(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
    );
  }
}

class VehicleUser {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final String? whatsappNumber;
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
    this.whatsappNumber,
    this.address,
    this.postcode,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
  });

  factory VehicleUser.fromJson(Map<String, dynamic> json) {
    return VehicleUser(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String?,
      whatsappNumber: json['whatsapp_number'] as String?,
      address: json['address'] as String?,
      postcode: json['postcode'] as String?,
      emailVerifiedAt: json['email_verified_at'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }
}

class VehicleImage {
  static const _storageBase = 'https://bilskyen.dk/storage/';

  final int id;
  final int? vehicleId;
  final String imagePath;
  final String thumbnailPath;
  final int sortOrder;

  VehicleImage({
    required this.id,
    this.vehicleId,
    required this.imagePath,
    required this.thumbnailPath,
    required this.sortOrder,
  });

  static String _pathOrUrlFromJson(String? path, String? url) {
    if (path != null && path.isNotEmpty) return path;
    if (url == null || url.isEmpty) return '';
    if (url.startsWith(_storageBase)) return url.substring(_storageBase.length);
    return url;
  }

  factory VehicleImage.fromJson(Map<String, dynamic> json) {
    return VehicleImage(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int?,
      imagePath: _pathOrUrlFromJson(
        json['image_path'] as String?,
        json['image_url'] as String?,
      ),
      thumbnailPath: _pathOrUrlFromJson(
        json['thumbnail_path'] as String?,
        json['thumbnail_url'] as String?,
      ),
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  String get imageUrl => imagePath.startsWith('http')
      ? imagePath
      : 'https://bilskyen.dk/storage/$imagePath';

  String get thumbnailUrl => thumbnailPath.startsWith('http')
      ? thumbnailPath
      : 'https://bilskyen.dk/storage/$thumbnailPath';
}

class VehicleEquipment {
  final int id;
  final String name;
  final int? equipmentTypeId;

  VehicleEquipment({
    required this.id,
    required this.name,
    this.equipmentTypeId,
  });

  factory VehicleEquipment.fromJson(Map<String, dynamic> json) {
    return VehicleEquipment(
      id: json['id'] as int,
      name: json['name'] as String? ?? '',
      equipmentTypeId: json['equipment_type_id'] as int?,
    );
  }
}
