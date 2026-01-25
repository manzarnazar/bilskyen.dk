import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:car_marketplace/models/auth_model/register_model.dart';
import 'package:car_marketplace/repositories/auth/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();
  
  final RxBool isDarkMode = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoginPasswordVisible = false.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Check system theme preference
    isDarkMode.value = Get.isDarkMode;
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
    String? phone,
    String? address,
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
    
    final registerModel = RegisterModel(
      name: fullName,
      email: email,
      password: password,
      phone: phone,
      address: address,
    );

    final result = await _authRepository.register(user: registerModel);
    
    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Registration Failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (success) {
        Get.snackbar(
          'Success',
          'Registration successful!',
          snackPosition: SnackPosition.TOP,
        );
        // Navigate to home after registration
        Get.offAllNamed('/main');
      },
    );
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    isLoading.value = true;

    final result = await _authRepository.login(
      email: email,
      password: password,
    );
    
    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Login Failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (user) {
        Get.snackbar(
          'Success',
          'Welcome back, ${user.name}!',
          snackPosition: SnackPosition.TOP,
        );
        // Navigate to home after login
        Get.offAllNamed('/main');
      },
    );
  }

  Future<void> logout() async {
    isLoading.value = true;

    final result = await _authRepository.logout();
    
    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Logout Failed',
          error,
          snackPosition: SnackPosition.TOP,
        );
      },
      (success) {
        Get.offAllNamed('/login');
      },
    );
  }

  Future<void> signOut() async {
    isLoading.value = true;

    final result = await _authRepository.signOut();
    
    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Sign Out Failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (success) {
        Get.offAllNamed('/login');
      },
    );
  }

  Future<void> signInWithGoogle() async {
    Get.snackbar(
      'Info',
      'Google Sign In coming soon',
      snackPosition: SnackPosition.TOP,
    );
  }

  Future<void> signInWithApple() async {
    Get.snackbar(
      'Info',
      'Apple Sign In coming soon',
      snackPosition: SnackPosition.TOP,
    );
  }
}

