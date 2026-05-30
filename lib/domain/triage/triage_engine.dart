// lib/domain/triage/triage_engine.dart
// ROADSoS - Triage Engine

import '../../core/enums/priority_score.dart';
import '../../core/enums/service_type.dart';
import '../../core/models/triage_result_model.dart';

class TriageEngine {
  TriageEngine._();

  static TriageResultModel computeResult({
    required bool q1Answer, // anyoneInjured
    required bool q2Answer, // seriousSymptoms
    required bool q3Answer, // immediateHazard
    bool q1NotSure = false,
    bool q2NotSure = false,
    bool q3NotSure = false,
  }) {
    // NOT SURE answers are treated as TRUE (conservative escalation)
    final anyoneInjured = q1Answer || q1NotSure;
    final seriousSymptoms = q2Answer || q2NotSure;
    final immediateHazard = q3Answer || q3NotSure;

    return TriageResultModel.compute(
      anyoneInjured: anyoneInjured,
      seriousSymptoms: seriousSymptoms,
      immediateHazard: immediateHazard,
      completedAt: DateTime.now(),
    );
  }

  static List<ServiceType> getPriorityOrder(PriorityScore score) {
    switch (score) {
      case PriorityScore.CRITICAL:
        return [
          ServiceType.AMBULANCE,
          ServiceType.POLICE,
          ServiceType.HOSPITAL,
          ServiceType.TOWING,
          ServiceType.PUNCTURE,
          ServiceType.SHOWROOM,
        ];
      case PriorityScore.URGENT:
        return [
          ServiceType.HOSPITAL,
          ServiceType.AMBULANCE,
          ServiceType.POLICE,
          ServiceType.TOWING,
          ServiceType.PUNCTURE,
          ServiceType.SHOWROOM,
        ];
      case PriorityScore.NON_EMERGENCY:
        return [
          ServiceType.POLICE,
          ServiceType.HOSPITAL,
          ServiceType.AMBULANCE,
          ServiceType.TOWING,
          ServiceType.PUNCTURE,
          ServiceType.SHOWROOM,
        ];
    }
  }

  static String getPriorityMessage(PriorityScore score) {
    switch (score) {
      case PriorityScore.CRITICAL:
        return 'Critical emergency detected. Ambulance priority.';
      case PriorityScore.URGENT:
        return 'Urgent situation. Hospital priority.';
      case PriorityScore.NON_EMERGENCY:
        return 'Non-emergency. Police notified first.';
    }
  }

  static String getCalmInstructions(TriageResultModel result) {
    if (result.immediateHazard) {
      return 'Move away from the vehicle immediately if safe to do so. Do not re-enter the vehicle.';
    } else if (result.seriousSymptoms) {
      return 'Keep the injured person still. Do not move them. Do not remove a helmet. Keep them conscious and talking.';
    } else if (result.anyoneInjured) {
      return 'Stay calm. Help is on the way. Keep the injured person comfortable and still.';
    } else {
      return 'Stay safe. Move your vehicle to the side if possible. Turn on hazard lights.';
    }
  }
}
