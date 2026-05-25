import 'package:flutter/material.dart';

class AppTheme {
  const AppTheme._();

  static const primaryColor = Color(0xFF6809BD);
  static const secondaryColor = Color(0xFF33085A);
  static const backgroundColor = Color(0xFFF8F3FF);

  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: backgroundColor,
      colorScheme: const ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
