class EquipmentModel {
  final int id;
  final String name;

  EquipmentModel({
    required this.id,
    required this.name,
  });

  factory EquipmentModel.fromJson(Map<String, dynamic> json) {
    return EquipmentModel(
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

