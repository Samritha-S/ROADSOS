// lib/domain/state_machine/incident_state_machine.dart
// ROADSoS - Incident State Machine

import 'dart:async';
import 'package:uuid/uuid.dart';

import '../../core/enums/incident_state.dart';
import '../../core/models/incident_model.dart';
import '../../core/models/timeline_entry_model.dart';
import '../../core/models/triage_result_model.dart';
import 'state_transitions.dart';

class IncidentStateMachine {
  IncidentModel? _currentIncident;
  final StreamController<IncidentModel?> _controller = StreamController<IncidentModel?>.broadcast();

  IncidentModel? get currentIncident => _currentIncident;
  Stream<IncidentModel?> get incidentStream => _controller.stream;
  Stream<IncidentModel?> get stream => _controller.stream; // Robust alias

  IncidentState get currentState => _currentIncident?.currentState ?? IncidentState.IDLE;

  void startIncident({double? latitude, double? longitude}) {
    if (currentState != IncidentState.IDLE) {
      throw StateError('Cannot start incident when not in IDLE state. Current state: $currentState');
    }

    final incidentId = const Uuid().v4();
    var incident = IncidentModel(
      id: incidentId,
      createdAt: DateTime.now(),
      latitude: latitude,
      longitude: longitude,
      timeline: const [],
      servicesContactedIds: const [],
      familyAlerted: false,
      bystanderCount: 0,
      currentState: IncidentState.DISCOVERY,
      countryCode: 'IN', // Default country code for the system
    );

    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.INCIDENT_OPENED,
      'Incident opened.',
    );

    if (latitude != null && longitude != null) {
      _currentIncident = incident;
      incident = _addTimelineEntry(
        TimelineEntryType.GPS_ACQUIRED,
        'GPS location acquired: $latitude, $longitude',
      );
    }

    _currentIncident = incident;
    _controller.add(incident);
  }

  void completeTriage(TriageResultModel triageResult) {
    if (currentState != IncidentState.DISCOVERY) {
      throw StateError('Cannot complete triage when current state is $currentState. Expected: DISCOVERY.');
    }

    var incident = _currentIncident!.copyWith(
      triageResult: triageResult,
      currentState: IncidentState.TRIAGE,
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.TRIAGE_COMPLETED,
      'Triage assessment completed. Priority: ${triageResult.priorityScore.name}.',
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void beginDispatch() {
    if (currentState != IncidentState.TRIAGE) {
      throw StateError('Cannot begin dispatch when current state is $currentState. Expected: TRIAGE.');
    }

    var incident = _currentIncident!.copyWith(
      currentState: IncidentState.DISPATCH,
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.STATE_TRANSITION,
      StateTransitionValidator.transitionMessage(IncidentState.TRIAGE, IncidentState.DISPATCH),
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void recordServiceContacted(String facilityId, String facilityName) {
    if (currentState != IncidentState.DISPATCH &&
        currentState != IncidentState.COORDINATION) {
      throw StateError('Cannot record service contacted when current state is $currentState. Expected: DISPATCH or COORDINATION.');
    }

    final updatedContacted = List<String>.from(_currentIncident!.servicesContactedIds);
    if (!updatedContacted.contains(facilityId)) {
      updatedContacted.add(facilityId);
    }

    var incident = _currentIncident!.copyWith(
      servicesContactedIds: updatedContacted,
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.SERVICE_CONTACTED,
      'Emergency service contacted: $facilityName',
      associatedServiceId: facilityId,
    );

    final isFirstConfirmedContact = _currentIncident!.currentState == IncidentState.DISPATCH;
    if (isFirstConfirmedContact) {
      incident = incident.copyWith(
        currentState: IncidentState.COORDINATION,
      );
      _currentIncident = incident;

      incident = _addTimelineEntry(
        TimelineEntryType.STATE_TRANSITION,
        StateTransitionValidator.transitionMessage(IncidentState.DISPATCH, IncidentState.COORDINATION),
      );
    }

    _currentIncident = incident;
    _controller.add(incident);
  }

  void recordServiceNoAnswer(String facilityId, String facilityName) {
    if (currentState != IncidentState.DISPATCH &&
        currentState != IncidentState.COORDINATION) {
      throw StateError('Cannot record service no answer when current state is $currentState. Expected: DISPATCH or COORDINATION.');
    }

    var incident = _addTimelineEntry(
      TimelineEntryType.SERVICE_NO_ANSWER,
      'No answer from service: $facilityName',
      associatedServiceId: facilityId,
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.ESCALATION_TRIGGERED,
      'Escalation triggered due to unanswered call.',
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void recordFamilyAlerted() {
    if (currentState != IncidentState.DISPATCH &&
        currentState != IncidentState.COORDINATION &&
        currentState != IncidentState.WAITING) {
      throw StateError('Cannot record family alerted when current state is $currentState. Expected: DISPATCH, COORDINATION, or WAITING.');
    }

    var incident = _currentIncident!.copyWith(
      familyAlerted: true,
      familyAlertedAt: DateTime.now(),
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.FAMILY_ALERTED,
      'Family alert SMS initiated and delivered.',
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void recordBystanderJoined() {
    if (currentState != IncidentState.COORDINATION &&
        currentState != IncidentState.WAITING) {
      throw StateError('Cannot record bystander joining when current state is $currentState. Expected: COORDINATION or WAITING.');
    }

    var incident = _currentIncident!.copyWith(
      bystanderCount: _currentIncident!.bystanderCount + 1,
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.BYSTANDER_JOINED,
      'Bystander joined. Total bystanders: ${incident.bystanderCount}.',
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void beginWaiting() {
    if (currentState != IncidentState.COORDINATION) {
      throw StateError('Cannot begin waiting when current state is $currentState. Expected: COORDINATION.');
    }

    var incident = _currentIncident!.copyWith(
      currentState: IncidentState.WAITING,
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.STATE_TRANSITION,
      StateTransitionValidator.transitionMessage(IncidentState.COORDINATION, IncidentState.WAITING),
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void resolveIncident() {
    if (currentState != IncidentState.WAITING &&
        currentState != IncidentState.COORDINATION) {
      throw StateError('Cannot resolve incident when current state is $currentState. Expected: WAITING or COORDINATION.');
    }

    var incident = _currentIncident!.copyWith(
      currentState: IncidentState.RESOLVED,
      resolvedAt: DateTime.now(),
    );
    _currentIncident = incident;

    incident = _addTimelineEntry(
      TimelineEntryType.INCIDENT_RESOLVED,
      'Incident successfully resolved.',
    );

    _currentIncident = incident;
    _controller.add(incident);
  }

  void reset() {
    _currentIncident = null;
    _controller.add(null);
  }

  void resumeIncident(IncidentModel incident) {
    _currentIncident = incident;
    _controller.add(incident);
  }

  void dispose() {
    _controller.close();
  }

  IncidentModel _addTimelineEntry(
    TimelineEntryType type,
    String message, {
    String? associatedServiceId,
  }) {
    if (_currentIncident == null) {
      throw StateError('No active incident to add timeline entry to.');
    }
    final entry = TimelineEntryModel(
      id: const Uuid().v4(),
      incidentId: _currentIncident!.id,
      timestamp: DateTime.now(),
      type: type,
      message: message,
      associatedServiceId: associatedServiceId,
      isSystemGenerated: true,
    );
    return _currentIncident!.addTimelineEntry(entry);
  }
}
