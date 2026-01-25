class VehicleLookupResponseModel {
  final String? registration;
  final String? vin;
  final String? title;
  final BrandModel? brand;
  final ModelModel? model;
  final ModelYearModel? modelYear;
  final FuelTypeModel? fuelType;
  final ColorModel? color;
  final VariantModel? variant;
  final EuronomModel? euronorm;
  final TypeModel? type;
  final UseModel? use;
  final BodyTypeModel? bodyType;
  final int? vehicleId;
  final String? vehicleExternalId;
  final int? kmDriven;
  final double? fuelEfficiency;
  final int? technicalTotalWeight;
  final int? totalWeight;
  final int? vehicleWeight;
  final String? firstRegistrationDate;
  final int? firstRegistrationMonth;
  final int? firstRegistrationYear;
  final String? lastInspectionDate;
  final int? lastInspectionMonth;
  final int? lastInspectionYear;
  final int? lastInspectionOdometer;
  final String? lastInspectionResult;
  final List<EquipmentModel>? equipment;
  final String? description;
  final String? version;
  final int? enginePower;
  final int? engineDisplacement;
  final int? engineCylinders;
  final String? engineCode;
  final int? topSpeed;
  final int? doors;
  final int? minimumSeats;
  final int? maximumSeats;
  final int? wheels;
  final int? axles;
  final int? driveAxles;
  final int? wheelbase;
  final bool? coupling;
  final bool? ncapFive;
  final int? airbags;
  final int? integratedChildSeats;
  final int? seatBeltAlarms;
  final String? registrationStatus;
  final String? registrationStatusUpdatedDate;
  final String? expireDate;
  final String? statusUpdatedDate;
  final String? typeApprovalCode;
  final String? vinLocation;
  final String? category;
  final List<dynamic>? dispensations;
  final List<dynamic>? permits;
  final String? extraEquipment;
  final int? towingWeight;
  final int? towingWeightBrakes;
  final int? minimumWeight;
  final int? grossCombinationWeight;
  final int? ownershipTax;
  final double? annualTax;

  VehicleLookupResponseModel({
    this.registration,
    this.vin,
    this.title,
    this.brand,
    this.model,
    this.modelYear,
    this.fuelType,
    this.color,
    this.variant,
    this.euronorm,
    this.type,
    this.use,
    this.bodyType,
    this.vehicleId,
    this.vehicleExternalId,
    this.kmDriven,
    this.fuelEfficiency,
    this.technicalTotalWeight,
    this.totalWeight,
    this.vehicleWeight,
    this.firstRegistrationDate,
    this.firstRegistrationMonth,
    this.firstRegistrationYear,
    this.lastInspectionDate,
    this.lastInspectionMonth,
    this.lastInspectionYear,
    this.lastInspectionOdometer,
    this.lastInspectionResult,
    this.equipment,
    this.description,
    this.version,
    this.enginePower,
    this.engineDisplacement,
    this.engineCylinders,
    this.engineCode,
    this.topSpeed,
    this.doors,
    this.minimumSeats,
    this.maximumSeats,
    this.wheels,
    this.axles,
    this.driveAxles,
    this.wheelbase,
    this.coupling,
    this.ncapFive,
    this.airbags,
    this.integratedChildSeats,
    this.seatBeltAlarms,
    this.registrationStatus,
    this.registrationStatusUpdatedDate,
    this.expireDate,
    this.statusUpdatedDate,
    this.typeApprovalCode,
    this.vinLocation,
    this.category,
    this.dispensations,
    this.permits,
    this.extraEquipment,
    this.towingWeight,
    this.towingWeightBrakes,
    this.minimumWeight,
    this.grossCombinationWeight,
    this.ownershipTax,
    this.annualTax,
  });

  // Helper function to safely parse int from string or int
  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) {
      if (value.isEmpty) return null;
      return int.tryParse(value);
    }
    if (value is num) return value.toInt();
    return null;
  }

  // Helper function to safely parse date string and extract month/year
  static int? _parseMonthFromDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final date = DateTime.parse(dateString);
      return date.month;
    } catch (e) {
      return null;
    }
  }

  static int? _parseYearFromDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return null;
    try {
      final date = DateTime.parse(dateString);
      return date.year;
    } catch (e) {
      return null;
    }
  }

  factory VehicleLookupResponseModel.fromJson(Map<String, dynamic> json) {
    // Handle nested structure: data.data.data or data.data
    Map<String, dynamic> vehicleData = json;
    if (json.containsKey('data')) {
      if (json['data'] is Map && json['data'].containsKey('data')) {
        vehicleData = json['data']['data'] as Map<String, dynamic>;
      } else if (json['data'] is Map) {
        vehicleData = json['data'] as Map<String, dynamic>;
      }
    }

    return VehicleLookupResponseModel(
      registration: vehicleData['registration'] as String?,
      vin: vehicleData['vin'] as String?,
      title: vehicleData['title'] as String?,
      brand: vehicleData['brand'] != null
          ? BrandModel.fromJson(vehicleData['brand'] as Map<String, dynamic>)
          : null,
      model: vehicleData['model'] != null
          ? ModelModel.fromJson(vehicleData['model'] as Map<String, dynamic>)
          : null,
      modelYear: vehicleData['model_year'] != null
          ? ModelYearModel.fromJson(
              vehicleData['model_year'] as Map<String, dynamic>)
          : null,
      fuelType: vehicleData['fuel_type'] != null
          ? FuelTypeModel.fromJson(
              vehicleData['fuel_type'] as Map<String, dynamic>)
          : null,
      color: vehicleData['color'] != null
          ? ColorModel.fromJson(vehicleData['color'] as Map<String, dynamic>)
          : null,
      variant: vehicleData['variant'] != null
          ? VariantModel.fromJson(vehicleData['variant'] as Map<String, dynamic>)
          : null,
      euronorm: vehicleData['euronorm'] != null
          ? EuronomModel.fromJson(
              vehicleData['euronorm'] as Map<String, dynamic>)
          : null,
      type: vehicleData['type'] != null
          ? TypeModel.fromJson(vehicleData['type'] as Map<String, dynamic>)
          : null,
      use: vehicleData['use'] != null
          ? UseModel.fromJson(vehicleData['use'] as Map<String, dynamic>)
          : null,
      bodyType: vehicleData['body_type'] != null
          ? BodyTypeModel.fromJson(
              vehicleData['body_type'] as Map<String, dynamic>)
          : null,
      vehicleId: _parseInt(vehicleData['vehicle_id']),
      vehicleExternalId: vehicleData['vehicle_external_id'] as String?,
      kmDriven: _parseInt(vehicleData['km_driven']),
      fuelEfficiency: (vehicleData['fuel_efficiency'] as num?)?.toDouble(),
      technicalTotalWeight: _parseInt(vehicleData['technical_total_weight']),
      totalWeight: _parseInt(vehicleData['total_weight']),
      vehicleWeight: _parseInt(vehicleData['vehicle_weight']),
      firstRegistrationDate: vehicleData['first_registration_date'] as String?,
      firstRegistrationMonth: vehicleData['first_registration_month'] != null
          ? _parseInt(vehicleData['first_registration_month'])
          : _parseMonthFromDate(vehicleData['first_registration_date'] as String?),
      firstRegistrationYear: vehicleData['first_registration_year'] != null
          ? _parseInt(vehicleData['first_registration_year'])
          : _parseYearFromDate(vehicleData['first_registration_date'] as String?),
      lastInspectionDate: vehicleData['last_inspection_date'] as String?,
      lastInspectionMonth: vehicleData['last_inspection_month'] != null
          ? _parseInt(vehicleData['last_inspection_month'])
          : _parseMonthFromDate(vehicleData['last_inspection_date'] as String?),
      lastInspectionYear: vehicleData['last_inspection_year'] != null
          ? _parseInt(vehicleData['last_inspection_year'])
          : _parseYearFromDate(vehicleData['last_inspection_date'] as String?),
      lastInspectionOdometer: _parseInt(vehicleData['last_inspection_odometer']),
      lastInspectionResult: vehicleData['last_inspection_result'] as String?,
      equipment: vehicleData['equipment'] != null
          ? (vehicleData['equipment'] as List)
              .map((e) => EquipmentModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      description: vehicleData['description'] as String?,
      version: vehicleData['version'] as String?,
      enginePower: _parseInt(vehicleData['engine_power']),
      engineDisplacement: _parseInt(vehicleData['engine_displacement']),
      engineCylinders: _parseInt(vehicleData['engine_cylinders']),
      engineCode: vehicleData['engine_code'] as String?,
      topSpeed: _parseInt(vehicleData['top_speed']),
      doors: _parseInt(vehicleData['doors']),
      minimumSeats: _parseInt(vehicleData['minimum_seats']),
      maximumSeats: _parseInt(vehicleData['maximum_seats']),
      wheels: _parseInt(vehicleData['wheels']),
      axles: _parseInt(vehicleData['axles']),
      driveAxles: _parseInt(vehicleData['drive_axles']),
      wheelbase: _parseInt(vehicleData['wheelbase']),
      coupling: vehicleData['coupling'] as bool?,
      ncapFive: vehicleData['ncap_five'] as bool?,
      airbags: _parseInt(vehicleData['airbags']),
      integratedChildSeats: _parseInt(vehicleData['integrated_child_seats']),
      seatBeltAlarms: _parseInt(vehicleData['seat_belt_alarms']),
      registrationStatus: vehicleData['registration_status'] as String?,
      registrationStatusUpdatedDate:
          vehicleData['registration_status_updated_date'] as String?,
      expireDate: vehicleData['expire_date'] as String?,
      statusUpdatedDate: vehicleData['status_updated_date'] as String?,
      typeApprovalCode: vehicleData['type_approval_code'] as String?,
      vinLocation: vehicleData['vin_location'] as String?,
      category: vehicleData['category'] as String?,
      dispensations: vehicleData['dispensations'] as List<dynamic>?,
      permits: vehicleData['permits'] as List<dynamic>?,
      extraEquipment: vehicleData['extra_equipment'] as String?,
      towingWeight: _parseInt(vehicleData['towing_weight']),
      towingWeightBrakes: _parseInt(vehicleData['towing_weight_brakes']),
      minimumWeight: _parseInt(vehicleData['minimum_weight']),
      grossCombinationWeight: _parseInt(vehicleData['gross_combination_weight']),
      ownershipTax: _parseInt(vehicleData['ownership_tax']),
      annualTax: (vehicleData['annual_tax'] as num?)?.toDouble(),
    );
  }
}

