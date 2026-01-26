class ConstantsModel {
  final List<LookupItem> brands;
  final List<LookupItem> fuelTypes;
  final List<LookupItem> transmissions;
  final List<LookupItem> gearTypes;
  final List<LookupItem> vehicleUses;
  final List<LookupItem> salesTypes;
  final List<LookupItem> priceTypes;
  final List<LookupItem> conditions;
  final List<LookupItem> variants;
  final List<LookupItem> categories;
  final List<LookupItem> bodyTypes;
  final List<LookupItem> colors;
  final List<LookupItem> types;
  final List<LookupItem> permits;
  final List<LookupItem> modelYears;
  final List<LookupItem> listingTypes;
  final List<LookupItem> equipmentTypes;
  final List<LookupItem> euronorms;
  final List<ModelItem> models;
  final List<EquipmentItem> equipments;

  ConstantsModel({
    required this.brands,
    required this.fuelTypes,
    required this.transmissions,
    required this.gearTypes,
    required this.vehicleUses,
    required this.salesTypes,
    required this.priceTypes,
    required this.conditions,
    required this.variants,
    required this.categories,
    required this.bodyTypes,
    required this.colors,
    required this.types,
    required this.permits,
    required this.modelYears,
    required this.listingTypes,
    required this.equipmentTypes,
    required this.euronorms,
    required this.models,
    required this.equipments,
  });

  factory ConstantsModel.fromJson(Map<String, dynamic> json) {
    return ConstantsModel(
      brands: (json['brands'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      fuelTypes: (json['fuel_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      transmissions: (json['transmissions'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      gearTypes: (json['gear_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      vehicleUses: (json['vehicle_uses'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      salesTypes: (json['sales_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      priceTypes: (json['price_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      conditions: (json['conditions'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      variants: (json['variants'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      bodyTypes: (json['body_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      colors: (json['colors'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      types: (json['types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      permits: (json['permits'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      modelYears: (json['model_years'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      listingTypes: (json['listing_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      equipmentTypes: (json['equipment_types'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      euronorms: (json['euronorms'] as List<dynamic>?)
              ?.map((e) => LookupItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      models: (json['models'] as List<dynamic>?)
              ?.map((e) => ModelItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      equipments: (json['equipments'] as List<dynamic>?)
              ?.map((e) => EquipmentItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brands': brands.map((e) => e.toJson()).toList(),
      'fuel_types': fuelTypes.map((e) => e.toJson()).toList(),
      'transmissions': transmissions.map((e) => e.toJson()).toList(),
      'gear_types': gearTypes.map((e) => e.toJson()).toList(),
      'vehicle_uses': vehicleUses.map((e) => e.toJson()).toList(),
      'sales_types': salesTypes.map((e) => e.toJson()).toList(),
      'price_types': priceTypes.map((e) => e.toJson()).toList(),
      'conditions': conditions.map((e) => e.toJson()).toList(),
      'variants': variants.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toJson()).toList(),
      'body_types': bodyTypes.map((e) => e.toJson()).toList(),
      'colors': colors.map((e) => e.toJson()).toList(),
      'types': types.map((e) => e.toJson()).toList(),
      'permits': permits.map((e) => e.toJson()).toList(),
      'model_years': modelYears.map((e) => e.toJson()).toList(),
      'listing_types': listingTypes.map((e) => e.toJson()).toList(),
      'equipment_types': equipmentTypes.map((e) => e.toJson()).toList(),
      'euronorms': euronorms.map((e) => e.toJson()).toList(),
      'models': models.map((e) => e.toJson()).toList(),
      'equipments': equipments.map((e) => e.toJson()).toList(),
    };
  }
}

class LookupItem {
  final int id;
  final String name;

  LookupItem({
    required this.id,
    required this.name,
  });

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

class ModelItem {
  final int id;
  final String name;
  final int brandId;

  ModelItem({
    required this.id,
    required this.name,
    required this.brandId,
  });

  factory ModelItem.fromJson(Map<String, dynamic> json) {
    return ModelItem(
      id: json['id'] as int,
      name: json['name'] as String,
      brandId: json['brand_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'brand_id': brandId,
    };
  }
}

class EquipmentItem {
  final int id;
  final String name;
  final int equipmentTypeId;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    return EquipmentItem(
      id: json['id'] as int,
      name: json['name'] as String,
      equipmentTypeId: json['equipment_type_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'equipment_type_id': equipmentTypeId,
    };
  }
}
