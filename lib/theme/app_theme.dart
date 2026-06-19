import 'package:flutter/material.dart';

import 'app_colors.dart';

/// App-wide Material 3 theme. Kept light to match the original kid-friendly UI.
class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6650a4),
        brightness: Brightness.light,
      ),
      fontFamily: null,
    );
  }
}
