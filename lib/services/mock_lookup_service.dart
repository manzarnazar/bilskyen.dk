import '../models/category_model.dart';
import '../models/brand_model.dart';
import '../models/model_year_model.dart';
import '../models/fuel_type_model.dart';
import '../models/transmission_model.dart';
import '../models/body_type_model.dart';
import '../models/color_model.dart';
import '../models/equipment_model.dart';
import '../models/vehicle_list_status_model.dart';

class MockLookupService {
  static List<CategoryModel> getCategories() {
    return [
      CategoryModel(id: 1, name: 'Passenger car'),
      CategoryModel(id: 2, name: 'Van incl. VAT'),
      CategoryModel(id: 3, name: 'Van excluding VAT'),
      CategoryModel(id: 4, name: 'Bus'),
      CategoryModel(id: 5, name: 'Lorry'),
      CategoryModel(id: 6, name: 'Motorhome'),
    ];
  }
  
  // Legacy categories (kept for backward compatibility)
  static List<CategoryModel> getLegacyCategories() {
    return [
      CategoryModel(id: 1, name: 'Sedan'),
      CategoryModel(id: 2, name: 'SUV'),
      CategoryModel(id: 3, name: 'Hatchback'),
      CategoryModel(id: 4, name: 'Coupe'),
      CategoryModel(id: 5, name: 'Convertible'),
      CategoryModel(id: 6, name: 'Wagon'),
      CategoryModel(id: 7, name: 'Van'),
      CategoryModel(id: 8, name: 'Pickup'),
    ];
  }

  static List<BrandModel> getBrands() {
    return [
      BrandModel(id: 1, name: 'Volkswagen'),
      BrandModel(id: 2, name: 'Toyota'),
      BrandModel(id: 3, name: 'BMW'),
      BrandModel(id: 4, name: 'Mercedes-Benz'),
      BrandModel(id: 5, name: 'Audi'),
      BrandModel(id: 6, name: 'Ford'),
      BrandModel(id: 7, name: 'Peugeot'),
      BrandModel(id: 8, name: 'Opel'),
      BrandModel(id: 9, name: 'Skoda'),
      BrandModel(id: 10, name: 'Hyundai'),
      BrandModel(id: 11, name: 'Nissan'),
      BrandModel(id: 12, name: 'Kia'),
      BrandModel(id: 13, name: 'Tesla'),
      BrandModel(id: 14, name: 'Volvo'),
      BrandModel(id: 15, name: 'Renault'),
      BrandModel(id: 16, name: 'Citroën'),
    ];
  }
  
  // Popular brands (top 5)
  static List<BrandModel> getPopularBrands() {
    return [
      BrandModel(id: 1, name: 'Volkswagen'),
      BrandModel(id: 2, name: 'Toyota'),
      BrandModel(id: 3, name: 'BMW'),
      BrandModel(id: 4, name: 'Mercedes-Benz'),
      BrandModel(id: 5, name: 'Audi'),
    ];
  }

  static List<ModelYearModel> getModelYears() {
    final years = <ModelYearModel>[];
    for (int year = 2010; year <= 2024; year++) {
      years.add(ModelYearModel(id: year - 2000, name: year.toString()));
    }
    return years;
  }

  static List<FuelTypeModel> getFuelTypes() {
    return [
      FuelTypeModel(id: 1, name: 'petrol'),
      FuelTypeModel(id: 2, name: 'diesel'),
      FuelTypeModel(id: 3, name: 'electric'),
      FuelTypeModel(id: 4, name: 'hybrid_petrol'),
      FuelTypeModel(id: 5, name: 'hybrid_diesel'),
      FuelTypeModel(id: 6, name: 'plugin_petrol'),
      FuelTypeModel(id: 7, name: 'plugin_diesel'),
    ];
  }

  static List<TransmissionModel> getTransmissions() {
    return [
      TransmissionModel(id: 1, name: 'Manual'),
      TransmissionModel(id: 2, name: 'Automatic'),
      TransmissionModel(id: 3, name: 'CVT'),
      TransmissionModel(id: 4, name: 'Semi-Automatic'),
    ];
  }

