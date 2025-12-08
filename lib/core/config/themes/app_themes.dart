import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

abstract final class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: AppColors.lightBackground,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightAccent,
      error: AppColors.error,
      surface: AppColors.lightBackground,
      onPrimary: AppColors.lightOnPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      headlineMedium: AppTypography.headlineMedium,
      bodyLarge: AppTypography.bodyLarge,
      labelLarge: AppTypography.labelLarge,
    ),
    // ...TODO more themes
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true, // Ativa o Material 3!
    brightness: Brightness.dark,
    scaffoldBackgroundColor: AppColors.darkBackground,
    colorScheme: const ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent,
      error: AppColors.error,
      surface: AppColors.darkBackground,
      onPrimary: AppColors.darkOnPrimary,
    ),
    textTheme: const TextTheme(
      displayLarge: AppTypography.displayLarge,
      headlineMedium: AppTypography.headlineMedium,
      bodyLarge: AppTypography.bodyLarge,
      labelLarge: AppTypography.labelLarge,
    ),
    // ...TODO more themes
  );
}
