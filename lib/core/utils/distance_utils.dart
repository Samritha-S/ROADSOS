// lib/core/utils/distance_utils.dart
// ROADSoS - Distance Utilities

class DistanceUtils {
  DistanceUtils._();

  static String formatDistance(double distanceKm) {
    if (distanceKm < 0.1) {
      return 'Less than 100m';
    } else if (distanceKm < 1.0) {
      final meters = (distanceKm * 1000).round();
      final rounded = (meters / 100).round() * 100;
      return '${rounded}m';
    } else if (distanceKm < 10.0) {
      return '${distanceKm.toStringAsFixed(1)}km';
    } else {
      return '${distanceKm.round()}km';
    }
  }

  static String formatEta(double distanceKm) {
    if (distanceKm < 0.1) {
      return 'Est. 1 min away';
    }
    final minutes = (distanceKm / 60 * 60).ceil(); // Assuming 60km/h = 1km/min
    return 'Est. ${minutes < 1 ? 1 : minutes} min away';
  }
}
