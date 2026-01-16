import 'vehicle_list_status_model.dart';
import 'location_model.dart';
import 'equipment_model.dart';
import 'vehicle_image_model.dart';
import 'vehicle_detail_model.dart';

class VehicleModel {
  final int id;
  final String title;
  final String? registration;
  final String? vin;
  final int userId;
  final int? categoryId;
  final int locationId;
  final int? brandId;
  final int? modelYearId;
  final int? kmDriven;
  final int fuelTypeId;
  final int price; // Price in DKK (INT)
  final int? mileage;
  final int? batteryCapacity;
  final int? enginePower;
  final int? towingWeight;
  final int? ownershipTax;
  final DateTime? firstRegistrationDate;
  final int vehicleListStatusId;
  final DateTime? publishedAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  // Cached lookup names (from API response)
  String? _categoryName;
  String? _brandName;
  String? _modelYearName;
  String? _fuelTypeName;
  String? _vehicleListStatusName;

  // Relationships (optional, loaded separately)
  LocationModel? location;
  VehicleDetailModel? vehicleDetail;
  List<VehicleImageModel>? images;
  List<EquipmentModel>? equipment;

  VehicleModel({
    required this.id,
    required this.title,
    this.registration,
    this.vin,
    required this.userId,
    this.categoryId,
    required this.locationId,
    this.brandId,
    this.modelYearId,
    this.kmDriven,
    required this.fuelTypeId,
    required this.price,
    this.mileage,
    this.batteryCapacity,
    this.enginePower,
    this.towingWeight,
    this.ownershipTax,
    this.firstRegistrationDate,
    required this.vehicleListStatusId,
    this.publishedAt,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
    String? categoryName,
    String? brandName,
    String? modelYearName,
    String? fuelTypeName,
    String? vehicleListStatusName,
    this.location,
    this.vehicleDetail,
    this.images,
    this.equipment,
  })  : _categoryName = categoryName,
        _brandName = brandName,
        _modelYearName = modelYearName,
        _fuelTypeName = fuelTypeName,
        _vehicleListStatusName = vehicleListStatusName;

  // Accessors for resolved names
  String get categoryName => _categoryName ?? 'Unknown';
  String get brandName => _brandName ?? 'Unknown';
  String get modelYearName => _modelYearName ?? 'Unknown';
  String get fuelTypeName => _fuelTypeName ?? 'Unknown';
  String get vehicleListStatusName => _vehicleListStatusName ?? 'Unknown';

  // Helper getters
  String get fullName => '$brandName $title';
  String get displayInfo => '${modelYearName} • ${fuelTypeName}';

  // Price formatting in DKK (Danish format: kr. 100.000)
  String get formattedPrice {
    final priceString = price.toString();
    if (priceString.length <= 3) {
      return 'kr. $priceString';
    }

    // Danish format: dots as thousand separators
    final reversed = priceString.split('').reversed.toList();
    final buffer = StringBuffer();

    for (int i = 0; i < reversed.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.write('.');
      }
      buffer.write(reversed[i]);
    }

