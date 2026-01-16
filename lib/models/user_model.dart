import 'user_status_model.dart';

class UserModel {
  final int id;
  final String name;
  final String email;
  final String? phone;
  final int statusId;
  final DateTime? emailVerifiedAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  // Cached status name (from lookup)
  String? _statusName;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.statusId,
    this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
    String? statusName,
  }) : _statusName = statusName;

  String get statusName {
    if (_statusName != null) return _statusName!;
    // Fallback to status ID if name not available
    switch (statusId) {
      case UserStatusModel.ACTIVE:
        return 'Active';
      case UserStatusModel.INACTIVE:
        return 'Inactive';
      case UserStatusModel.SUSPENDED:
        return 'Suspended';
      default:
        return 'Unknown';
    }
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] ?? 0) as int,
      name: (json['name'] ?? '') as String,
      email: (json['email'] ?? '') as String,
      phone: json['phone'] as String?,
      statusId: (json['status_id'] ?? 1) as int, // Default to ACTIVE if null
      emailVerifiedAt: json['email_verified_at'] != null
          ? DateTime.parse(json['email_verified_at'] as String)
          : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : DateTime.now(),
      statusName: json['status_name'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'status_id': statusId,
      'email_verified_at': emailVerifiedAt?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'status_name': statusName,
    };
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    int? statusId,
    DateTime? emailVerifiedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? statusName,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      statusId: statusId ?? this.statusId,
      emailVerifiedAt: emailVerifiedAt ?? this.emailVerifiedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      statusName: statusName ?? _statusName,
    );
  }
}

