// lib/core/models/triage_result_model.dart
// ROADSoS - Triage Result Model

import '../enums/priority_score.dart';

class TriageResultModel {
  final bool anyoneInjured;
  final bool seriousSymptoms;
  final bool immediateHazard;
  final PriorityScore priorityScore;
  final DateTime completedAt;

  const TriageResultModel({
    required this.anyoneInjured,
    required this.seriousSymptoms,
    required this.immediateHazard,
    required this.priorityScore,
    required this.completedAt,
  });

  factory TriageResultModel.compute({
    required bool anyoneInjured,
    required bool seriousSymptoms,
    required bool immediateHazard,
    DateTime? completedAt,
  }) {
    PriorityScore score;
    if (immediateHazard || seriousSymptoms) {
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
      completedAt: completedAt ?? DateTime.now(),
    );
  }

  TriageResultModel copyWith({
    bool? anyoneInjured,
    bool? seriousSymptoms,
    bool? immediateHazard,
    PriorityScore? priorityScore,
    DateTime? completedAt,
  }) {
    return TriageResultModel(
      anyoneInjured: anyoneInjured ?? this.anyoneInjured,
      seriousSymptoms: seriousSymptoms ?? this.seriousSymptoms,
      immediateHazard: immediateHazard ?? this.immediateHazard,
      priorityScore: priorityScore ?? this.priorityScore,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'anyoneInjured': anyoneInjured ? 1 : 0,
      'seriousSymptoms': seriousSymptoms ? 1 : 0,
      'immediateHazard': immediateHazard ? 1 : 0,
      'priorityScore': priorityScore.name,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory TriageResultModel.fromMap(Map<String, dynamic> map) {
    return TriageResultModel(
      anyoneInjured: (map['anyoneInjured'] as int) == 1,
      seriousSymptoms: (map['seriousSymptoms'] as int) == 1,
      immediateHazard: (map['immediateHazard'] as int) == 1,
      priorityScore: PriorityScore.values.byName(map['priorityScore'] as String),
      completedAt: DateTime.parse(map['completedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'anyoneInjured': anyoneInjured,
      'seriousSymptoms': seriousSymptoms,
      'immediateHazard': immediateHazard,
      'priorityScore': priorityScore.name,
      'completedAt': completedAt.toIso8601String(),
    };
  }

  factory TriageResultModel.fromJson(Map<String, dynamic> json) {
    return TriageResultModel(
      anyoneInjured: json['anyoneInjured'] as bool,
      seriousSymptoms: json['seriousSymptoms'] as bool,
      immediateHazard: json['immediateHazard'] as bool,
      priorityScore: PriorityScore.values.byName(json['priorityScore'] as String),
      completedAt: DateTime.parse(json['completedAt'] as String),
    );
  }
}
