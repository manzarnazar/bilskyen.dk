class CarModel {
  final String id;
  final String brand;
  final String model;
  final String variant;
  final int year;
  final String registrationNumber;
  final double price;
  final String transmission; // Manual, Automatic
  final String fuelType; // Petrol, Diesel, Electric
  final int mileage; // in km
  final String? imageUrl;
  final bool isVerified;
  final bool isFavorite;

  CarModel({
    required this.id,
    required this.brand,
    required this.model,
    required this.variant,
    required this.year,
    required this.registrationNumber,
    required this.price,
    required this.transmission,
    required this.fuelType,
    required this.mileage,
    this.imageUrl,
    this.isVerified = false,
    this.isFavorite = false,
  });

  String get fullName => '$brand $model';
  
  String get displayInfo => '$variant • $year';
  
  String get formattedPrice => '₹${_formatPrice(price)}';
  
  String _formatPrice(double price) {
    // Format as ₹4,00,000 style (Indian numbering system)
    // Indian system: first 3 digits, then groups of 2
    final priceString = price.toStringAsFixed(0);
    if (priceString.length <= 3) {
      return priceString;
    }
    
    final reversed = priceString.split('').reversed.toList();
    final buffer = StringBuffer();
    
    for (int i = 0; i < reversed.length; i++) {
      if (i == 3) {
        // After first 3 digits, add comma
        buffer.write(',');
      } else if (i > 3 && (i - 3) % 2 == 0) {
        // Then every 2 digits
        buffer.write(',');
      }
      buffer.write(reversed[i]);
    }
    
    return buffer.toString().split('').reversed.join();
  }

  CarModel copyWith({
    String? id,
    String? brand,
    String? model,
    String? variant,
    int? year,
    String? registrationNumber,
    double? price,
    String? transmission,
    String? fuelType,
    int? mileage,
    String? imageUrl,
    bool? isVerified,
    bool? isFavorite,
  }) {
    return CarModel(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      variant: variant ?? this.variant,
      year: year ?? this.year,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      price: price ?? this.price,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
      imageUrl: imageUrl ?? this.imageUrl,
      isVerified: isVerified ?? this.isVerified,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

