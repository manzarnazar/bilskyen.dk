class InquiryModel {
  final int id;
  final int vehicleId;
  final String? vehicleTitle;
  final String? name;
  final String? email;
  final String? message;
  final String? subject;
  final String? type;
  final String createdAt;

  InquiryModel({
    required this.id,
    required this.vehicleId,
    this.vehicleTitle,
    this.name,
    this.email,
    this.message,
    this.subject,
    this.type,
    required this.createdAt,
  });

  /// Display name: name or "Anonymous"
  String get displayName => (name != null && name!.trim().isNotEmpty) ? name!.trim() : 'Anonymous';

  /// Display email: email or "No email"
  String get displayEmail => (email != null && email!.trim().isNotEmpty) ? email!.trim() : 'No email';

  /// Human-readable type e.g. "Price Enquiry"
  String get displayType {
    if (type == null || type!.trim().isEmpty) return 'Inquiry';
    final t = type!.trim().toLowerCase();
    if (t.contains('price')) return 'Price Enquiry';
    if (t.contains('test') || t.contains('drive')) return 'Test Drive';
    if (t.contains('general')) return 'General Enquiry';
    return type!.trim().split(' ').map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1)}').join(' ');
  }

  factory InquiryModel.fromJson(Map<String, dynamic> json) {
    final vehicle = json['vehicle'] as Map<String, dynamic>?;
    return InquiryModel(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      vehicleTitle: vehicle?['title'] as String?,
      name: json['name'] as String?,
      email: json['email'] as String?,
      message: json['message'] as String?,
      subject: json['subject'] as String?,
      type: json['type'] as String?,
      createdAt: json['created_at'] as String? ?? '',
    );
  }
}
