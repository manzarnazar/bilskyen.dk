class UserStatusModel {
  static const int ACTIVE = 1;
  static const int INACTIVE = 2;
  static const int SUSPENDED = 3;

  final int id;
  final String name;

  UserStatusModel({
    required this.id,
    required this.name,
  });

  factory UserStatusModel.fromJson(Map<String, dynamic> json) {
    return UserStatusModel(
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

