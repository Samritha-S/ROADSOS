// lib/core/models/incident_model.dart
// ROADSoS - Incident Model

import 'dart:convert';
import '../enums/incident_state.dart';
import 'timeline_entry_model.dart';
import 'triage_result_model.dart';

class IncidentModel {
  final String id;
  final DateTime createdAt;
  final double? latitude;
  final double? longitude;
  final TriageResultModel? triageResult;
  final List<TimelineEntryModel> timeline;
  final List<String> servicesContactedIds;
  final bool familyAlerted;
  final DateTime? familyAlertedAt;
  final int bystanderCount;
  final IncidentState currentState;
  final DateTime? resolvedAt;
  final String countryCode;

  const IncidentModel({
    required this.id,
    required this.createdAt,
    this.latitude,
    this.longitude,
    this.triageResult,
    required this.timeline,
    required this.servicesContactedIds,
    required this.familyAlerted,
    this.familyAlertedAt,
    required this.bystanderCount,
    required this.currentState,
    this.resolvedAt,
    required this.countryCode,
  });

  Duration get elapsedTime {
    final end = resolvedAt ?? DateTime.now();
    return end.difference(createdAt);
  }

  bool get isActive => currentState != IncidentState.RESOLVED;

  bool get hasLocation => latitude != null && longitude != null;

  IncidentModel addTimelineEntry(TimelineEntryModel entry) {
    return copyWith(
      timeline: [...timeline, entry],
    );
  }

  IncidentModel withState(IncidentState newState) {
    return copyWith(
      currentState: newState,
      resolvedAt: newState == IncidentState.RESOLVED ? DateTime.now() : resolvedAt,
    );
  }

  IncidentModel copyWith({
    String? id,
    DateTime? createdAt,
    double? latitude,
    double? longitude,
    TriageResultModel? triageResult,
    List<TimelineEntryModel>? timeline,
    List<String>? servicesContactedIds,
    bool? familyAlerted,
    DateTime? familyAlertedAt,
    int? bystanderCount,
    IncidentState? currentState,
    DateTime? resolvedAt,
    String? countryCode,
  }) {
    return IncidentModel(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      triageResult: triageResult ?? this.triageResult,
      timeline: timeline ?? this.timeline,
      servicesContactedIds: servicesContactedIds ?? this.servicesContactedIds,
      familyAlerted: familyAlerted ?? this.familyAlerted,
      familyAlertedAt: familyAlertedAt ?? this.familyAlertedAt,
      bystanderCount: bystanderCount ?? this.bystanderCount,
      currentState: currentState ?? this.currentState,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      countryCode: countryCode ?? this.countryCode,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'triage_result': triageResult != null ? jsonEncode(triageResult!.toMap()) : null,
      'timeline': jsonEncode(timeline.map((e) => e.toMap()).toList()),
      'services_contacted_ids': jsonEncode(servicesContactedIds),
      'family_alerted': familyAlerted ? 1 : 0,
      'family_alerted_at': familyAlertedAt?.toIso8601String(),
      'bystander_count': bystanderCount,
      'current_state': currentState.name,
      'resolved_at': resolvedAt?.toIso8601String(),
      'country_code': countryCode,
    };
  }

  factory IncidentModel.fromMap(Map<String, dynamic> map) {
    final triageResultStr = map['triage_result'] as String?;
    final timelineStr = map['timeline'] as String;
    final servicesContactedStr = map['services_contacted_ids'] as String;

    return IncidentModel(
      id: map['id'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      latitude: map['latitude'] != null ? (map['latitude'] as num).toDouble() : null,
      longitude: map['longitude'] != null ? (map['longitude'] as num).toDouble() : null,
      triageResult: triageResultStr != null
          ? TriageResultModel.fromMap(jsonDecode(triageResultStr) as Map<String, dynamic>)
          : null,
      timeline: (jsonDecode(timelineStr) as List)
          .map((e) => TimelineEntryModel.fromMap(e as Map<String, dynamic>))
          .toList(),
      servicesContactedIds: List<String>.from(jsonDecode(servicesContactedStr) as List),
      familyAlerted: (map['family_alerted'] as int) == 1,
      familyAlertedAt: map['family_alerted_at'] != null
          ? DateTime.parse(map['family_alerted_at'] as String)
          : null,
      bystanderCount: map['bystander_count'] as int,
      currentState: IncidentState.values.byName(map['current_state'] as String),
      resolvedAt: map['resolved_at'] != null
          ? DateTime.parse(map['resolved_at'] as String)
          : null,
      countryCode: map['country_code'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'triageResult': triageResult?.toJson(),
      'timeline': timeline.map((e) => e.toJson()).toList(),
      'servicesContactedIds': servicesContactedIds,
      'familyAlerted': familyAlerted,
      'familyAlertedAt': familyAlertedAt?.toIso8601String(),
      'bystanderCount': bystanderCount,
      'currentState': currentState.name,
      'resolvedAt': resolvedAt?.toIso8601String(),
      'countryCode': countryCode,
    };
  }

  factory IncidentModel.fromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      latitude: json['latitude'] != null ? (json['latitude'] as num).toDouble() : null,
      longitude: json['longitude'] != null ? (json['longitude'] as num).toDouble() : null,
      triageResult: json['triageResult'] != null
          ? TriageResultModel.fromJson(json['triageResult'] as Map<String, dynamic>)
          : null,
      timeline: (json['timeline'] as List)
          .map((e) => TimelineEntryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      servicesContactedIds: List<String>.from(json['servicesContactedIds'] as List),
      familyAlerted: json['familyAlerted'] as bool,
      familyAlertedAt: json['familyAlertedAt'] != null
          ? DateTime.parse(json['familyAlertedAt'] as String)
          : null,
      bystanderCount: json['bystanderCount'] as int,
      currentState: IncidentState.values.byName(json['currentState'] as String),
      resolvedAt: json['resolvedAt'] != null
          ? DateTime.parse(json['resolvedAt'] as String)
          : null,
      countryCode: json['countryCode'] as String,
    );
  }
}
