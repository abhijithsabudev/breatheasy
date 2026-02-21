import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  static ThemeData lightTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorScheme.light.violet,
        brightness: Brightness.light,
      ),
      scaffoldBackgroundColor: AppColorScheme.light.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorScheme.light.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColorScheme.light.black87),
      ),
      cardTheme: CardThemeData(
        color: AppColorScheme.light.orange1,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: AppColorScheme.light.orange1, width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.quicksand(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColorScheme.light.black87,
        ),
        headlineSmall: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorScheme.light.black87,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 14,
          color: AppColorScheme.light.grey,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColorScheme.light.violet,
          foregroundColor: AppColorScheme.light.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColorScheme.dark.violet,
        brightness: Brightness.dark,
      ),
      scaffoldBackgroundColor: AppColorScheme.dark.background,
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorScheme.dark.background,
        elevation: 0,
        iconTheme: IconThemeData(color: AppColorScheme.dark.white),
      ),
      cardTheme: CardThemeData(
        color: AppColorScheme.dark.cloud,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF3A3A52), width: 1),
        ),
      ),
      textTheme: TextTheme(
        displayLarge: GoogleFonts.quicksand(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          color: AppColorScheme.dark.white,
        ),
        headlineSmall: GoogleFonts.quicksand(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: AppColorScheme.dark.white,
        ),
        bodyMedium: GoogleFonts.quicksand(
          fontSize: 14,
          color: AppColorScheme.dark.grey,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColorScheme.dark.violet,
          foregroundColor: AppColorScheme.dark.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
