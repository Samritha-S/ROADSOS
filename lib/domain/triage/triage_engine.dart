// lib/domain/triage/triage_engine.dart
// ROADSoS - Triage Engine

import '../../core/enums/priority_score.dart';
import '../../core/enums/service_type.dart';
import '../../core/models/triage_result_model.dart';

class TriageEngine {
  TriageEngine._();

  static TriageResultModel computeResult({
    required bool q1Answer, // anyone injured
    required bool q2Answer, // serious symptoms
    required bool q3Answer, // fire/smoke/water
    bool q1NotSure = false,
    bool q2NotSure = false,
    bool q3NotSure = false,
  }) {
    final immediateHazard = q3Answer || q3NotSure;
    final seriousSymptoms = q2Answer || q2NotSure;
    final anyoneInjured = q1Answer || q1NotSure;

    PriorityScore score;
    if (immediateHazard) {
      score = PriorityScore.CRITICAL;
    } else if (seriousSymptoms) {
      score = PriorityScore.CRITICAL;
    } else if (anyoneInjured) {
      score = PriorityScore.URGENT;
    } else {
      score = PriorityScore.NON_EMERGENCY;
    }

    return TriageResultModel(
      anyoneInjured: anyoneInjured,
      seriousSymptoms: seriousSymptoms,
      immediateHazard: immediateHazard,
      priorityScore: score,
      completedAt: DateTime.now(),
    );
  }

  static List<ServiceType> getPriorityOrder(TriageResultModel? result) {
    if (result == null) {
      return [
        ServiceType.POLICE,
        ServiceType.TOWING,
        ServiceType.HOSPITAL,
        ServiceType.AMBULANCE,
        ServiceType.PUNCTURE,
        ServiceType.SHOWROOM,
      ];
    }

    if (result.priorityScore == PriorityScore.CRITICAL) {
      if (result.immediateHazard) {
        return [
          ServiceType.AMBULANCE,
          ServiceType.POLICE,
          ServiceType.HOSPITAL,
          ServiceType.TOWING,
          ServiceType.PUNCTURE,
          ServiceType.SHOWROOM,
        ];
      } else {
        return [
          ServiceType.AMBULANCE,
          ServiceType.HOSPITAL,
          ServiceType.POLICE,
          ServiceType.TOWING,
          ServiceType.PUNCTURE,
          ServiceType.SHOWROOM,
        ];
      }
    } else if (result.priorityScore == PriorityScore.URGENT) {
      return [
        ServiceType.HOSPITAL,
        ServiceType.AMBULANCE,
        ServiceType.POLICE,
        ServiceType.TOWING,
        ServiceType.PUNCTURE,
        ServiceType.SHOWROOM,
      ];
    } else {
      return [
        ServiceType.POLICE,
        ServiceType.TOWING,
        ServiceType.HOSPITAL,
        ServiceType.AMBULANCE,
        ServiceType.PUNCTURE,
        ServiceType.SHOWROOM,
      ];
    }
  }

  static String getPriorityMessage(TriageResultModel? result) {
    if (result == null) {
      return 'No injuries reported. Police notified first.';
    }
    if (result.priorityScore == PriorityScore.CRITICAL) {
      if (result.immediateHazard) {
        return 'Critical hazard detected. Move to safety first.';
      } else {
        return 'Critical injuries detected. Ambulance priority.';
      }
    } else if (result.priorityScore == PriorityScore.URGENT) {
      return 'Injuries reported. Hospital priority.';
    } else {
      return 'No injuries reported. Police notified first.';
    }
  }

  static String getCalmInstructions(TriageResultModel? result) {
    if (result == null) {
      return 'Move your vehicle to the side if safe. Turn on hazard lights. Stay visible to other drivers.';
    }
    if (result.priorityScore == PriorityScore.CRITICAL) {
      if (result.immediateHazard) {
        return 'Move away from the vehicle immediately. Do not re-enter. Call for help from a safe distance.';
      } else {
        return 'Keep the injured person still. Do not move them. Do not remove a helmet. Keep them conscious and talking.';
      }
    } else if (result.priorityScore == PriorityScore.URGENT) {
      return 'Keep the injured person comfortable. Do not give water. Help is on the way.';
    } else {
      return 'Move your vehicle to the side if safe. Turn on hazard lights. Stay visible to other drivers.';
    }
  }
}
