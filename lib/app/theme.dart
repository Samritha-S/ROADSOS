// lib/app/theme.dart
// ROADSoS - App Theme

import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.background,
    primaryColor: AppColors.primaryRed,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryRed,
      secondary: AppColors.confirmedGreen,
      surface: AppColors.surface,
      error: AppColors.criticalRed,
      onPrimary: AppColors.textPrimary,
      onSurface: AppColors.textPrimary,
    ),
    cardColor: AppColors.cardBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.background,
      foregroundColor: AppColors.textPrimary,
      elevation: 0,
      centerTitle: true,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(double.infinity, 80),
        textStyle: AppTextStyles.buttonLabel,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    textTheme: const TextTheme(
      displayLarge: AppTextStyles.headline,
      bodyLarge: AppTextStyles.bodyLarge,
      bodyMedium: AppTextStyles.bodyMedium,
      labelLarge: AppTextStyles.buttonLabel,
    ),
  );
}
