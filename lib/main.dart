// lib/main.dart
// ROADSoS - Main Entry Point

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/app.dart';
import 'data/local/database_helper.dart';
import 'data/remote/bundle_service.dart';
import 'data/remote/config_service.dart';
import 'data/remote/sync_service.dart';
import 'data/repository/config_repository.dart';
import 'data/repository/facility_repository.dart';
import 'data/repository/incident_repository.dart';
import 'domain/state_machine/incident_state_machine.dart';
import 'presentation/controllers/bystander_controller.dart';
import 'presentation/controllers/incident_controller.dart';
import 'presentation/controllers/service_controller.dart';
import 'presentation/controllers/settings_controller.dart';
import 'presentation/controllers/timeline_controller.dart';
import 'presentation/controllers/triage_controller.dart';

void main() async {
  // 1. WidgetsFlutterBinding.ensureInitialized()
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Initialize DatabaseHelper (triggers seed data)
  final dbHelper = DatabaseHelper.instance;
  await dbHelper.database;

  // 3. Register all GetX dependencies using Get.lazyPut
  Get.lazyPut<DatabaseHelper>(() => DatabaseHelper.instance);
  Get.lazyPut<FacilityRepository>(() => FacilityRepository());
  Get.lazyPut<IncidentRepository>(() => IncidentRepository());
  Get.lazyPut<ConfigRepository>(() => ConfigRepository());
  Get.lazyPut<BundleService>(() => BundleService());
  Get.lazyPut<ConfigService>(() => ConfigService());
  Get.lazyPut<SyncService>(() => SyncService());
  Get.lazyPut<IncidentStateMachine>(() => IncidentStateMachine());

  // IncidentController (Get.put — eager, not lazy)
  final incidentController = Get.put(IncidentController(
    stateMachine: Get.find<IncidentStateMachine>(),
    incidentRepository: Get.find<IncidentRepository>(),
    facilityRepository: Get.find<FacilityRepository>(),
    syncService: Get.find<SyncService>(),
  ));
  await incidentController.initializeApp();

  Get.lazyPut<TriageController>(() => TriageController());
  Get.lazyPut<ServiceController>(() => ServiceController());
  Get.lazyPut<TimelineController>(() => TimelineController());
  Get.lazyPut<SettingsController>(() => SettingsController());
  Get.lazyPut<BystanderController>(() => BystanderController());

  // 4. runApp(RoadSoSApp())
  runApp(const RoadSoSApp());
}