  static List<BodyTypeModel> getBodyTypes() {
    return [
      BodyTypeModel(id: 1, name: 'micro'),
      BodyTypeModel(id: 2, name: 'stationcar'),
      BodyTypeModel(id: 3, name: 'suv'),
      BodyTypeModel(id: 4, name: 'cuv'),
      BodyTypeModel(id: 5, name: 'mpv'),
      BodyTypeModel(id: 6, name: 'sedan'),
      BodyTypeModel(id: 7, name: 'hatchback'),
      BodyTypeModel(id: 8, name: 'cabriolet'),
      BodyTypeModel(id: 9, name: 'coupe'),
    ];
  }

  static List<ColorModel> getColors() {
    return [
      ColorModel(id: 1, name: 'Black'),
      ColorModel(id: 2, name: 'White'),
      ColorModel(id: 3, name: 'Silver'),
      ColorModel(id: 4, name: 'Gray'),
      ColorModel(id: 5, name: 'Blue'),
      ColorModel(id: 6, name: 'Red'),
      ColorModel(id: 7, name: 'Green'),
      ColorModel(id: 8, name: 'Brown'),
      ColorModel(id: 9, name: 'Beige'),
      ColorModel(id: 10, name: 'Yellow'),
      ColorModel(id: 11, name: 'Orange'),
    ];
  }

  static List<EquipmentModel> getEquipment() {
    return [
      EquipmentModel(id: 1, name: 'Air Conditioning'),
      EquipmentModel(id: 2, name: 'Power Steering'),
      EquipmentModel(id: 3, name: 'Central Locking'),
      EquipmentModel(id: 4, name: 'Power Windows'),
      EquipmentModel(id: 5, name: 'ABS'),
      EquipmentModel(id: 6, name: 'ESP'),
      EquipmentModel(id: 7, name: 'Airbags'),
      EquipmentModel(id: 8, name: 'Sunroof'),
      EquipmentModel(id: 9, name: 'Leather Seats'),
      EquipmentModel(id: 10, name: 'Navigation System'),
      EquipmentModel(id: 11, name: 'Bluetooth'),
      EquipmentModel(id: 12, name: 'Parking Sensors'),
      EquipmentModel(id: 13, name: 'Backup Camera'),
      EquipmentModel(id: 14, name: 'Cruise Control'),
      EquipmentModel(id: 15, name: 'Keyless Entry'),
    ];
  }

  static List<VehicleListStatusModel> getVehicleListStatuses() {
    return [
      VehicleListStatusModel(id: VehicleListStatusModel.DRAFT, name: 'Draft'),
      VehicleListStatusModel(id: VehicleListStatusModel.PUBLISHED, name: 'Published'),
      VehicleListStatusModel(id: VehicleListStatusModel.SOLD, name: 'Sold'),
      VehicleListStatusModel(id: VehicleListStatusModel.ARCHIVED, name: 'Archived'),
    ];
  }
  
  // Drive wheel types
  static List<String> getDriveWheels() {
    return ['fwd', 'rwd', 'awd'];
  }
  
  // Charging types for EVs
  static List<String> getChargingTypes() {
    return [
      'Type 2 (AC)',
      'CCS (DC)',
      'CHAdeMO',
      'Tesla Supercharger',
      'Wallbox',
      'Standard Outlet',
    ];
  }
  
  // Energy labels
  static List<String> getEnergyLabels() {
    return ['A', 'B', 'C', 'D', 'E', 'F', 'G'];
  }
  
  // Euro norms
  static List<String> getEuroNorms() {
    return ['Euro 1', 'Euro 2', 'Euro 3', 'Euro 4', 'Euro 5', 'Euro 6', 'Euro 6d'];
  }
  
  // Listing types
  static List<String> getListingTypes() {
    return ['purchase', 'leasing'];
  }
  
  // Price types
  static List<String> getPriceTypes() {
    return ['retail', 'without_tax', 'wholesale'];
  }
  
  // Conditions
  static List<String> getConditions() {
    return ['new', 'used', 'all'];
  }
  
  // Seller types
  static List<String> getSellerTypes() {
    return ['private']; // Dealer removed from Flutter app
  }
  
  // Sales types
  static List<String> getSalesTypes() {
    return ['consignment', 'facilitated'];
  }
}

