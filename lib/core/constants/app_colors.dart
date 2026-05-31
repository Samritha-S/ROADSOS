// lib/core/constants/app_colors.dart
// ROADSoS - App Colors

import 'package:flutter/material.dart';
import '../enums/priority_score.dart';

class AppColors {
  AppColors._();

  static const Color background = Color(0xFF0A0A0A);
  static const Color surface = Color(0xFF1C1C1E);
  static const Color primaryRed = Color(0xFFDD0000);
  static const Color confirmedGreen = Color(0xFF30D158);
  static const Color warningAmber = Color(0xFFFF9F0A);
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color cardBackground = Color(0xFF2C2C2E);
  static const Color criticalRed = Color(0xFFFF0000);
  static const Color urgentOrange = Color(0xFFFF6B00);
  static const Color nonEmergencyBlue = Color(0xFF0A84FF);

  // New colors
  static const Color divider = Color(0xFF38383A);
  static const Color sosGlow = Color(0xFFFF0000);
  static const Color cardBorder = Color(0xFF38383A);
  static const Color successBackground = Color(0xFF1C3A2A);
  static const Color warningBackground = Color(0xFF3A2A1C);

  static Color priorityColor(PriorityScore score) {
    switch (score) {
      case PriorityScore.CRITICAL:
        return criticalRed;
      case PriorityScore.URGENT:
        return urgentOrange;
      case PriorityScore.NON_EMERGENCY:
        return nonEmergencyBlue;
    }
  }
}
