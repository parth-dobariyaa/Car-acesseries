import 'package:flutter/material.dart';

class CarvoraColors {
  static const Color background = Color(0xFF090A0E);
  static const Color surface = Color(0xFF12151D);
  static const Color surfaceHighlight = Color(0xFF1B202D);
  static const Color surfaceElevated = Color(0xFF222838);

  // Gold & Champagne Accents
  static const Color gold = Color(0xFFE5B869);
  static const Color goldLight = Color(0xFFF7D99E);
  static const Color goldDark = Color(0xFFB58739);
  static const Color goldMuted = Color(0x33E5B869);

  // Cool Technical Accents
  static const Color cyanAccent = Color(0xFF4AC2F5);
  static const Color sapphireAccent = Color(0xFF3F6DF6);

  // Text Colors
  static const Color textPrimary = Color(0xFFF7F8FA);
  static const Color textSecondary = Color(0xFFA3ACB9);
  static const Color textMuted = Color(0xFF656E7E);

  // Borders & Dividers
  static const Color border = Color(0xFF242B3A);
  static const Color borderHighlight = Color(0x66E5B869);

  // Status
  static const Color success = Color(0xFF2FD67B);
  static const Color warning = Color(0xFFFFB039);
  static const Color error = Color(0xFFFF4858);
}

class CarvoraTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: CarvoraColors.background,
      primaryColor: CarvoraColors.gold,
      colorScheme: const ColorScheme.dark(
        primary: CarvoraColors.gold,
        secondary: CarvoraColors.cyanAccent,
        surface: CarvoraColors.surface,
        onPrimary: Colors.black,
        onSurface: CarvoraColors.textPrimary,
        error: CarvoraColors.error,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: CarvoraColors.textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
      cardTheme: CardThemeData(
        color: CarvoraColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: CarvoraColors.border, width: 1),
        ),
      ),
      dividerTheme: const DividerThemeData(
        color: CarvoraColors.border,
        thickness: 1,
        space: 24,
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontSize: 36,
          fontWeight: FontWeight.w800,
          letterSpacing: 2.0,
          color: CarvoraColors.textPrimary,
        ),
        displayMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
          color: CarvoraColors.textPrimary,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
          color: CarvoraColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: CarvoraColors.textPrimary,
        ),
        bodyLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          height: 1.5,
          color: CarvoraColors.textSecondary,
        ),
        bodyMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: CarvoraColors.textSecondary,
        ),
        labelLarge: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Colors.black,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: CarvoraColors.gold,
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          elevation: 4,
          shadowColor: CarvoraColors.gold.withValues(alpha: 0.35),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: CarvoraColors.gold,
          side: const BorderSide(color: CarvoraColors.gold, width: 1.2),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: CarvoraColors.surfaceHighlight,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        hintStyle: const TextStyle(color: CarvoraColors.textMuted, fontSize: 14),
        labelStyle: const TextStyle(color: CarvoraColors.textSecondary, fontSize: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CarvoraColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CarvoraColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: CarvoraColors.gold, width: 1.5),
        ),
      ),
    );
  }
}
