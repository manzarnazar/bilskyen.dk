class TransmissionModel {
  final int id;
  final String name;

  TransmissionModel({
    required this.id,
    required this.name,
  });

  factory TransmissionModel.fromJson(Map<String, dynamic> json) {
    return TransmissionModel(
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

