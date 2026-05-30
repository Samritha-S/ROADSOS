// lib/core/models/timeline_entry_model.dart
// ROADSoS - Timeline Entry Model

// ignore_for_file: constant_identifier_names

import 'package:intl/intl.dart';

enum TimelineEntryType {
  INCIDENT_OPENED,
  GPS_ACQUIRED,
  TRIAGE_COMPLETED,
  SERVICE_CONTACTED,
  SERVICE_NO_ANSWER,
  FAMILY_ALERTED,
  BYSTANDER_JOINED,
  ESCALATION_TRIGGERED,
  STATE_TRANSITION,
  INCIDENT_RESOLVED
}

class TimelineEntryModel {
  final String id;
  final String incidentId;
  final DateTime timestamp;
  final TimelineEntryType type;
  final String message;
  final String? associatedServiceId;
  final bool isSystemGenerated;

  const TimelineEntryModel({
    required this.id,
    required this.incidentId,
    required this.timestamp,
    required this.type,
    required this.message,
    this.associatedServiceId,
    required this.isSystemGenerated,
  });

  String get formattedTime => DateFormat('HH:mm:ss').format(timestamp);

  String get relativeTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    final seconds = difference.inSeconds;
    if (seconds < 60) {
      if (seconds <= 0) return '0 seconds ago';
      return '$seconds ${seconds == 1 ? "second" : "seconds"} ago';
    }
    final minutes = difference.inMinutes;
    if (minutes < 60) {
      return '$minutes ${minutes == 1 ? "minute" : "minutes"} ago';
    }
    final hours = difference.inHours;
    if (hours < 24) {
      return '$hours ${hours == 1 ? "hour" : "hours"} ago';
    }
    final days = difference.inDays;
    return '$days ${days == 1 ? "day" : "days"} ago';
  }

  TimelineEntryModel copyWith({
    String? id,
    String? incidentId,
    DateTime? timestamp,
    TimelineEntryType? type,
    String? message,
    String? associatedServiceId,
    bool? isSystemGenerated,
  }) {
    return TimelineEntryModel(
      id: id ?? this.id,
      incidentId: incidentId ?? this.incidentId,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      message: message ?? this.message,
      associatedServiceId: associatedServiceId ?? this.associatedServiceId,
      isSystemGenerated: isSystemGenerated ?? this.isSystemGenerated,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'incidentId': incidentId,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'message': message,
      'associatedServiceId': associatedServiceId,
      'isSystemGenerated': isSystemGenerated ? 1 : 0,
    };
  }

  factory TimelineEntryModel.fromMap(Map<String, dynamic> map) {
    return TimelineEntryModel(
      id: map['id'] as String,
      incidentId: map['incidentId'] as String,
      timestamp: DateTime.parse(map['timestamp'] as String),
      type: TimelineEntryType.values.byName(map['type'] as String),
      message: map['message'] as String,
      associatedServiceId: map['associatedServiceId'] as String?,
      isSystemGenerated: (map['isSystemGenerated'] as int) == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidentId': incidentId,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'message': message,
      'associatedServiceId': associatedServiceId,
      'isSystemGenerated': isSystemGenerated,
    };
  }

  factory TimelineEntryModel.fromJson(Map<String, dynamic> json) {
    return TimelineEntryModel(
      id: json['id'] as String,
      incidentId: json['incidentId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: TimelineEntryType.values.byName(json['type'] as String),
      message: json['message'] as String,
      associatedServiceId: json['associatedServiceId'] as String?,
      isSystemGenerated: json['isSystemGenerated'] as bool,
    );
  }
}
