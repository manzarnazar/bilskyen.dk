import 'vehicle_lookup_response_model.dart';

class ReferenceDataModel {
  final List<ColorModel> colors;
  final List<EquipmentModel> equipment;
  final List<EquipmentTypeModel> equipmentTypes;
  final List<VariantModel> variants;
  final List<EuronomModel> euronorms;
  final List<LocationModel> locations;

  ReferenceDataModel({
    required this.colors,
    required this.equipment,
    required this.equipmentTypes,
    required this.variants,
    required this.euronorms,
    required this.locations,
  });
}

class LocationModel {
  final String city;
  final String postcode;
  final String? region;

  LocationModel({
    required this.city,
    required this.postcode,
    this.region,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    return LocationModel(
      city: json['city'] as String,
      postcode: json['postcode'] as String,
      region: json['region'] as String?,
    );
  }

  String get displayName => '$city, $postcode';
}
