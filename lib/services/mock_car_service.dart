import '../models/car_model.dart';

class MockCarService {
  static List<CarModel> getMockCars() {
    return [
      CarModel(
        id: '1',
        brand: 'Maruti Suzuki',
        model: 'Swift',
        variant: 'VDi Diesel',
        year: 2017,
        registrationNumber: 'XY67 ZZZ',
        price: 400000,
        transmission: 'Manual',
        fuelType: 'Diesel',
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAtfGybpW1BfbRiP22YvQe0_TU4J32lDJ9mjQ4TDqPXbcsjwYW1-TTL5VcU8oLXcVH0AXV_Bdj8w0dQ-TOpKHNRUa3ry4BR651AO59Q1MZ9JlZDAmI7YwyL0Vp1v_xB57QFO_HYRh_PSdewvHap3xPxv90qUaMGPHgU8Lil478HPB8veSASd7_l-IEbdN0_ZatnRTFQF3FB4gf3SWslscUwuu9eA-Qteb19ZVN8IB-L30b5hUvNzqk2EXmUbSlSf6AqaORbQkN9',
        mileage: 48500,
        isVerified: true,
        isFavorite: false,
      ),
      CarModel(
        id: '2',
        brand: 'Hyundai',
        model: 'i20',
        variant: 'Sportz',
        year: 2016,
        registrationNumber: 'QR09 LMP',
        price: 420000,
        transmission: 'Manual',
        fuelType: 'Petrol',
        mileage: 62300,
        isVerified: false,
        isFavorite: false,
      ),
      CarModel(
        id: '3',
        brand: 'Mercedes-Benz',
        model: 'C 200',
        variant: 'CGI Elegance',
        year: 2014,
        registrationNumber: 'AB12 CDE',
        price: 650000,
        transmission: 'Automatic',
        fuelType: 'Petrol',
        mileage: 72400,
        isVerified: false,
        isFavorite: false,
      ),
      CarModel(
        id: '4',
        brand: 'Toyota',
        model: 'Fortuner',
        variant: '2.8L 4x4 AT',
        year: 2021,
        registrationNumber: '7PSA975',
        price: 3250000,
        transmission: 'Automatic',
        fuelType: 'Diesel',
        mileage: 15000,
        imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAtfGybpW1BfbRiP22YvQe0_TU4J32lDJ9mjQ4TDqPXbcsjwYW1-TTL5VcU8oLXcVH0AXV_Bdj8w0dQ-TOpKHNRUa3ry4BR651AO59Q1MZ9JlZDAmI7YwyL0Vp1v_xB57QFO_HYRh_PSdewvHap3xPxv90qUaMGPHgU8Lil478HPB8veSASd7_l-IEbdN0_ZatnRTFQF3FB4gf3SWslscUwuu9eA-Qteb19ZVN8IB-L30b5hUvNzqk2EXmUbSlSf6AqaORbQkN9',
        isVerified: false,
        isFavorite: false,
      ),
      // Additional mock cars to reach 124 total
      ...List.generate(120, (index) {
        final brands = ['Maruti Suzuki', 'Hyundai', 'Honda', 'Toyota', 'Mahindra', 'Tata', 'Ford', 'Volkswagen'];
        final models = ['Swift', 'i20', 'City', 'Innova', 'XUV500', 'Nexon', 'EcoSport', 'Polo'];
        final transmissions = ['Manual', 'Automatic'];
        final fuelTypes = ['Petrol', 'Diesel'];
        
        final brandIndex = index % brands.length;
        final modelIndex = index % models.length;
        
        return CarModel(
          id: '${index + 5}',
          brand: brands[brandIndex],
          model: models[modelIndex],
          variant: '${models[modelIndex]} ${index % 3 + 1}',
          year: 2015 + (index % 8),
          registrationNumber: '${String.fromCharCode(65 + (index % 26))}${String.fromCharCode(65 + ((index + 1) % 26))}${(index % 100).toString().padLeft(2, '0')} ${String.fromCharCode(65 + ((index + 2) % 26))}${String.fromCharCode(65 + ((index + 3) % 26))}${String.fromCharCode(65 + ((index + 4) % 26))}',
          price: 300000 + (index * 50000),
          transmission: transmissions[index % 2],
          fuelType: fuelTypes[index % 2],
          mileage: 20000 + (index * 5000),
          isVerified: index % 3 == 0,
          isFavorite: false,
        );
      }),
    ];
  }

  static List<CarModel> searchCars(List<CarModel> cars, String query) {
    if (query.isEmpty) return cars;
    
    final lowerQuery = query.toLowerCase();
    return cars.where((car) {
      return car.brand.toLowerCase().contains(lowerQuery) ||
          car.model.toLowerCase().contains(lowerQuery) ||
          car.variant.toLowerCase().contains(lowerQuery);
    }).toList();
  }

  static List<CarModel> filterCars({
    required List<CarModel> cars,
    String? priceRange,
    String? brand,
    int? year,
    String? fuelType,
  }) {
    var filtered = cars;

    if (priceRange != null) {
      // Simple price filtering - can be enhanced
      final ranges = priceRange.split('-');
      if (ranges.length == 2) {
        final min = double.tryParse(ranges[0]);
        final max = double.tryParse(ranges[1]);
        if (min != null && max != null) {
          filtered = filtered.where((car) => car.price >= min && car.price <= max).toList();
        }
      }
    }

    if (brand != null && brand.isNotEmpty) {
      filtered = filtered.where((car) => car.brand == brand).toList();
    }

    if (year != null) {
      filtered = filtered.where((car) => car.year == year).toList();
    }

    if (fuelType != null && fuelType.isNotEmpty) {
      filtered = filtered.where((car) => car.fuelType == fuelType).toList();
    }

    return filtered;
  }
}

