class ColorModel {
  final int id;
  final String name;

  ColorModel({
    required this.id,
    required this.name,
  });

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
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

