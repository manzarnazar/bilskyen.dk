class UserModel {
  final int id;
  final String name;
  final String email;
  final List<String> roles;
  final bool emailVerified;
  final String? phone;
  final String? address;
  final String? image;
  final bool banned;
  final String? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.roles,
    required this.emailVerified,
    this.phone,
    this.address,
    this.image,
    this.banned = false,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      emailVerified: json['emailVerified'] as bool? ?? false,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      image: json['image'] as String?,
      banned: json['banned'] as bool? ?? false,
      createdAt: json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'roles': roles,
      'emailVerified': emailVerified,
      'phone': phone,
      'address': address,
      'image': image,
      'banned': banned,
      'created_at': createdAt,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    List<String>? roles,
    bool? emailVerified,
    String? phone,
    String? address,
    String? image,
    bool? banned,
    String? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      roles: roles ?? this.roles,
      emailVerified: emailVerified ?? this.emailVerified,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      image: image ?? this.image,
      banned: banned ?? this.banned,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

