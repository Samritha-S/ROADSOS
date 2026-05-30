// lib/domain/coordination/incident_timeline_manager.dart
// ROADSoS - Incident Timeline Manager

import 'package:uuid/uuid.dart';
import '../../core/models/timeline_entry_model.dart';

class IncidentTimelineManager {
  IncidentTimelineManager._();

  static TimelineEntryModel createEntry({
    required String incidentId,
    required TimelineEntryType type,
    required String message,
    String? associatedServiceId,
    bool isSystemGenerated = true,
  }) {
    return TimelineEntryModel(
      id: const Uuid().v4(),
      incidentId: incidentId,
      timestamp: DateTime.now(),
      type: type,
      message: message,
      associatedServiceId: associatedServiceId,
      isSystemGenerated: isSystemGenerated,
    );
  }

  static List<TimelineEntryModel> sortByNewest(
    List<TimelineEntryModel> entries,
  ) {
    final list = List<TimelineEntryModel>.from(entries);
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  static List<TimelineEntryModel> filterByType(
    List<TimelineEntryModel> entries,
    TimelineEntryType type,
  ) {
    return entries.where((e) => e.type == type).toList();
  }
}
