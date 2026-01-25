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
  });

  /// Getter to maintain compatibility with card which expects imageUrl
  String get imageUrl => image;

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    // Prefer thumbnail_url, fallback to image_url, then image
    final imageUrl = json['thumbnail_url'] as String? ?? 
                     json['image_url'] as String? ?? 
                     json['image'] as String? ?? '';
    
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
    );
  }
}

