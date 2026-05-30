// lib/presentation/controllers/bystander_controller.dart
// ROADSoS - Bystander Controller

import 'package:get/get.dart';

import 'incident_controller.dart';

class BystanderController extends GetxController {
  // Observable state
  final RxString incidentCode = ''.obs;
  final RxBool hasJoinedIncident = false.obs;
  final RxString selectedTask = ''.obs;
  
  final RxList<String> availableTasks = RxList<String>([
    'Stay with the victim',
    'Manage traffic',
    'Guide the ambulance',
    'Help call for assistance',
  ]);
  
  final RxBool taskConfirmed = false.obs;

  String generateIncidentCode() {
    final incidentController = Get.find<IncidentController>();
    final currentIncident = incidentController.currentIncident.value;
    
    if (currentIncident == null) {
      incidentCode.value = '';
      return '';
    }

    // Uses first 6 chars of incident UUID (uppercase)
    final uuid = currentIncident.id;
    if (uuid.length >= 6) {
      final code = uuid.substring(0, 6).toUpperCase();
      incidentCode.value = code;
      return code;
    }
    
    return '';
  }

  void joinWithCode(String code) {
    if (code.trim().isEmpty) return;
    
    hasJoinedIncident.value = true;
    incidentCode.value = code.trim().toUpperCase();
    
    if (Get.isRegistered<IncidentController>()) {
      // We assume bystander is joining the global incident network
      // (For this mock/offline app, this just logs it locally in the timeline)
      Get.find<IncidentController>().stateMachine.recordBystanderJoined();
    }
  }

  void selectTask(String task) {
    selectedTask.value = task;
  }

  void confirmTask() {
    if (selectedTask.value.isNotEmpty) {
      taskConfirmed.value = true;
    }
  }

  void reset() {
    incidentCode.value = '';
    hasJoinedIncident.value = false;
    selectedTask.value = '';
    taskConfirmed.value = false;
  }
}
