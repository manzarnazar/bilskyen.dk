class VehicleModel {
  final int id;
  final String title;
  final String? version;
  final int price;
  final String image;
  final int? kmDriven;
  final double? enginePowerHp;
  final String firstRegistrationDate;
  final String? fuelTypeName;
  final String? gearTypeName;
  final String? modelYearName;
  final String? brandName;
  final String? modelName;
  final String? sellerType;
  final String? sellerAddress;
  final String? sellerPostcode;
  /// Listing owner user id (when returned by API); used to hide contact/enquiry for own listing.
  final int? userId;
  /// Seller list API: status id (1=Draft, 2=Published, 3=Sold, 4=Archived)
  final int? vehicleListStatusId;
  final String? vehicleListStatusName;
  final int? enquiriesCount;
  final int? viewsCount;
  /// Sales type label used on web cards (e.g. "Kontantpris", "Engros / CVR").
  /// Included so mobile cards can visually match the website.
  final String? salesTypeName;

  VehicleModel({
    required this.id,
    required this.title,
    this.version,
    required this.price,
    required this.image,
    this.kmDriven,
    this.enginePowerHp,
    required this.firstRegistrationDate,
    this.fuelTypeName,
    this.gearTypeName,
    this.modelYearName,
    this.brandName,
    this.modelName,
    this.sellerType,
    this.sellerAddress,
    this.sellerPostcode,
    this.userId,
    this.vehicleListStatusId,
    this.vehicleListStatusName,
    this.enquiriesCount,
    this.viewsCount,
    this.salesTypeName,
  });

  /// Getter to maintain compatibility with card which expects imageUrl
  String get imageUrl => image;

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Prefer thumbnail_url, fallback to image_url, then image
    final imageUrl = json['thumbnail_url'] as String? ??
        json['image_url'] as String? ??
        json['image'] as String? ??
        '';

    return VehicleModel(
      id: json['id'] as int,
      title: json['title'] as String,
      version: json['version'] as String?,
      price: json['price'] as int,
      image: imageUrl,
      kmDriven: json['km_driven'] as int?,
      enginePowerHp: (json['engine_power_hp'] as num?)?.toDouble(),
      firstRegistrationDate: json['first_registration_date'] as String? ?? '',
      fuelTypeName: json['fuel_type_name'] as String?,
      gearTypeName: json['gear_type_name'] as String?,
      modelYearName: json['model_year_name'] as String?,
      brandName: json['brand_name'] as String?,
      modelName: json['model_name'] as String?,
      sellerType: json['seller_type'] as String?,
      sellerAddress: json['seller_address'] as String?,
      sellerPostcode: json['seller_postcode'] as String?,
      userId: json['user_id'] as int?,
      vehicleListStatusId: json['vehicle_list_status_id'] as int?,
      vehicleListStatusName: json['vehicle_list_status_name'] as String?,
      enquiriesCount: json['enquiries_count'] as int?,
      viewsCount: json['views_count'] as int?,
      salesTypeName: json['sales_type_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'version': version,
      'price': price,
      'image': image,
      'km_driven': kmDriven ?? 0,
      'engine_power_hp': enginePowerHp ?? 0.0,
      'first_registration_date': firstRegistrationDate,
      'fuel_type_name': fuelTypeName,
      'gear_type_name': gearTypeName,
      'model_year_name': modelYearName,
      'brand_name': brandName,
      'model_name': modelName,
      'seller_type': sellerType,
      'seller_address': sellerAddress,
      'seller_postcode': sellerPostcode,
      'user_id': userId,
      'vehicle_list_status_id': vehicleListStatusId,
      'vehicle_list_status_name': vehicleListStatusName,
      'enquiries_count': enquiriesCount,
      'views_count': viewsCount,
      'sales_type_name': salesTypeName,
    };
  }

  VehicleModel copyWith({
    int? id,
    String? title,
    String? version,
    int? price,
    String? image,
    int? kmDriven,
    double? enginePowerHp,
    String? firstRegistrationDate,
    String? fuelTypeName,
    String? gearTypeName,
    String? modelYearName,
    String? brandName,
    String? modelName,
    String? sellerType,
    String? sellerAddress,
    String? sellerPostcode,
    int? userId,
    int? vehicleListStatusId,
    String? vehicleListStatusName,
    int? enquiriesCount,
    int? viewsCount,
    String? salesTypeName,
  }) {
    return VehicleModel(
      id: id ?? this.id,
      title: title ?? this.title,
      version: version ?? this.version,
      price: price ?? this.price,
      image: image ?? this.image,
      kmDriven: kmDriven ?? this.kmDriven,
      enginePowerHp: enginePowerHp ?? this.enginePowerHp,
      firstRegistrationDate: firstRegistrationDate ?? this.firstRegistrationDate,
      fuelTypeName: fuelTypeName ?? this.fuelTypeName,
      gearTypeName: gearTypeName ?? this.gearTypeName,
      modelYearName: modelYearName ?? this.modelYearName,
      brandName: brandName ?? this.brandName,
      modelName: modelName ?? this.modelName,
      sellerType: sellerType ?? this.sellerType,
      sellerAddress: sellerAddress ?? this.sellerAddress,
      sellerPostcode: sellerPostcode ?? this.sellerPostcode,
      userId: userId ?? this.userId,
      vehicleListStatusId: vehicleListStatusId ?? this.vehicleListStatusId,
      vehicleListStatusName:
          vehicleListStatusName ?? this.vehicleListStatusName,
      enquiriesCount: enquiriesCount ?? this.enquiriesCount,
      viewsCount: viewsCount ?? this.viewsCount,
      salesTypeName: salesTypeName ?? this.salesTypeName,
    );
  }
}

