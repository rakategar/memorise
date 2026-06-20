import 'package:flutter/material.dart';

/// Centralized color constants ported from the original Compose UI.
class AppColors {
  const AppColors._();

  // Global backgrounds
  static const background = Color(0xFFFDFCFF);
  static const gameplayBackground = Color(0xFFE0F2FE);
  static const summaryBackground = Color(0xFF0C1F3D);

  // Level accent colors (LevelCard uses the first set, Stage/Gameplay the 2nd)
  static const level1 = Color(0xFF3498DB);
  static const level2 = Color(0xFF9B59B6);
  static const level3 = Color(0xFFE67E22);

  static const level1Alt = Color(0xFF3B82F6);
  static const level2Alt = Color(0xFF8B5CF6);
  static const level3Alt = Color(0xFFF97316);

  // Common UI
  static const gold = Color(0xFFFBBF24);
  static const goldDeep = Color(0xFFB45309);
  static const goldBrown = Color(0xFF78350F);
  static const star = Color(0xFFFFC107);
  static const navyTitle = Color(0xFF1E355E);
  static const blueDark = Color(0xFF1E3A8A);
  static const cardBorder = Color(0xFFE2E8F0);
  static const cardBorder2 = Color(0xFFCBD5E1);

  /// Accent used by LevelCard.
  static Color levelAccent(int levelId) {
    switch (levelId) {
      case 1:
        return level1;
      case 2:
        return level2;
      default:
        return level3;
    }
  }

  /// Accent used by Stage select / Gameplay screens.
  static Color levelAccentAlt(int levelId) {
    switch (levelId) {
      case 1:
        return level1Alt;
      case 2:
        return level2Alt;
      default:
        return level3Alt;
    }
  }
}
