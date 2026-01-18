import 'package:flutter/material.dart';

/// Bilskyen Brand Colors
/// Based on brand-guide.md
class AppColors {
  // Primary Brand Colors
  /// Main primary color: #004aad
  /// Usage: Main brand color used for navigation bars, footers, primary buttons, links, and key UI elements
  static const Color primary = Color(0xFF004aad);
  
  /// Primary dark variant: #002d6b
  /// Usage: Darker variant for buttons that need more prominence (e.g., Login button, user menu avatar)
  static const Color primaryDark = Color(0xFF002d6b);
  
  /// Primary medium variant: #003a8d
  /// Usage: Intermediate dark variant (if needed for gradients or hover states)
  static const Color primaryMedium = Color(0xFF003a8d);
  
  /// Primary foreground: near white
  /// Usage: Text and icons on primary color backgrounds
  static const Color primaryForeground = Color(0xFFFBFBFB);

  // Background Colors
  /// Main background: pure white (oklch(1 0 0))
  static const Color backgroundLight = Color(0xFFFFFFFF);
  
  /// Dark mode background
  static const Color backgroundDark = Color(0xFF121212);
  
  /// Card background: white (oklch(1 0 0))
  static const Color cardLight = Color(0xFFFFFFFF);
  
  /// Dark mode card background
  static const Color cardDark = Color(0xFF1E1E1E);
  
  /// Muted background: slightly off-white (oklch(0.97 0 0))
  static const Color mutedBackground = Color(0xFFF7F7F7);
  
  /// Accent background: slightly off-white (oklch(0.97 0 0))
  static const Color accentBackground = Color(0xFFF7F7F7);
  
  /// Surface color for light mode
  static const Color surfaceLight = Color(0xFFF7F7F7);
  
  /// Surface color for dark mode
  static const Color surfaceDark = Color(0xFF1C2630);

  // Foreground (Text) Colors
  /// Main text color: near black (oklch(0.145 0 0))
  static const Color textLight = Color(0xFF252525);
  
  /// Dark mode text color: near white
  static const Color textDark = Color(0xFFE5E5E5);
  
  /// Muted/secondary text: medium gray (oklch(0.556 0 0))
  static const Color mutedLight = Color(0xFF8E8E8E);
  
  /// Dark mode muted text
  static const Color mutedDark = Color(0xFF9CA3AF);
  
  /// Card foreground: same as main text
  static const Color cardForeground = Color(0xFF252525);
  
  /// Accent foreground: same as main text
  static const Color accentForeground = Color(0xFF252525);

  // Border and Input Colors
  /// Border color: light gray (oklch(0.922 0 0))
  static const Color borderLight = Color(0xFFEBEBEB);
  
  /// Dark mode border color
  static const Color borderDark = Color(0xFF333333);
  
  /// Border dark secondary
  static const Color borderDarkSecondary = Color(0xFF3B4754);
  
  /// Input border color: same as border
  static const Color inputBorder = Color(0xFFEBEBEB);
  
  /// Focus ring color (oklch(0.708 0 0))
  static const Color ring = Color(0xFFB5B5B5);

  // Destructive (Error) Colors
  /// Destructive/error color: red (oklch(0.577 0.245 27.325))
  static const Color destructive = Color(0xFFDC2626);
  
  /// Destructive foreground: typically white
  static const Color destructiveForeground = Color(0xFFFFFFFF);

  // Secondary Colors
  /// Secondary background: muted background
  static const Color secondary = Color(0xFFF7F7F7);
  
  /// Secondary foreground: main text
  static const Color secondaryForeground = Color(0xFF252525);

  // Legacy Gray Scale (kept for compatibility)
  static const Color gray200 = Color(0xFFEBEBEB);
  static const Color gray300 = Color(0xFFD1D5DB);
  static const Color gray400 = Color(0xFF9CA3AF);
  static const Color gray600 = Color(0xFF4B5563);
  static const Color gray700 = Color(0xFF374151);
  static const Color gray800 = Color(0xFF1F2937);
  static const Color gray900 = Color(0xFF111827);
  
  // Special Purpose Colors
  static const Color carPlaceholderBg = Color(0xFF2A2A2A);
  
  // Opacity variants for primary color
  /// Primary with 10% opacity: rgba(0, 74, 173, 0.1)
  static Color primary10 = const Color(0xFF004aad).withOpacity(0.1);
  
  /// Primary with 30% opacity: rgba(0, 74, 173, 0.3)
  static Color primary30 = const Color(0xFF004aad).withOpacity(0.3);
  
  /// Primary with 50% opacity: rgba(0, 74, 173, 0.5)
  static Color primary50 = const Color(0xFF004aad).withOpacity(0.5);
  
  /// Primary with 60% opacity: rgba(0, 74, 173, 0.6)
  static Color primary60 = const Color(0xFF004aad).withOpacity(0.6);
  
  /// Primary with 70% opacity: rgba(0, 74, 173, 0.7)
  static Color primary70 = const Color(0xFF004aad).withOpacity(0.7);
}

