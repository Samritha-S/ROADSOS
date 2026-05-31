// lib/presentation/controllers/timeline_controller.dart
// ROADSoS - Timeline Controller

import 'dart:async';
import 'package:get/get.dart';

import '../../core/models/incident_model.dart';
import '../../core/models/timeline_entry_model.dart';
import '../../domain/coordination/incident_timeline_manager.dart';

class TimelineController extends GetxController {
  // Observable state
  final RxList<TimelineEntryModel> timelineEntries = RxList<TimelineEntryModel>([]);
  final RxString elapsedTimeDisplay = '0:00'.obs;
  final RxBool isUpdating = false.obs;

  Timer? _elapsedTimer;
  DateTime? _timerStartTime;

  void syncFromIncident(IncidentModel incident) {
    isUpdating.value = true;
    timelineEntries.value = IncidentTimelineManager.sortByNewest(incident.timeline);
    isUpdating.value = false;
  }

  void startElapsedTimer(DateTime incidentStartTime) {
    _elapsedTimer?.cancel(); // cancel any existing timer
    _timerStartTime = DateTime.now();
    
    // Immediate first update
    _updateElapsedDisplay();
    
    // Periodic update
    _elapsedTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateElapsedDisplay();
    });
  }

  void _updateElapsedDisplay() {
    final startTime = _timerStartTime ?? DateTime.now();
    final elapsed = DateTime.now().difference(startTime);
    elapsedTimeDisplay.value = formatElapsed(elapsed);
  }

  String formatElapsed(Duration duration) {
    final absDuration = duration.isNegative ? Duration.zero : duration;
    
    final hours = absDuration.inHours;
    final minutes = absDuration.inMinutes % 60;
    final seconds = absDuration.inSeconds % 60;
    
    final hh = hours.toString().padLeft(2, '0');
    final mm = minutes.toString().padLeft(2, '0');
    final ss = seconds.toString().padLeft(2, '0');
    
    if (hours >= 1) {
      return '$hh:$mm:$ss';
    }
    
    return '$mm:$ss';
  }

  @override
  void onClose() {
    _elapsedTimer?.cancel();
    super.onClose();
  }
}
