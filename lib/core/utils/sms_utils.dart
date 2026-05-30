// lib/core/utils/sms_utils.dart
// ROADSoS - SMS Utility (stub - SMS via url_launcher)

import 'package:url_launcher/url_launcher.dart';

class SmsUtils {
  static Future<bool> sendEmergencyAlert({
    required List<String> phoneNumbers,
    required String message,
  }) async {
    if (phoneNumbers.isEmpty) return false;
    try {
      for (final number in phoneNumbers) {
        if (number.isNotEmpty) {
          final uri = Uri(
            scheme: 'sms',
            path: number,
            queryParameters: {'body': message},
          );
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          }
        }
      }
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> canSendSms() async {
    try {
      final uri = Uri(scheme: 'sms', path: '');
      return await canLaunchUrl(uri);
    } catch (e) {
      return false;
    }
  }
}
