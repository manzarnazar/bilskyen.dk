class VehicleImageModel {
  final int id;
  final int vehicleId;
  final String imagePath;
  final String? thumbnailPath;
  final int sortOrder;

  VehicleImageModel({
    required this.id,
    required this.vehicleId,
    required this.imagePath,
    this.thumbnailPath,
    this.sortOrder = 0,
  });

  // Base URL for images - Laravel storage path
  static String baseUrl = 'https://bilskyen.dk/storage';

  // Check if base URL is configured (not a placeholder)
  static bool get isBaseUrlConfigured => 
      baseUrl != 'https://your-domain.com/storage' && 
      !baseUrl.contains('your-domain.com');

  String get imageUrl => '$baseUrl/$imagePath';

  String get thumbnailUrl {
    if (thumbnailPath != null && thumbnailPath!.isNotEmpty) {
      return '$baseUrl/$thumbnailPath';
    }
    // Fallback to full image if thumbnail doesn't exist
    return imageUrl;
  }

  // Check if image URL is valid (not a placeholder)
  bool get hasValidUrl => isBaseUrlConfigured && imagePath.isNotEmpty;

  factory VehicleImageModel.fromJson(Map<String, dynamic> json) {
    return VehicleImageModel(
      id: json['id'] as int,
      vehicleId: json['vehicle_id'] as int,
      imagePath: json['image_path'] as String,
      thumbnailPath: json['thumbnail_path'] as String?,
      sortOrder: json['sort_order'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicle_id': vehicleId,
      'image_path': imagePath,
      'thumbnail_path': thumbnailPath,
      'sort_order': sortOrder,
    };
  }
}

