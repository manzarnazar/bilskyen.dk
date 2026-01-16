class VehicleListStatusModel {
  static const int DRAFT = 1;
  static const int PUBLISHED = 2;
  static const int SOLD = 3;
  static const int ARCHIVED = 4;

  final int id;
  final String name;

  VehicleListStatusModel({
    required this.id,
    required this.name,
  });

  factory VehicleListStatusModel.fromJson(Map<String, dynamic> json) {
    return VehicleListStatusModel(
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