    return 'kr. ${buffer.toString().split('').reversed.join()}';
  }

  // Get primary image URL
  String? get imageUrl {
    if (images != null && images!.isNotEmpty) {
      // Sort by sortOrder and get first image
      final sortedImages = List<VehicleImageModel>.from(images!)
        ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
      return sortedImages.first.thumbnailUrl;
    }
    return null;
  }

  bool get isPublished => vehicleListStatusId == VehicleListStatusModel.PUBLISHED;
  bool get isDraft => vehicleListStatusId == VehicleListStatusModel.DRAFT;
  bool get isSold => vehicleListStatusId == VehicleListStatusModel.SOLD;
  bool get isArchived => vehicleListStatusId == VehicleListStatusModel.ARCHIVED;

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      registration: json['registration'] as String?,
      vin: json['vin'] as String?,
      userId: json['user_id'] as int,
      categoryId: json['category_id'] as int?,
      locationId: json['location_id'] as int,
      brandId: json['brand_id'] as int?,
      modelYearId: json['model_year_id'] as int?,
      kmDriven: json['km_driven'] as int?,
      fuelTypeId: json['fuel_type_id'] as int,
      price: json['price'] as int,
      mileage: json['mileage'] as int?,
      batteryCapacity: json['battery_capacity'] as int?,
      enginePower: json['engine_power'] as int?,
      towingWeight: json['towing_weight'] as int?,
      ownershipTax: json['ownership_tax'] as int?,
      firstRegistrationDate: json['first_registration_date'] != null
          ? DateTime.parse(json['first_registration_date'] as String)
          : null,
      vehicleListStatusId: json['vehicle_list_status_id'] as int,
      publishedAt: json['published_at'] != null
          ? DateTime.parse(json['published_at'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      deletedAt: json['deleted_at'] != null
          ? DateTime.parse(json['deleted_at'] as String)
          : null,
      categoryName: json['category_name'] as String?,
      brandName: json['brand_name'] as String?,
      modelYearName: json['model_year_name'] as String?,
      fuelTypeName: json['fuel_type_name'] as String?,
      vehicleListStatusName: json['vehicle_list_status_name'] as String?,
      location: json['location'] != null
          ? LocationModel.fromJson(json['location'] as Map<String, dynamic>)
          : null,
      vehicleDetail: (json['details'] != null || json['vehicle_detail'] != null)
          ? VehicleDetailModel.fromJson(
              (json['details'] ?? json['vehicle_detail']) as Map<String, dynamic>)
          : null,
      images: json['images'] != null
          ? (json['images'] as List)
              .map((item) => VehicleImageModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      equipment: json['equipment'] != null
          ? (json['equipment'] as List)
              .map((item) => EquipmentModel.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'registration': registration,
      'vin': vin,
      'user_id': userId,
      'category_id': categoryId,
      'location_id': locationId,
      'brand_id': brandId,
      'model_year_id': modelYearId,
      'km_driven': kmDriven,
      'fuel_type_id': fuelTypeId,
      'price': price,
      'mileage': mileage,
      'battery_capacity': batteryCapacity,
      'engine_power': enginePower,
      'towing_weight': towingWeight,
      'ownership_tax': ownershipTax,
      'first_registration_date': firstRegistrationDate?.toIso8601String(),
      'vehicle_list_status_id': vehicleListStatusId,
      'published_at': publishedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'deleted_at': deletedAt?.toIso8601String(),
      'category_name': categoryName,
      'brand_name': brandName,
      'model_year_name': modelYearName,
      'fuel_type_name': fuelTypeName,
      'vehicle_list_status_name': vehicleListStatusName,
      if (location != null) 'location': location!.toJson(),
      if (vehicleDetail != null) 'vehicle_detail': vehicleDetail!.toJson(),
      if (images != null) 'images': images!.map((img) => img.toJson()).toList(),
      if (equipment != null) 'equipment': equipment!.map((eq) => eq.toJson()).toList(),
    };
  }

  VehicleModel copyWith({
    int? id,
    String? title,
    String? registration,
    String? vin,
    int? userId,
    int? categoryId,
    int? locationId,
    int? brandId,
    int? modelYearId,
    int? kmDriven,
    int? fuelTypeId,
    int? price,
    int? mileage,
    int? batteryCapacity,
    int? enginePower,
    int? towingWeight,
    int? ownershipTax,
    DateTime? firstRegistrationDate,
    int? vehicleListStatusId,
    DateTime? publishedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
    String? categoryName,
    String? brandName,
    String? modelYearName,
    String? fuelTypeName,
    String? vehicleListStatusName,
    LocationModel? location,
    VehicleDetailModel? vehicleDetail,
    List<VehicleImageModel>? images,
    List<EquipmentModel>? equipment,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      registration: registration ?? this.registration,
      vin: vin ?? this.vin,
      userId: userId ?? this.userId,
      categoryId: categoryId ?? this.categoryId,
      locationId: locationId ?? this.locationId,
      brandId: brandId ?? this.brandId,
      modelYearId: modelYearId ?? this.modelYearId,
      kmDriven: kmDriven ?? this.kmDriven,
      fuelTypeId: fuelTypeId ?? this.fuelTypeId,
      price: price ?? this.price,
      mileage: mileage ?? this.mileage,
      batteryCapacity: batteryCapacity ?? this.batteryCapacity,
      enginePower: enginePower ?? this.enginePower,
      towingWeight: towingWeight ?? this.towingWeight,
      ownershipTax: ownershipTax ?? this.ownershipTax,
      firstRegistrationDate: firstRegistrationDate ?? this.firstRegistrationDate,
      vehicleListStatusId: vehicleListStatusId ?? this.vehicleListStatusId,
      publishedAt: publishedAt ?? this.publishedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      categoryName: categoryName ?? _categoryName,
      brandName: brandName ?? _brandName,
      modelYearName: modelYearName ?? _modelYearName,
      fuelTypeName: fuelTypeName ?? _fuelTypeName,
      vehicleListStatusName: vehicleListStatusName ?? _vehicleListStatusName,
      location: location ?? this.location,
      vehicleDetail: vehicleDetail ?? this.vehicleDetail,
      images: images ?? this.images,
      equipment: equipment ?? this.equipment,
    );
  }
}

