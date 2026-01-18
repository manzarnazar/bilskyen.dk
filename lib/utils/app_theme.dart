import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardLight,
        background: AppColors.backgroundLight,
        error: AppColors.destructive,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.textLight,
        onBackground: AppColors.textLight,
        onError: AppColors.destructiveForeground,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderLight),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.primaryForeground),
        titleTextStyle: TextStyle(
          color: AppColors.primaryForeground,
          fontFamily: 'Poppins',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.inputBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        fillColor: AppColors.backgroundLight,
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textLight,
          side: const BorderSide(color: AppColors.borderLight),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins'),
        displayMedium: TextStyle(fontFamily: 'Poppins'),
        displaySmall: TextStyle(fontFamily: 'Poppins'),
        headlineLarge: TextStyle(fontFamily: 'Poppins'),
        headlineMedium: TextStyle(fontFamily: 'Poppins'),
        headlineSmall: TextStyle(fontFamily: 'Poppins'),
        titleLarge: TextStyle(fontFamily: 'Poppins'),
        titleMedium: TextStyle(fontFamily: 'Poppins'),
        titleSmall: TextStyle(fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        bodySmall: TextStyle(fontFamily: 'Poppins'),
        labelLarge: TextStyle(fontFamily: 'Poppins'),
        labelMedium: TextStyle(fontFamily: 'Poppins'),
        labelSmall: TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      fontFamily: 'Poppins',
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.cardDark,
        background: AppColors.backgroundDark,
        error: AppColors.destructive,
        onPrimary: AppColors.primaryForeground,
        onSecondary: AppColors.secondaryForeground,
        onSurface: AppColors.textDark,
        onBackground: AppColors.textDark,
        onError: AppColors.destructiveForeground,
      ),
      cardTheme: CardThemeData(
        color: AppColors.cardDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.borderDark),
        ),
      ),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: AppColors.primary,
        iconTheme: IconThemeData(color: AppColors.primaryForeground),
        titleTextStyle: TextStyle(
          color: AppColors.primaryForeground,
          fontFamily: 'Poppins',
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.borderDark),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        fillColor: AppColors.cardDark,
        filled: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.primaryForeground,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textDark,
          side: const BorderSide(color: AppColors.borderDark),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontFamily: 'Poppins'),
        displayMedium: TextStyle(fontFamily: 'Poppins'),
        displaySmall: TextStyle(fontFamily: 'Poppins'),
        headlineLarge: TextStyle(fontFamily: 'Poppins'),
        headlineMedium: TextStyle(fontFamily: 'Poppins'),
        headlineSmall: TextStyle(fontFamily: 'Poppins'),
        titleLarge: TextStyle(fontFamily: 'Poppins'),
        titleMedium: TextStyle(fontFamily: 'Poppins'),
        titleSmall: TextStyle(fontFamily: 'Poppins'),
        bodyLarge: TextStyle(fontFamily: 'Poppins'),
        bodyMedium: TextStyle(fontFamily: 'Poppins'),
        bodySmall: TextStyle(fontFamily: 'Poppins'),
        labelLarge: TextStyle(fontFamily: 'Poppins'),
        labelMedium: TextStyle(fontFamily: 'Poppins'),
        labelSmall: TextStyle(fontFamily: 'Poppins'),
      ),
    );
  }
}

