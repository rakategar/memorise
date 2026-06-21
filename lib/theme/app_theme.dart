import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  const AppTheme._();

  static ThemeData light() {
    final base = ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF6650a4),
        brightness: Brightness.light,
      ),
    );

    // Preserve all base text style properties (size, weight, color),
    // only force decoration: none to kill browser-inherited underlines on Flutter Web.
    TextStyle _nd(TextStyle? s) =>
        (s ?? const TextStyle()).copyWith(decoration: TextDecoration.none, decorationColor: Colors.transparent);

    final tt = base.textTheme;
    return base.copyWith(
      textTheme: tt.copyWith(
        displayLarge: _nd(tt.displayLarge),
        displayMedium: _nd(tt.displayMedium),
        displaySmall: _nd(tt.displaySmall),
        headlineLarge: _nd(tt.headlineLarge),
        headlineMedium: _nd(tt.headlineMedium),
        headlineSmall: _nd(tt.headlineSmall),
        titleLarge: _nd(tt.titleLarge),
        titleMedium: _nd(tt.titleMedium),
        titleSmall: _nd(tt.titleSmall),
        bodyLarge: _nd(tt.bodyLarge),
        bodyMedium: _nd(tt.bodyMedium),
        bodySmall: _nd(tt.bodySmall),
        labelLarge: _nd(tt.labelLarge),
        labelMedium: _nd(tt.labelMedium),
        labelSmall: _nd(tt.labelSmall),
      ),
    );
  }
}
