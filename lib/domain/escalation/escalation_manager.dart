// lib/domain/escalation/escalation_manager.dart
// ROADSoS - Escalation Manager

import 'package:collection/collection.dart';

import '../../core/models/facility_model.dart';
import '../ranking/service_ranking_algorithm.dart';

class EscalationManager {
  EscalationManager._();

  static const int escalationTimeoutMinutes = 4;
  static const double lowConfidenceThreshold = 0.4;

  static bool shouldEscalate({
    required FacilityModel facility,
    required DateTime? lastContactAttemptTime,
  }) {
    if (facility.confidenceScore < lowConfidenceThreshold) {
      return true;
    }

    if (lastContactAttemptTime != null) {
      final difference = DateTime.now().difference(lastContactAttemptTime);
      if (difference.inMinutes >= escalationTimeoutMinutes) {
        return true;
      }
    }

    return false;
  }

  static FacilityModel? getNextFacility({
    required List<FacilityModel> rankedFacilities,
    required List<String> alreadyContactedIds,
  }) {
    return rankedFacilities.firstWhereOrNull(
      (f) => !alreadyContactedIds.contains(f.id)
    );
  }

  static String getEscalationMessage(
    String failedFacilityName,
    FacilityModel nextFacility, [
    double? userLatitude,
    double? userLongitude,
  ]) {
    final double distance;
    if (userLatitude != null && userLongitude != null) {
      distance = ServiceRankingAlgorithm.calculateDistanceKm(
        userLatitude,
        userLongitude,
        nextFacility.latitude,
        nextFacility.longitude,
      );
    } else {
      distance = 0.0;
    }

    final distanceStr = distance.toStringAsFixed(1);
    
    return 'No answer from $failedFacilityName.\n'
        'The next available service is ${nextFacility.name},\n'
        '${distanceStr}km away.';
  }
}
