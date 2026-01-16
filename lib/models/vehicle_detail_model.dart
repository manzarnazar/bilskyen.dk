class VehicleDetailModel {
  final int id;
  final int vehicleId;
  final String? description;
  final int viewsCount;
  final String? vinLocation;
  final int? typeId;
  final String? version;
  final String? typeName;
  final String? registrationStatus;
  final DateTime? registrationStatusUpdatedDate;
  final DateTime? expireDate;
  final DateTime? statusUpdatedDate;
  final String? modelYear;
  final int? totalWeight;
  final int? vehicleWeight;
  final int? technicalTotalWeight;
  final int? coupling;
  final int? towingWeightBrakes;
  final int? minimumWeight;
  final int? grossCombinationWeight;
  final double? fuelEfficiency;
  final int? engineDisplacement;
  final int? engineCylinders;
  final String? engineCode;
  final String? category;
  final DateTime? lastInspectionDate;
  final String? lastInspectionResult;
  final int? lastInspectionOdometer;
  final String? typeApprovalCode;
  final int? topSpeed;
  final int? doors;
  final int? minimumSeats;
  final int? maximumSeats;
  final int? wheels;
  final String? extraEquipment;
  final int? axles;
  final int? driveAxles;
  final int? wheelbase;
  final DateTime? leasingPeriodStart;
  final DateTime? leasingPeriodEnd;
  final int? useId;
  final int? colorId;
  final int? bodyTypeId;
  final String? dispensations;
  final String? permits;
  final bool? ncapFive;
  final int? airbags;
  final int? integratedChildSeats;
  final int? seatBeltAlarms;
  final String? euronorm;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Cached lookup names
  String? _typeNameResolved;
  String? _useName;
  String? _colorName;
  String? _bodyTypeName;

  VehicleDetailModel({
    required this.id,
    required this.vehicleId,
    this.description,
    this.viewsCount = 0,
    this.vinLocation,
    this.typeId,
    this.version,
    this.typeName,
    this.registrationStatus,
    this.registrationStatusUpdatedDate,
    this.expireDate,
    this.statusUpdatedDate,
    this.modelYear,
    this.totalWeight,
    this.vehicleWeight,
    this.technicalTotalWeight,
    this.coupling,
    this.towingWeightBrakes,
    this.minimumWeight,
    this.grossCombinationWeight,
    this.fuelEfficiency,
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
    this.dispensations,
    this.permits,
    this.ncapFive,
    this.airbags,
    this.integratedChildSeats,
    this.seatBeltAlarms,
    this.euronorm,
    required this.createdAt,
    required this.updatedAt,
    String? typeNameResolved,
    String? useName,
    String? colorName,
    String? bodyTypeName,
  })  : _typeNameResolved = typeNameResolved,
        _useName = useName,
        _colorName = colorName,
        _bodyTypeName = bodyTypeName;

  String get typeNameResolved => _typeNameResolved ?? typeName ?? 'Unknown';
  String get useName => _useName ?? 'Unknown';
  String get colorName => _colorName ?? 'Unknown';
  String get bodyTypeName => _bodyTypeName ?? 'Unknown';

  factory VehicleDetailModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailModel(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      description: json['description'] as String?,
      viewsCount: json['views_count'] as int? ?? 0,
      vinLocation: json['vin_location'] as String?,
      typeId: json['type_id'] as int?,
      version: json['version'] as String?,
      typeName: json['type_name'] as String?,
      registrationStatus: json['registration_status'] as String?,
      registrationStatusUpdatedDate: json['registration_status_updated_date'] != null
          ? DateTime.parse(json['registration_status_updated_date'] as String)
          : null,
      expireDate: json['expire_date'] != null
          ? DateTime.parse(json['expire_date'] as String)
          : null,
      statusUpdatedDate: json['status_updated_date'] != null
          ? DateTime.parse(json['status_updated_date'] as String)
          : null,
      modelYear: json['model_year'] as String?,
      totalWeight: json['total_weight'] as int?,
      vehicleWeight: json['vehicle_weight'] as int?,
      technicalTotalWeight: json['technical_total_weight'] as int?,
      coupling: json['coupling'] as int?,
      towingWeightBrakes: json['towing_weight_brakes'] as int?,
      minimumWeight: json['minimum_weight'] as int?,
      grossCombinationWeight: json['gross_combination_weight'] as int?,
      fuelEfficiency: json['fuel_efficiency'] != null
          ? (json['fuel_efficiency'] as num).toDouble()
          : null,
      engineDisplacement: json['engine_displacement'] as int?,
      engineCylinders: json['engine_cylinders'] as int?,
      engineCode: json['engine_code'] as String?,
      category: json['category'] as String?,
      lastInspectionDate: json['last_inspection_date'] != null
          ? DateTime.parse(json['last_inspection_date'] as String)
          : null,
      lastInspectionResult: json['last_inspection_result'] as String?,
      lastInspectionOdometer: json['last_inspection_odometer'] as int?,
      typeApprovalCode: json['type_approval_code'] as String?,
      topSpeed: json['top_speed'] as int?,
      doors: json['doors'] as int?,
      minimumSeats: json['minimum_seats'] as int?,
      maximumSeats: json['maximum_seats'] as int?,
      wheels: json['wheels'] as int?,
      extraEquipment: json['extra_equipment'] as String?,
      axles: json['axles'] as int?,
      driveAxles: json['drive_axles'] as int?,
      wheelbase: json['wheelbase'] as int?,
      leasingPeriodStart: json['leasing_period_start'] != null
          ? DateTime.parse(json['leasing_period_start'] as String)
          : null,
      leasingPeriodEnd: json['leasing_period_end'] != null
          ? DateTime.parse(json['leasing_period_end'] as String)
          : null,
      useId: json['use_id'] as int?,
      colorId: json['color_id'] as int?,
      bodyTypeId: json['body_type_id'] as int?,
      dispensations: json['dispensations'] as String?,
      permits: json['permits'] as String?,
      ncapFive: json['ncap_five'] as bool?,
      airbags: json['airbags'] as int?,
      integratedChildSeats: json['integrated_child_seats'] as int?,
      seatBeltAlarms: json['seat_belt_alarms'] as int?,
      euronorm: json['euronorm'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      typeNameResolved: json['type_name_resolved'] as String?,
      useName: json['use_name'] as String?,
      colorName: json['color_name'] as String?,
      bodyTypeName: json['body_type_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'description': description,
      'views_count': viewsCount,
      'vin_location': vinLocation,
      'type_id': typeId,
      'version': version,
      'type_name': typeName,
      'registration_status': registrationStatus,
      'registration_status_updated_date': registrationStatusUpdatedDate?.toIso8601String(),
      'expire_date': expireDate?.toIso8601String(),
      'status_updated_date': statusUpdatedDate?.toIso8601String(),
      'model_year': modelYear,
      'total_weight': totalWeight,
      'vehicle_weight': vehicleWeight,
      'technical_total_weight': technicalTotalWeight,
      'coupling': coupling,
      'towing_weight_brakes': towingWeightBrakes,
      'minimum_weight': minimumWeight,
      'gross_combination_weight': grossCombinationWeight,
      'fuel_efficiency': fuelEfficiency,
      'engine_displacement': engineDisplacement,
      'engine_cylinders': engineCylinders,
      'engine_code': engineCode,
      'category': category,
      'last_inspection_date': lastInspectionDate?.toIso8601String(),
      'last_inspection_result': lastInspectionResult,
      'last_inspection_odometer': lastInspectionOdometer,
      'type_approval_code': typeApprovalCode,
      'top_speed': topSpeed,
      'doors': doors,
      'minimum_seats': minimumSeats,
      'maximum_seats': maximumSeats,
      'wheels': wheels,
      'extra_equipment': extraEquipment,
      'axles': axles,
      'drive_axles': driveAxles,
      'wheelbase': wheelbase,
      'leasing_period_start': leasingPeriodStart?.toIso8601String(),
      'leasing_period_end': leasingPeriodEnd?.toIso8601String(),
      'use_id': useId,
      'color_id': colorId,
      'body_type_id': bodyTypeId,
      'dispensations': dispensations,
      'permits': permits,
      'ncap_five': ncapFive,
      'airbags': airbags,
      'integrated_child_seats': integratedChildSeats,
      'seat_belt_alarms': seatBeltAlarms,
      'euronorm': euronorm,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'type_name_resolved': typeNameResolved,
      'use_name': useName,
      'color_name': colorName,
      'body_type_name': bodyTypeName,
    };
  }
}

