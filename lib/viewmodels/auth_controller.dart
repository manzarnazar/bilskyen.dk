import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/api_client.dart';
import '../utils/token_storage.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  
  final RxBool isDarkMode = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoginPasswordVisible = false.obs;
  final RxBool agreeToTerms = false.obs;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final RxString accessToken = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isInitializing = true.obs;

  @override
  void onInit() {
    super.onInit();
    // Check system theme preference
    isDarkMode.value = Get.isDarkMode;
    // Restore token and user on app start
    _restoreSession();
  }
  
  // Restore session from stored token
  Future<void> _restoreSession() async {
    isInitializing.value = true;
    try {
      final hasToken = await TokenStorage.hasToken();
      if (hasToken) {
        final token = await TokenStorage.getAccessToken();
        if (token != null) {
          accessToken.value = token;
          // Try to get current user to validate token
          try {
            final user = await _authService.getCurrentUser();
            currentUser.value = user;
          } catch (e) {
            // Token is invalid, clear it
            await TokenStorage.clearTokens();
            accessToken.value = '';
          }
        }
      }
    } catch (e) {
      // Error restoring session, clear tokens
      await TokenStorage.clearTokens();
    } finally {
      isInitializing.value = false;
    }
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(
      isDarkMode.value ? ThemeMode.dark : ThemeMode.light,
    );
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleLoginPasswordVisibility() {
    isLoginPasswordVisible.value = !isLoginPasswordVisible.value;
  }

  void toggleTermsAgreement() {
    agreeToTerms.value = !agreeToTerms.value;
  }

  Future<void> register({
    required String fullName,
    required String email,
    required String password,
  }) async {
    if (!agreeToTerms.value) {
      Get.snackbar(
        'Error',
        'Please agree to the Terms and Privacy Policy',
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;
    try {
      final response = await _authService.register(
        name: fullName,
        email: email,
        password: password,
      );

      // Store user and token
      currentUser.value = response['user'] as UserModel;
      accessToken.value = response['access_token'] as String;

      Get.snackbar(
        'Success',
        'Registration successful!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to home after successful registration
      Get.offAllNamed('/home');
    } on ApiException catch (e) {
      // Handle validation errors
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        errorMessage = e.getAllErrors();
      }
      
      Get.snackbar(
        'Registration Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Registration failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;
    try {
      final response = await _authService.login(
        email: email,
        password: password,
      );

      // Store user and token
      currentUser.value = response['user'] as UserModel;
      accessToken.value = response['access_token'] as String;

      Get.snackbar(
        'Success',
        'Login successful!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );

      // Navigate to home after successful login
      Get.offAllNamed('/home');
    } on ApiException catch (e) {
      // Handle validation errors
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        errorMessage = e.getAllErrors();
      }
      
      Get.snackbar(
        'Login Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signInWithGoogle() async {
    // TODO: Implement Google Sign In
    Get.snackbar(
      'Info',
      'Google Sign In coming soon',
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> signInWithApple() async {
    // TODO: Implement Apple Sign In
    Get.snackbar(
      'Info',
      'Apple Sign In coming soon',
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> logout() async {
    isLoading.value = true;
    try {
      await _authService.logout();
    } catch (e) {
      // Continue with logout even if API call fails
    } finally {
      currentUser.value = null;
      accessToken.value = '';
      await TokenStorage.clearTokens();
      isLoading.value = false;
      Get.offAllNamed('/login');
    }
  }
  
  Future<void> signOut() async {
    isLoading.value = true;
    try {
      await _authService.signOut();
    } catch (e) {
      // Continue with sign out even if API call fails
    } finally {
      currentUser.value = null;
      accessToken.value = '';
      await TokenStorage.clearTokens();
      isLoading.value = false;
      Get.offAllNamed('/login');
    }
  }
  
  Future<void> updateUser(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final updatedUser = await _authService.updateUser(data);
      currentUser.value = updatedUser;
      
      Get.snackbar(
        'Success',
        'Profile updated successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on ApiException catch (e) {
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        errorMessage = e.getAllErrors();
      }
      
      Get.snackbar(
        'Update Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
  }) async {
    isLoading.value = true;
    try {
      await _authService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
      );
      
      Get.snackbar(
        'Success',
        'Password changed successfully!',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } on ApiException catch (e) {
      String errorMessage = e.message;
      if (e.errors != null && e.errors!.isNotEmpty) {
        errorMessage = e.getAllErrors();
      }
      
      Get.snackbar(
        'Change Password Failed',
        errorMessage,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to change password: ${e.toString()}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
  
  Future<void> refreshCurrentUser() async {
    try {
      final user = await _authService.getCurrentUser();
      currentUser.value = user;
    } catch (e) {
      // If getting user fails, token might be invalid
      if (e is ApiException && e.statusCode == 401) {
        await logout();
      }
    }
  }

  bool get isAuthenticated => currentUser.value != null && accessToken.value.isNotEmpty;
}
