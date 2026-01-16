class LocationModel {
  final int id;
  final String city;
  final String postcode;
  final String region;
  final String countryCode;
  final double latitude;
  final double longitude;

  LocationModel({
    required this.id,
    required this.city,
    required this.postcode,
    required this.region,
    required this.countryCode,
    required this.latitude,
    required this.longitude,
  });

  factory LocationModel.fromJson(Map<String, dynamic> json) {
    // Handle latitude/longitude as either String or num
    double parseCoordinate(dynamic value) {
      if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.parse(value);
      } else {
        throw FormatException('Invalid coordinate value: $value');
      }
    }

    return LocationModel(
      id: json['id'] as int,
      city: json['city'] as String,
      postcode: json['postcode'] as String,
      region: json['region'] as String,
      countryCode: json['country_code'] as String,
      latitude: parseCoordinate(json['latitude']),
      longitude: parseCoordinate(json['longitude']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'city': city,
      'postcode': postcode,
      'region': region,
      'country_code': countryCode,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  String get fullAddress => '$postcode $city, $region';
}

