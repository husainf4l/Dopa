import 'package:flutter/material.dart';

class AppColors {
  static const primary = Color(0xFF3CB8C6);
  static const background = Color(0xFFF5FDFE);
}

class AppTheme {
  static final light = ThemeData(
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primary),
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.background,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white, foregroundColor: Colors.black),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
    ),
  );
}
