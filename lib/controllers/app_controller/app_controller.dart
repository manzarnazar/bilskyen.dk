import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

const String _localeStorageKey = 'localeLanguageCode';

class AppController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;
  final Rx<Locale> locale = const Locale('da').obs;
  final GetStorage _storage = GetStorage();

  @override
  void onInit() {
    super.onInit();
    themeMode.value = ThemeMode.system;
    _updateDarkModeFromTheme();
    _loadSavedLocale();
  }

  void _loadSavedLocale() {
    final saved = _storage.read<String>(_localeStorageKey);
    if (saved != null && saved.isNotEmpty) {
      locale.value = Locale(saved);
    }
  }

  void setLocale(Locale value) {
    locale.value = value;
    _storage.write(_localeStorageKey, value.languageCode);
    Get.updateLocale(value);
  }

  void _updateDarkModeFromTheme() {
    // Update isDarkMode based on current theme mode for backward compatibility
    if (themeMode.value == ThemeMode.dark) {
      isDarkMode.value = true;
    } else if (themeMode.value == ThemeMode.light) {
      isDarkMode.value = false;
    } else {
      // System mode - check system preference
      final brightness = WidgetsBinding.instance.platformDispatcher.platformBrightness;
      isDarkMode.value = brightness == Brightness.dark;
    }
  }

  void toggleTheme() {
    // Cycles through themes: system -> light -> dark -> system
    if (themeMode.value == ThemeMode.system) {
      themeMode.value = ThemeMode.light;
    } else if (themeMode.value == ThemeMode.light) {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
    setThemeMode(themeMode.value);
  }

  void setThemeMode(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode);
    _updateDarkModeFromTheme();
  }
}

