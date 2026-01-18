import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:car_marketplace/config/api_config.dart';
import 'package:car_marketplace/main.dart';
import 'package:car_marketplace/models/register_model.dart';
import 'package:car_marketplace/models/user_model.dart';
import 'package:car_marketplace/network/network_repository.dart';

class AuthRepository {
  final networkRepository = NetworkRepository();

  /// Register a new user
  Future<Either<String, bool>> register({
    required RegisterModel user,
  }) async {
    final response = await networkRepository.post(
      url: ApiConfig.authRegister,
      data: user.toJson(),
    );

    if (response.success) {
      final data = response.data['data'] as Map<String, dynamic>;
      final userData = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      appStorage.write('user', jsonEncode(userData.toJson()));
      return right(true);
    }
    return left(response.message);
  }

  /// Login user with email and password
  Future<Either<String, UserModel>> login({
    required String email,
    required String password,
  }) async {
    final response = await networkRepository.post(
      url: ApiConfig.authLogin,
      data: {
        'email': email,
        'password': password,
      },
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>;
      final userData = UserModel.fromJson(data['user'] as Map<String, dynamic>);
      appStorage.write('user', jsonEncode(userData.toJson()));
      return right(userData);
    }
    return left(response.message);
  }

  /// Refresh access token
  Future<Either<String, bool>> refresh() async {
    final response = await networkRepository.post(
      url: ApiConfig.authRefresh,
      data: {},
    );

    if (!response.failed && response.success) {
      return right(true);
    }
    return left(response.message);
  }

  /// Logout user
  Future<Either<String, bool>> logout() async {
    final response = await networkRepository.post(
      url: ApiConfig.authLogout,
      data: {},
    );

    if (!response.failed && response.success) {
      await _removeUserData();
      return right(true);
    }
    return left(response.message);
  }

  /// Get current authenticated user
  Future<Either<String, UserModel>> me() async {
    final response = await networkRepository.get(
      url: ApiConfig.authMe,
    );

    if (!response.failed && response.success) {
      final data = response.data['data'] as Map<String, dynamic>;
      final userData = UserModel.fromJson(data);
      appStorage.write('user', jsonEncode(userData.toJson()));
      return right(userData);
    }
    return left(response.message);
  }

  /// Sign out (session management)
  Future<Either<String, bool>> signOut() async {
    final response = await networkRepository.post(
      url: ApiConfig.authSignOut,
      data: {},
    );

    if (!response.failed && response.success) {
      await _removeUserData();
      return right(true);
    }
    return left(response.message);
  }

  /// Update user profile
  Future<Either<String, UserModel>> updateUser({
    required String name,
    String? email,
    String? phone,
    String? address,
  }) async {
    final data = <String, dynamic>{
      'name': name,
    };

    if (email != null) {
      data['email'] = email;
    }
    if (phone != null) {
      data['phone'] = phone;
    }
    if (address != null) {
      data['address'] = address;
    }

    final response = await networkRepository.post(
      url: ApiConfig.authUpdateUser,
      data: data,
    );

    if (!response.failed && response.success) {
      final responseData = response.data['data'] as Map<String, dynamic>;
      // updateUser endpoint returns user nested in 'user' key
      final userJson = responseData['user'] as Map<String, dynamic>? ?? responseData;
      final userData = UserModel.fromJson(userJson);
      appStorage.write('user', jsonEncode(userData.toJson()));
      return right(userData);
    }
    return left(response.message);
  }

  /// Revoke current session
  Future<Either<String, bool>> revokeSession() async {
    final response = await networkRepository.post(
      url: ApiConfig.authRevokeSession,
      data: {},
    );

    if (!response.failed && response.success) {
      await _removeUserData();
      return right(true);
    }
    return left(response.message);
  }

  /// Change user password
  Future<Either<String, bool>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final response = await networkRepository.post(
      url: ApiConfig.authChangePassword,
      data: {
        'password': currentPassword,
        'newPassword': newPassword,
      },
    );

    if (!response.failed && response.success) {
      return right(true);
    }
    return left(response.message);
  }

  /// Remove user data from storage
  Future<void> _removeUserData() async {
    try {
      await appStorage.remove('user');
      await appStorage.remove('token');
      await appStorage.remove('refreshToken');
    } catch (e) {
      // Ignore errors during cleanup
    }
  }
}

