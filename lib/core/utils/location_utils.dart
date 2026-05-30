// lib/core/utils/location_utils.dart
// ROADSoS - Location Utilities

import 'package:geolocator/geolocator.dart';

class LocationUtils {
  LocationUtils._();

  static Future<Position?> getCurrentLocation({
    int timeoutSeconds = 8,
  }) async {
    try {
      final hasPermission = await requestPermission();
      if (!hasPermission) return null;

      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return null;

      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: timeoutSeconds),
      );
    } catch (e) {
      // Never throws, returns null on timeout or error
      return null;
    }
  }

  static Future<bool> requestPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return permission == LocationPermission.always ||
             permission == LocationPermission.whileInUse;
    } catch (e) {
      return false;
    }
  }
}
