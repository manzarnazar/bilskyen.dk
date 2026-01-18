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
  static const String authRevokeSession = 'auth/revoke-session';
  static const String authChangePassword = 'auth/change-password';
}

