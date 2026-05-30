// lib/domain/state_machine/state_transitions.dart
// ROADSoS - State Transitions Validator

// ignore_for_file: constant_identifier_names

import '../../core/enums/incident_state.dart';

class StateTransitionValidator {
  StateTransitionValidator._();

  static const Map<IncidentState, List<IncidentState>> _validTransitions = {
    IncidentState.IDLE: [IncidentState.DISCOVERY],
    IncidentState.DISCOVERY: [IncidentState.TRIAGE, IncidentState.IDLE],
    IncidentState.TRIAGE: [IncidentState.DISPATCH, IncidentState.IDLE],
    IncidentState.DISPATCH: [
      IncidentState.COORDINATION,
      IncidentState.RESOLVED,
      IncidentState.IDLE
    ],
    IncidentState.COORDINATION: [
      IncidentState.WAITING,
      IncidentState.RESOLVED,
      IncidentState.IDLE
    ],
    IncidentState.WAITING: [IncidentState.RESOLVED, IncidentState.IDLE],
    IncidentState.RESOLVED: [IncidentState.IDLE],
  };

  static bool canTransition(IncidentState from, IncidentState to) {
    if (to == IncidentState.IDLE) return true; // Any state -> IDLE (reset)
    final allowed = _validTransitions[from];
    return allowed != null && allowed.contains(to);
  }

  static String transitionMessage(IncidentState from, IncidentState to) {
    if (to == IncidentState.IDLE) {
      return 'Incident reset to IDLE.';
    }
    switch (from) {
      case IncidentState.IDLE:
        if (to == IncidentState.DISCOVERY) {
          return 'Incident initiated in DISCOVERY phase.';
        }
        break;
      case IncidentState.DISCOVERY:
        if (to == IncidentState.TRIAGE) return 'Triage assessment completed.';
        break;
      case IncidentState.TRIAGE:
        if (to == IncidentState.DISPATCH) {
          return 'Emergency services dispatch initiated.';
        }
        break;
      case IncidentState.DISPATCH:
        if (to == IncidentState.COORDINATION) {
          return 'Service contacted. Shifted to COORDINATION phase.';
        }
        if (to == IncidentState.RESOLVED) {
          return 'Incident resolved directly from DISPATCH.';
        }
        break;
      case IncidentState.COORDINATION:
        if (to == IncidentState.WAITING) {
          return 'Shifted to WAITING phase for service arrival.';
        }
        if (to == IncidentState.RESOLVED) {
          return 'Incident resolved from COORDINATION.';
        }
        break;
      case IncidentState.WAITING:
        if (to == IncidentState.RESOLVED) {
          return 'Incident successfully resolved.';
        }
        break;
      default:
        break;
    }
    return 'State transition from ${from.name} to ${to.name}.';
  }
}
