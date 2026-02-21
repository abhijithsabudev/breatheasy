import 'package:flutter/material.dart';

class AppColorScheme {
  final Color orange1;
  final Color orange2;
  final Color violet;
  final Color background;
  final Color cloud;
  final Color grey;
  final Color white;
  final Color black87;
  final Color textSecondary;
  final Color glassy;
  final Color bgPage;
  final Color borderSubtle;
  final Color buttonPrimary;
  final Color chipNeutralBg;
  final Color brandPrimary;
  final Color brandSubtle;
  final Color purple1;
  final Color purple2;
  final Color topgradient;
  final Color bottomgradient;

  const AppColorScheme({
    required this.orange1,
    required this.orange2,
    required this.violet,
    required this.background,
    required this.cloud,
    required this.grey,
    required this.white,
    required this.black87,
    required this.textSecondary,
    required this.glassy,
    required this.bgPage,
    required this.borderSubtle,
    required this.buttonPrimary,
    required this.chipNeutralBg,
    required this.brandPrimary,
    required this.brandSubtle,
    required this.purple1,
    required this.purple2,
    required this.topgradient,
    required this.bottomgradient,
  });

  // Light theme color scheme
  static const AppColorScheme light = AppColorScheme(
    orange1: Color(0xFFE47B00),
    orange2: Color(0xFFFFF8F0),
    violet: Color(0xFF9C77D9),
    background: Color(0xFFF5F1F8),
    cloud: Color(0xFFECEAF0),
    grey: Color(0xFF888888),
    white: Colors.white,
    black87: Colors.black87,
    textSecondary: Color(0xFF737373),
    glassy: Color(0xB3FFFFFF),
    bgPage: Color(0xFFF7F7F7),
    borderSubtle: Color(0xFFF5F5F5),
    buttonPrimary: Color(0xFF630068),
    chipNeutralBg: Color(0xFFFFFFFF),
    brandPrimary: Color(0xFF630068),
    brandSubtle: Color(0xFFEFE6F0),
    purple1: Color(0x1F7B2D8E),
    purple2: Color(0x337B2D8E),
    topgradient: Color(0xFFE8D9E8),
    bottomgradient: Color(0xFFFFEDD9),
  );

  // Dark theme color scheme
  static const AppColorScheme dark = AppColorScheme(
    orange1: Color(0xFFE47B00),
    orange2: Color(0xFF5C2D00),
    violet: Color(0xFF9C77D9),
    background: Color(0xFF1A1A2E),
    cloud: Color(0xFF2D2D44),
    grey: Color(0xFFBBBBBB),
    white: Colors.white,
    black87: Colors.black87,
    textSecondary: Color(0xFF737373),
    glassy: Color(0x0DFFFFFF),
    bgPage: Color(0xFF141414),
    borderSubtle: Color(0xFF292929),
    buttonPrimary: Color(0xFF823386),
    chipNeutralBg: Color(0xFF424242),
    brandPrimary: Color(0xFFFFFFFF),
    brandSubtle: Color(0xFF823386),
    purple1: Color(0x1F7B2D8E),
    purple2: Color(0x337B2D8E),
    topgradient: Color(0xFF1A1128),
    bottomgradient: Color(0xFF3A2260),
  );
}

extension AppColorsExt on BuildContext {
  AppColorScheme get colors => Theme.of(this).brightness == Brightness.light
      ? AppColorScheme.light
      : AppColorScheme.dark;
}
