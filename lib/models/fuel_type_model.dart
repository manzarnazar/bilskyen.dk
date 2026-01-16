class FuelTypeModel {
  final int id;
  final String name;

  FuelTypeModel({
    required this.id,
    required this.name,
  });

  factory FuelTypeModel.fromJson(Map<String, dynamic> json) {
    return FuelTypeModel(
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

