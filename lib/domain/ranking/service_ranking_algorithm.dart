// lib/domain/ranking/service_ranking_algorithm.dart
// ROADSoS - Service Ranking Algorithm

import 'dart:math';
import '../../core/enums/priority_score.dart';
import '../../core/enums/service_type.dart';
import '../../core/models/facility_model.dart';

class ServiceRankingAlgorithm {
  ServiceRankingAlgorithm._();

  static List<FacilityModel> rankFacilities({
    required List<FacilityModel> facilities,
    required double userLatitude,
    required double userLongitude,
    required PriorityScore priorityScore,
    required ServiceType serviceType,
  }) {
    // Filter facilities by active status and matching service type
    final filtered = facilities
        .where((f) => f.serviceType == serviceType && f.isActive)
        .toList();

    final scored = filtered.map((f) {
      final distance = calculateDistanceKm(
        userLatitude,
        userLongitude,
        f.latitude,
        f.longitude,
      );

      // distanceScore = 1.0 - (distanceKm / maxDistanceKm), clamped [0.0, 1.0]
      const maxDistanceKm = 50.0;
      double distanceScore = 1.0 - (distance / maxDistanceKm);
      if (distanceScore < 0.0) distanceScore = 0.0;
      if (distanceScore > 1.0) distanceScore = 1.0;

      final confidenceScore = f.confidenceScore;

      // freshnessScore based on lastVerified age
      final diffDays = DateTime.now().difference(f.lastVerified).inDays;
      double freshnessScore;
      if (diffDays <= 7) {
        freshnessScore = 1.0;
      } else if (diffDays <= 30) {
        freshnessScore = 0.7;
      } else if (diffDays <= 90) {
        freshnessScore = 0.4;
      } else {
        freshnessScore = 0.1;
      }

      // composite score: 50% distance, 30% confidence, 20% freshness
      final compositeScore = (distanceScore * 0.5) +
          (confidenceScore * 0.3) +
          (freshnessScore * 0.2);

      return _ScoredFacility(f, compositeScore);
    }).toList();

    // Sort descending by composite score
    scored.sort((a, b) => b.score.compareTo(a.score));

    // Return top 5 results
    return scored.map((sf) => sf.facility).take(5).toList();
  }

  static double calculateDistanceKm(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadiusKm = 6371.0;

    final double dLat = _degreesToRadians(lat2 - lat1);
    final double dLon = _degreesToRadians(lon2 - lon1);

    final double rLat1 = _degreesToRadians(lat1);
    final double rLat2 = _degreesToRadians(lat2);

    final double a = sin(dLat / 2) * sin(dLat / 2) +
        cos(rLat1) * cos(rLat2) * sin(dLon / 2) * sin(dLon / 2);

    final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadiusKm * c;
  }

  static double _degreesToRadians(double degrees) {
    return degrees * pi / 180.0;
  }
}

class _ScoredFacility {
  final FacilityModel facility;
  final double score;

  _ScoredFacility(this.facility, this.score);
}
