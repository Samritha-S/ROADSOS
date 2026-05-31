// lib/domain/coordination/family_alert_manager.dart
// ROADSoS - Family Alert Manager

import 'package:intl/intl.dart';

class FamilyAlertManager {
  FamilyAlertManager._();

  static String composeSmsMessage({
    required double? latitude,
    required double? longitude,
    required DateTime incidentTime,
    required String countryCode,
    bool isVictim = true,
  }) {
    final formattedTime = formatIncidentTime(incidentTime);
    final locationLink = (latitude != null && longitude != null)
        ? 'https://maps.google.com/?q=$latitude,$longitude'
        : 'Location unavailable';

    if (isVictim) {
      return '🚨 EMERGENCY ALERT — ROADSoS\n'
          'I have been in a road accident.\n'
          'Time: $formattedTime\n'
          'Location: $locationLink\n'
          'Please call for help immediately.\n'
          '— Sent via ROADSoS';
    } else {
      return '🚨 EMERGENCY ALERT — ROADSoS\n'
          'I am at the scene of a road accident and\n'
          'someone needs urgent help.\n'
          'Time: $formattedTime\n'
          'Location: $locationLink\n'
          'Emergency services have been contacted.\n'
          '— Sent via ROADSoS';
    }
  }

  static String formatIncidentTime(DateTime time) {
    return DateFormat('HH:mm, dd MMM yyyy').format(time);
  }
}
