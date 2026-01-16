class BodyTypeModel {
  final int id;
  final String name;

  BodyTypeModel({
    required this.id,
    required this.name,
  });

  factory BodyTypeModel.fromJson(Map<String, dynamic> json) {
    return BodyTypeModel(
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

