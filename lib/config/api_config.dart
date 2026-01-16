class ApiConfig {
  // Base URL - Update this with your backend URL
  // For development: 'http://localhost:8000' or 'http://10.0.2.2:8000' (Android emulator)
  // For production: 'https://your-domain.com'
  static const String baseUrl = 'https://bilskyen.dk';
  
  // API version prefix
  static const String apiVersion = '/api/v1';
  
  // Full API base URL
  static String get apiBaseUrl => '$baseUrl$apiVersion';
  
  // Auth endpoints
  static const String authRegister = '/auth/register';
  static const String authLogin = '/auth/login';
  static const String authLogout = '/auth/logout';
  static const String authMe = '/auth/me';
  static const String authRefresh = '/auth/refresh';
  static const String authUpdateUser = '/auth/update-user';
  static const String authChangePassword = '/auth/change-password';
  static const String authGetSession = '/auth/get-session';
  static const String authRevokeSession = '/auth/revoke-session';
  static const String authSignOut = '/auth/sign-out';
  
  // Vehicle endpoints
  static const String vehicles = '/vehicles';
  
  // Headers
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';
  static const String authorizationHeader = 'Authorization';
  static const String idempotencyKeyHeader = 'Idempotency-Key';
  
  static const String contentTypeJson = 'application/json';
  static const String acceptJson = 'application/json';
  
  // Token storage keys
  static const String accessTokenKey = 'access_token';
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);
}

