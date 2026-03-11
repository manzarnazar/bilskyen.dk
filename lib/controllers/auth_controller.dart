import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bilskyen/gen_l10n/app_localizations.dart';
import 'package:bilskyen/main.dart';
import 'package:bilskyen/models/auth_model/register_model.dart';
import 'package:bilskyen/models/auth_model/user_model.dart';
import 'package:bilskyen/repositories/auth/auth_repository.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository = AuthRepository();

  /// Reactive current user so ProfileView and others update when profile is edited.
  final Rxn<UserModel> currentUser = Rxn<UserModel>();

  final RxBool isDarkMode = false.obs;
  final RxBool isPasswordVisible = false.obs;
  final RxBool isLoginPasswordVisible = false.obs;
  final RxBool agreeToTerms = false.obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = Get.isDarkMode;
    _loadUserFromStorage();
  }

  void _loadUserFromStorage() {
    try {
      final userJson = appStorage.read('user');
      if (userJson != null) {
        final userMap = jsonDecode(userJson.toString()) as Map<String, dynamic>;
        currentUser.value = UserModel.fromJson(userMap);
      }
    } catch (_) {}
  }

  /// Fetch current user from API (GET auth/me). Updates currentUser and storage on success.
  /// Returns the user on success, null on failure.
  Future<UserModel?> fetchCurrentUser() async {
    final result = await _authRepository.me();
    return result.fold(
      (_) => null,
      (user) {
        currentUser.value = user;
        return user;
      },
    );
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
      final ctx = Get.context;
      final title = ctx != null ? AppLocalizations.of(ctx)!.error : 'Error';
      final msg = ctx != null ? AppLocalizations.of(ctx)!.pleaseAgreeTerms : 'Please agree to the Terms and Privacy Policy';
      Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
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
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.registrationFailed : 'Registration Failed';
        Get.snackbar(
          title,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (success) {
        _loadUserFromStorage();
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.success : 'Success';
        final msg = ctx != null ? AppLocalizations.of(ctx)!.registrationSuccess : 'Registration successful!';
        Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
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
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.loginFailed : 'Login Failed';
        Get.snackbar(
          title,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (user) {
        currentUser.value = user;
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.success : 'Success';
        final msg = ctx != null ? AppLocalizations.of(ctx)!.welcomeBackWithName(user.name) : 'Welcome back, ${user.name}!';
        Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
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
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.logoutFailed : 'Logout Failed';
        Get.snackbar(title, error, snackPosition: SnackPosition.TOP);
      },
      (success) {
        currentUser.value = null;
        Get.offAllNamed('/login');
      },
    );
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    String? address,
    String? postcode,
  }) async {
    isLoading.value = true;

    final result = await _authRepository.updateUser(
      name: name,
      phone: phone,
      address: address,
      postcode: postcode,
    );

    isLoading.value = false;

    result.fold(
      (error) {
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.updateFailed : 'Update failed';
        Get.snackbar(
          title,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (user) {
        currentUser.value = user;
        Get.back();
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.success : 'Success';
        final msg = ctx != null ? AppLocalizations.of(ctx)!.changesSavedSuccess : 'Changes saved successfully';
        Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
      },
    );
  }

  Future<void> signOut() async {
    isLoading.value = true;

    final result = await _authRepository.signOut();
    
    isLoading.value = false;

    result.fold(
      (error) {
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.logoutFailed : 'Sign Out Failed';
        Get.snackbar(
          title,
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (success) {
        currentUser.value = null;
        Get.offAllNamed('/login');
      },
    );
  }

  Future<void> deleteAccount({required String password}) async {
    isLoading.value = true;

    final result = await _authRepository.deleteAccount(password: password);

    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Delete account failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (_) {
        currentUser.value = null;
        Get.snackbar(
          'Account deleted',
          'Your account has been deleted successfully.',
          snackPosition: SnackPosition.TOP,
        );
        Get.offAllNamed('/login');
      },
    );
  }

  Future<void> forgetPassword({required String email}) async {
    isLoading.value = true;

    final result = await _authRepository.forgetPassword(email: email);

    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Request failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (_) {
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.resetLinkSent : 'Check your email';
        final msg = ctx != null ? AppLocalizations.of(ctx)!.checkEmail : 'If that email is in our system, we\'ll send you a password reset link.';
        Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
      },
    );
  }

  /// Change password (from profile when logged in)
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;

    final result = await _authRepository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      passwordConfirmation: passwordConfirmation,
    );

    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Change password failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (_) {
        Get.back();
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.success : 'Success';
        final msg = ctx != null ? AppLocalizations.of(ctx)!.passwordResetSuccessMessage : 'Your password has been changed.';
        Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
      },
    );
  }

  Future<void> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    isLoading.value = true;

    final result = await _authRepository.resetPassword(
      email: email,
      token: token,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    isLoading.value = false;

    result.fold(
      (error) {
        Get.snackbar(
          'Reset failed',
          error,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Get.theme.colorScheme.error,
          colorText: Get.theme.colorScheme.onError,
        );
      },
      (_) {
        final ctx = Get.context;
        final title = ctx != null ? AppLocalizations.of(ctx)!.passwordResetSuccess : 'Password reset';
        final msg = ctx != null ? AppLocalizations.of(ctx)!.passwordResetSuccessMessage : 'Your password has been reset. You can now sign in.';
        Get.snackbar(title, msg, snackPosition: SnackPosition.TOP);
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

