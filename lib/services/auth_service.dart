import '../config/api_config.dart';
import '../models/user_model.dart';
import '../services/api_client.dart';
import '../utils/token_storage.dart';

class AuthService {
  final ApiClient _apiClient;
  
  AuthService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();
  
  // Login
  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.authLogin,
        body: {
          'email': email,
          'password': password,
        },
        includeAuth: false,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      // Extract user and token from response
      if (response['user'] == null) {
        throw ApiException(
          message: 'Invalid response: user data is missing',
          statusCode: 0,
        );
      }
      
      if (response['access_token'] == null) {
        throw ApiException(
          message: 'Invalid response: access token is missing',
          statusCode: 0,
        );
      }
      
      UserModel user;
      try {
        user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } catch (e) {
        throw ApiException(
          message: 'Failed to parse user data: ${e.toString()}',
          statusCode: 0,
        );
      }
      
      final accessToken = response['access_token'] as String;
      
      // Store token
      await TokenStorage.saveAccessToken(accessToken);
      
      return {
        'user': user,
        'access_token': accessToken,
      };
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Login failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? idempotencyKey,
  }) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.authRegister,
        body: {
          'name': name,
          'email': email,
          'password': password,
        },
        idempotencyKey: idempotencyKey,
        includeAuth: false,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      // Extract user and token from response
      if (response['user'] == null) {
        throw ApiException(
          message: 'Invalid response: user data is missing',
          statusCode: 0,
        );
      }
      
      if (response['access_token'] == null) {
        throw ApiException(
          message: 'Invalid response: access token is missing',
          statusCode: 0,
        );
      }
      
      UserModel user;
      try {
        user = UserModel.fromJson(response['user'] as Map<String, dynamic>);
      } catch (e) {
        throw ApiException(
          message: 'Failed to parse user data: ${e.toString()}',
          statusCode: 0,
        );
      }
      
      final accessToken = response['access_token'] as String;
      
      // Store token
      await TokenStorage.saveAccessToken(accessToken);
      
      return {
        'user': user,
        'access_token': accessToken,
      };
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Registration failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(
        ApiConfig.authLogout,
        fromJson: (json) => null,
      );
    } catch (e) {
      // Continue with token clearing even if API call fails
    } finally {
      // Clear token regardless of API response
      await TokenStorage.clearTokens();
    }
  }
  
  // Get current user
  Future<UserModel> getCurrentUser() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConfig.authMe,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      return UserModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to get current user: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Refresh token
  Future<String> refreshToken() async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.authRefresh,
        includeAuth: false,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      final accessToken = response['access_token'] as String;
      
      // Store new token
      await TokenStorage.saveAccessToken(accessToken);
      
      return accessToken;
    } on ApiException {
      // If refresh fails, clear tokens
      await TokenStorage.clearTokens();
      rethrow;
    } catch (e) {
      await TokenStorage.clearTokens();
      throw ApiException(
        message: 'Token refresh failed: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Update user
  Future<UserModel> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        ApiConfig.authUpdateUser,
        body: data,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      return UserModel.fromJson(response);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to update user: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Change password
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiConfig.authChangePassword,
        body: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        fromJson: (json) => null,
      );
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to change password: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Get session
  Future<Map<String, dynamic>> getSession() async {
    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        ApiConfig.authGetSession,
        fromJson: (json) => json as Map<String, dynamic>,
      );
      
      return response;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
        message: 'Failed to get session: ${e.toString()}',
        statusCode: 0,
      );
    }
  }
  
  // Revoke session
  Future<void> revokeSession() async {
    try {
      await _apiClient.post(
        ApiConfig.authRevokeSession,
        fromJson: (json) => null,
      );
    } catch (e) {
      // Continue with token clearing even if API call fails
    } finally {
      // Clear token regardless of API response
      await TokenStorage.clearTokens();
    }
  }
  
  // Sign out
  Future<void> signOut() async {
    try {
      await _apiClient.post(
        ApiConfig.authSignOut,
        fromJson: (json) => null,
      );
    } catch (e) {
      // Continue with token clearing even if API call fails
    } finally {
      // Clear token regardless of API response
      await TokenStorage.clearTokens();
    }
  }
  
  // Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final hasToken = await TokenStorage.hasToken();
    if (!hasToken) return false;
    
    try {
      // Try to get current user to validate token
      await getCurrentUser();
      return true;
    } catch (e) {
      // Token is invalid, clear it
      await TokenStorage.clearTokens();
      return false;
    }
  }
}

