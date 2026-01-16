import '../models/car_model.dart';
import '../services/mock_car_service.dart';

class CarRepository {
  final List<CarModel> _allCars = MockCarService.getMockCars();

  Future<List<CarModel>> getAllCars() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    return _allCars;
  }

  Future<List<CarModel>> searchCars(String query) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockCarService.searchCars(_allCars, query);
  }

  Future<List<CarModel>> filterCars({
    required List<CarModel> cars,
    String? priceRange,
    String? brand,
    int? year,
    String? fuelType,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return MockCarService.filterCars(
      cars: cars,
      priceRange: priceRange,
      brand: brand,
      year: year,
      fuelType: fuelType,
    );
  }

  Future<void> toggleFavorite(String carId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _allCars.indexWhere((car) => car.id == carId);
    if (index != -1) {
      _allCars[index] = _allCars[index].copyWith(
        isFavorite: !_allCars[index].isFavorite,
      );
    }
  }

  int get totalCars => _allCars.length;
}

