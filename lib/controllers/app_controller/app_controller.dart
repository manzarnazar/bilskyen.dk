import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppController extends GetxController {
  final RxBool isDarkMode = false.obs;
  final Rx<ThemeMode> themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    themeMode.value = ThemeMode.system;
    _updateDarkModeFromTheme();
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

