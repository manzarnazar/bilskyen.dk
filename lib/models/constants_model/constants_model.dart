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
  final List<String> vehicleSortKeys;
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
    required this.vehicleSortKeys,
    required this.models,
    required this.equipments,
  });

  factory ConstantsModel.fromJson(Map<String, dynamic> json) {
    List<T> _safeList<T>(
      dynamic source,
      T Function(Map<String, dynamic>) parser,
    ) {
      final raw = source as List<dynamic>? ?? <dynamic>[];
      return raw
          .whereType<Map<String, dynamic>>()
          .map(parser)
          .toList();
    }

    return ConstantsModel(
      brands: _safeList(json['brands'], LookupItem.fromJson),
      fuelTypes: _safeList(json['fuel_types'], LookupItem.fromJson),
      transmissions: _safeList(json['transmissions'], LookupItem.fromJson),
      gearTypes: _safeList(json['gear_types'], LookupItem.fromJson),
      vehicleUses: _safeList(json['vehicle_uses'], LookupItem.fromJson),
      salesTypes: _safeList(json['sales_types'], LookupItem.fromJson),
      priceTypes: _safeList(json['price_types'], LookupItem.fromJson),
      conditions: _safeList(json['conditions'], LookupItem.fromJson),
      variants: _safeList(json['variants'], LookupItem.fromJson),
      categories: _safeList(json['categories'], LookupItem.fromJson),
      bodyTypes: _safeList(json['body_types'], LookupItem.fromJson),
      colors: _safeList(json['colors'], LookupItem.fromJson),
      types: _safeList(json['types'], LookupItem.fromJson),
      permits: _safeList(json['permits'], LookupItem.fromJson),
      modelYears: _safeList(json['model_years'], LookupItem.fromJson),
      listingTypes: _safeList(json['listing_types'], LookupItem.fromJson),
      equipmentTypes: _safeList(json['equipment_types'], LookupItem.fromJson),
      euronorms: _safeList(json['euronorms'], LookupItem.fromJson),
      vehicleSortKeys:
          (json['vehicle_sort_keys'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      models: _safeList(json['models'], ModelItem.fromJson),
      equipments: _safeList(json['equipments'], EquipmentItem.fromJson),
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
      'vehicle_sort_keys': vehicleSortKeys,
      'models': models.map((e) => e.toJson()).toList(),
      'equipments': equipments.map((e) => e.toJson()).toList(),
    };
  }
}

class LookupItem {
  final int id;
  final String name;

  LookupItem({required this.id, required this.name});

  factory LookupItem.fromJson(Map<String, dynamic> json) {
    return LookupItem(
      id: _asInt(json['id']),
      name: _asString(json['name']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}

class ModelItem {
  final int id;
  final String name;
  final int brandId;

  ModelItem({required this.id, required this.name, required this.brandId});

  factory ModelItem.fromJson(Map<String, dynamic> json) {
    return ModelItem(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      brandId: _asInt(json['brand_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'brand_id': brandId};
  }
}

class VariantItem {
  final int id;
  final String name;
  final int modelId;

  VariantItem({required this.id, required this.name, required this.modelId});

  factory VariantItem.fromJson(Map<String, dynamic> json) {
    return VariantItem(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      modelId: _asInt(json['model_id']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'model_id': modelId};
  }
}

class EquipmentItem {
  final int id;
  final String name;
  /// Null when the API omits type (grouped as "Other" on web).
  final int? equipmentTypeId;

  EquipmentItem({
    required this.id,
    required this.name,
    required this.equipmentTypeId,
  });

  factory EquipmentItem.fromJson(Map<String, dynamic> json) {
    final rawType = json['equipment_type_id'];
    return EquipmentItem(
      id: _asInt(json['id']),
      name: _asString(json['name']),
      equipmentTypeId: rawType == null ? null : _asInt(rawType),
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

int _asInt(dynamic value, {int fallback = 0}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? fallback;
  return fallback;
}

String _asString(dynamic value, {String fallback = ''}) {
  if (value is String) return value;
  if (value == null) return fallback;
  return value.toString();
}
