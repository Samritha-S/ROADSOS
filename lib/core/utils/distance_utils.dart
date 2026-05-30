// lib/core/utils/distance_utils.dart
// ROADSoS - Distance Utilities

class DistanceUtils {
  DistanceUtils._();

  static String formatDistance(double distanceKm) {
    if (distanceKm < 1.0) {
      final meters = distanceKm * 1000;
      var roundedMeters = (meters / 100).round() * 100;
      if (roundedMeters < 100 && distanceKm > 0) {
        roundedMeters = 100;
      }
      if (roundedMeters >= 1000) {
        return '1.0km';
      }
      return '${roundedMeters}m';
    } else if (distanceKm < 10.0) {
      return '${distanceKm.toStringAsFixed(1)}km';
    } else {
      return '${distanceKm.round()}km';
    }
  }

  static String formatEta(double distanceKm) {
    // Assumes average emergency vehicle speed: 60 km/h (which is 1 km/min)
    var etaMinutes = distanceKm.round();
    if (etaMinutes < 1) {
      etaMinutes = 1;
    }
    return 'Est. $etaMinutes min away';
  }
}
