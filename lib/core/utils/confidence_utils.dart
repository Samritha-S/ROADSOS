// lib/core/utils/confidence_utils.dart
// ROADSoS - Confidence Utilities

import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class ConfidenceUtils {
  ConfidenceUtils._();

  static String getConfidenceLabel(double score) {
    if (score >= 0.8) {
      return 'Verified';
    } else if (score >= 0.6) {
      return 'Mostly Verified';
    } else if (score >= 0.4) {
      return 'Unverified';
    } else {
      return 'Low Confidence';
    }
  }

  static Color getConfidenceColor(double score) {
    if (score >= 0.8) {
      return AppColors.confirmedGreen;
    } else if (score >= 0.6) {
      return AppColors.warningAmber;
    } else {
      return AppColors.criticalRed;
    }
  }

  static String getConfidenceIcon(double score) {
    if (score >= 0.8) {
      return '✓';
    } else if (score >= 0.6) {
      return '~';
    } else {
      return '!';
    }
  }
}