// Lookup model classes
class BrandModel {
  final int id;
  final String name;

  BrandModel({required this.id, required this.name});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ModelModel {
  final int id;
  final String name;
  final int? brandId;

  ModelModel({required this.id, required this.name, this.brandId});

  factory ModelModel.fromJson(Map<String, dynamic> json) {
    return ModelModel(
      id: json['id'] as int,
      name: json['name'] as String,
      brandId: json['brand_id'] as int?,
    );
  }
}

class ModelYearModel {
  final int id;
  final String name;

  ModelYearModel({required this.id, required this.name});

  factory ModelYearModel.fromJson(Map<String, dynamic> json) {
    return ModelYearModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class FuelTypeModel {
  final int id;
  final String name;

  FuelTypeModel({required this.id, required this.name});

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class ColorModel {
  final int id;
  final String name;

  ColorModel({required this.id, required this.name});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class VariantModel {
  final int id;
  final String name;

  VariantModel({required this.id, required this.name});

  factory VariantModel.fromJson(Map<String, dynamic> json) {
    return VariantModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class EuronomModel {
  final int id;
  final String name;

  EuronomModel({required this.id, required this.name});

  factory EuronomModel.fromJson(Map<String, dynamic> json) {
    return EuronomModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class TypeModel {
  final int id;
  final String name;

  TypeModel({required this.id, required this.name});

  factory TypeModel.fromJson(Map<String, dynamic> json) {
    return TypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class UseModel {
  final int id;
  final String name;

  UseModel({required this.id, required this.name});

  factory UseModel.fromJson(Map<String, dynamic> json) {
    return UseModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class BodyTypeModel {
  final int id;
  final String name;

  BodyTypeModel({required this.id, required this.name});

  factory BodyTypeModel.fromJson(Map<String, dynamic> json) {
    return BodyTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class EquipmentModel {
  final int id;
  final String name;
  final int? equipmentTypeId;
  final EquipmentTypeModel? equipmentType;

  EquipmentModel({
    required this.id,
    required this.name,
    this.equipmentTypeId,
    this.equipmentType,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
      id: json['id'] as int,
      name: json['name'] as String,
      equipmentTypeId: json['equipment_type_id'] as int?,
      equipmentType: json['equipment_type'] != null
          ? EquipmentTypeModel.fromJson(
              json['equipment_type'] as Map<String, dynamic>)
          : null,
    );
  }
}

class EquipmentTypeModel {
  final int id;
  final String name;

  EquipmentTypeModel({required this.id, required this.name});

  factory EquipmentTypeModel.fromJson(Map<String, dynamic> json) {
    return EquipmentTypeModel(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}
