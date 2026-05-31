// lib/presentation/controllers/incident_controller.dart
// ROADSoS - Incident Controller

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../../core/enums/incident_state.dart';
import '../../core/enums/priority_score.dart';
import '../../core/models/country_config_model.dart';
import '../../core/models/incident_model.dart';
import '../../data/repository/config_repository.dart';
import '../../data/repository/facility_repository.dart';
import '../../data/repository/incident_repository.dart';
import '../../data/remote/sync_service.dart';
import '../../domain/state_machine/incident_state_machine.dart';
import '../../domain/triage/triage_engine.dart';
import 'service_controller.dart';
import 'timeline_controller.dart';

class IncidentController extends GetxController {
  final IncidentStateMachine stateMachine;
  final IncidentRepository incidentRepository;
  final FacilityRepository facilityRepository;
  final SyncService syncService; // Assuming SyncService can be passed or we just call static methods

  IncidentController({
    required this.stateMachine,
    required this.incidentRepository,
    required this.facilityRepository,
    required this.syncService,
  });

  // Observable state
  final Rx<IncidentModel?> currentIncident = Rx<IncidentModel?>(null);
  final RxBool isLoading = false.obs;
  final RxBool isOffline = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<CountryConfigModel> activeCountryConfig =
      Rx<CountryConfigModel>(CountryConfigModel.defaults.first);

  late StreamSubscription<IncidentModel?> _stateMachineSub;

  @override
  void onInit() {
    super.onInit();
    _stateMachineSub = stateMachine.incidentStream.listen((incident) {
      currentIncident.value = incident;
    });
  }

  @override
  void onClose() {
    _stateMachineSub.cancel();
    super.onClose();
  }

  Future<void> initializeApp() async {
    // 1. Load active country config
    final config = await ConfigRepository.getConfigForCountry('IN'); // Defaulting to IN initially
    activeCountryConfig.value = config;

    // 2. Check for unresolved incident
    final activeIncident = await IncidentRepository.getActiveIncident();
    if (activeIncident != null) {
      // Rehydrate state machine
      // (Assuming stateMachine has a way to resume, or we just rely on its current state.
      // Since it's a new session, we need to push it to the state machine stream)
      stateMachine.resumeIncident(activeIncident); 
    }

    // 3. Set offline mode based on connectivity
    final connectivityResult = await Connectivity().checkConnectivity();
    isOffline.value = connectivityResult.contains(ConnectivityResult.none);
  }

  Future<void> triggerSOS() async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          timeLimit: const Duration(seconds: 8),
        );
      } catch (e) {
        // Timeout or permission denied — proceed without GPS
        position = null;
      }

      stateMachine.startIncident(
        latitude: position?.latitude,
        longitude: position?.longitude,
      );

      Get.find<TimelineController>().startElapsedTimer(
        DateTime.now(),
      );

      final incident = currentIncident.value;
      if (incident != null) {
        await IncidentRepository.saveIncident(incident);
      }
    } catch (e) {
      errorMessage.value = 'Failed to trigger SOS: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitTriage({
    required bool q1Answer,
    required bool q2Answer,
    required bool q3Answer,
    bool q1NotSure = false,
    bool q2NotSure = false,
    bool q3NotSure = false,
  }) async {
    final triageResult = TriageEngine.computeResult(
      q1Answer: q1Answer,
      q2Answer: q2Answer,
      q3Answer: q3Answer,
      q1NotSure: q1NotSure,
      q2NotSure: q2NotSure,
      q3NotSure: q3NotSure,
    );

    stateMachine.completeTriage(triageResult);
    stateMachine.beginDispatch();

    if (currentIncident.value != null) {
      await IncidentRepository.saveIncident(currentIncident.value!);
    }

    await loadNearbyFacilities();
  }

  Future<void> loadNearbyFacilities() async {
    final incident = currentIncident.value;
    double lat = 11.6643;
    double lon = 78.1460;

    if (incident != null && incident.latitude != null && incident.longitude != null) {
      lat = incident.latitude!;
      lon = incident.longitude!;
    }

    // Print coordinates to console
    // ignore: avoid_print
    print('ROADSoS Coordinates used for facilities: lat=$lat, lon=$lon');

    final facilities = await FacilityRepository.getFacilitiesNearLocation(
      latitude: lat,
      longitude: lon,
      countryCode: activeCountryConfig.value.countryCode,
    );

    if (Get.isRegistered<ServiceController>()) {
      Get.find<ServiceController>().updateFacilities(
        facilities,
        latitude: lat,
        longitude: lon,
      );
    }
  }

  Future<void> recordServiceContacted(String facilityId, String facilityName) async {
    stateMachine.recordServiceContacted(facilityId, facilityName);
    if (currentIncident.value != null) {
      await IncidentRepository.saveIncident(currentIncident.value!);
    }
  }

  Future<void> recordServiceNoAnswer(String facilityId, String facilityName) async {
    stateMachine.recordServiceNoAnswer(facilityId, facilityName);
    if (currentIncident.value != null) {
      await IncidentRepository.saveIncident(currentIncident.value!);
    }
  }

  Future<void> sendFamilyAlert({bool isVictim = true}) async {
    final incident = currentIncident.value;
    if (incident == null) return;

    // Orchestration only - actual SMS logic belongs in SmsUtils
    // final message = FamilyAlertManager.composeSmsMessage(
    //   latitude: incident.latitude,
    //   longitude: incident.longitude,
    //   incidentTime: incident.createdAt,
    //   countryCode: incident.countryCode,
    //   isVictim: isVictim,
    // );

    stateMachine.recordFamilyAlerted();
    await IncidentRepository.saveIncident(currentIncident.value!);
  }

  Future<void> resolveIncident() async {
    stateMachine.resolveIncident();
    final incident = currentIncident.value;
    
    if (incident != null) {
      await IncidentRepository.saveIncident(incident);
      // Fire and forget sync
      SyncService.syncIncident(incident);
    }
  }

  Future<void> switchCountry(String countryCode) async {
    final config = await ConfigRepository.getConfigForCountry(countryCode);
    activeCountryConfig.value = config;

    if (hasActiveIncident) {
      await loadNearbyFacilities();
    }
  }

  void setOfflineMode(bool offline) {
    isOffline.value = offline;
  }

  IncidentState get currentState =>
      currentIncident.value?.currentState ?? IncidentState.IDLE;

  bool get hasActiveIncident =>
      currentIncident.value?.isActive ?? false;

  PriorityScore? get priorityScore =>
      currentIncident.value?.triageResult?.priorityScore;
}
