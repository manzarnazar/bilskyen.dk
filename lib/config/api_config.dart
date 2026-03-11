class ApiConfig {
  // Base URL for the API
  // Can be overridden via environment variable or build configuration
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://bilskyen.dk/api/v1/',
  );

  // API endpoints (relative to baseUrl)
  static const String authRegister = 'auth/register';
  static const String authLogin = 'auth/login';
  static const String authRefresh = 'auth/refresh';
  static const String authLogout = 'auth/logout';
  static const String authMe = 'auth/me';
  static const String authSignOut = 'auth/sign-out';
  static const String authUpdateUser = 'auth/update-user';
  static const String authProfile = 'auth/profile';
  static const String authForgetPassword = 'auth/forget-password';
  static const String authResetPassword = 'auth/reset-password';
  static const String authAccount = 'auth/account';
  static const String authRevokeSession = 'auth/revoke-session';
  static const String authChangePassword = 'auth/change-password';
  
  // Vehicle endpoints
  static const String featuredVehicles = 'featured-vehicles';
  static const String vehicles = 'vehicles';
  static const String searchVehicles = 'search-vehicles';
  static String vehicleDetail(int id) => 'vehicles/$id';
  static String vehicleLeads(int id) => 'vehicles/$id/leads';
  static String vehicleEnquiries(int id) => 'vehicles/$id/enquiries';
  static String vehicleTestDrive(int id) => 'vehicles/$id/test-drive';
  static String vehiclePriceNegotiation(int id) => 'vehicles/$id/price-negotiation';
  static String vehicleExchange(int id) => 'vehicles/$id/exchange';
  
  // Nummerplade API endpoints
  static const String nummerpladeVehicleByRegistration = 'nummerplade/vehicle-by-registration';
  static const String nummerpladeReferenceColors = 'nummerplade/reference/colors';
  static const String nummerpladeReferenceEquipment = 'nummerplade/reference/equipment';
  
  // Lookup endpoints
  static const String variants = 'variants';
  static const String euronorms = 'euronorms';
  static const String constants = 'constants';
  
  // Sell Your Car endpoint
  static const String sellYourCar = 'sell-your-car';
  
  // Favorites endpoints
  static const String favorites = 'favorites';
  static String favoritesCheck(int vehicleId) => 'favorites/check/$vehicleId';
  static String favoritesDelete(int vehicleId) => 'favorites/delete/$vehicleId';
  static const String favoritesCheckBatch = 'favorites/check-batch';

  // Seller profile endpoints (auth required)
  static const String sellerVehicles = 'seller/vehicles';
  static String sellerVehicle(int id) => 'seller/vehicles/$id';
  static String sellerUpdateVehicle(int id) => 'seller/vehicles/$id';
  static String sellerVehicleStatus(int id) => 'seller/vehicles/$id/status';
  static String sellerDeleteVehicle(int id) => 'seller/vehicles/$id';
  static const String sellerInquiries = 'seller/inquiries';
  static String sellerInquiry(int id) => 'seller/inquiries/$id';
  static const String sellerStatistics = 'seller/statistics';
}

