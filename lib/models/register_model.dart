class RegisterModel {
  final String name;
  final String email;
  final String password;
  final String? phone;
  final String? address;
  final List<String>? roles;

  RegisterModel({
    required this.name,
    required this.email,
    required this.password,
    this.phone,
    this.address,
    this.roles,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'name': name,
      'email': email,
      'password': password,
    };

    if (phone != null) {
      json['phone'] = phone;
    }
    if (address != null) {
      json['address'] = address;
    }
    if (roles != null && roles!.isNotEmpty) {
      json['roles'] = roles;
    }

    return json;
  }
}

