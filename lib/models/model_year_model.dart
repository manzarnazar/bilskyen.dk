class ModelYearModel {
  final int id;
  final String name;

  ModelYearModel({
    required this.id,
    required this.name,
  });

  factory ModelYearModel.fromJson(Map<String, dynamic> json) {
    return ModelYearModel(
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

