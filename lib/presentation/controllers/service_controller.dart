// lib/presentation/controllers/service_controller.dart
// ROADSoS - Service Controller

import 'package:get/get.dart';

import '../../core/enums/priority_score.dart';
import '../../core/enums/service_type.dart';
import '../../core/models/facility_model.dart';
import '../../domain/ranking/service_ranking_algorithm.dart';
import '../../domain/escalation/escalation_manager.dart';
import '../../domain/triage/triage_engine.dart';
import 'incident_controller.dart';

class ServiceController extends GetxController {
  // Observable state
  final RxList<FacilityModel> allFacilities = RxList<FacilityModel>([]);
  final RxList<FacilityModel> ambulanceFacilities = RxList<FacilityModel>([]);
  final RxList<FacilityModel> hospitalFacilities = RxList<FacilityModel>([]);
  final RxList<FacilityModel> policeFacilities = RxList<FacilityModel>([]);
  final RxList<FacilityModel> towingFacilities = RxList<FacilityModel>([]);
  final RxList<FacilityModel> punctureFacilities = RxList<FacilityModel>([]);
  final RxList<FacilityModel> showroomFacilities = RxList<FacilityModel>([]);
  
  final RxBool isLoading = false.obs;
  final Rx<FacilityModel?> escalationSuggestion = Rx<FacilityModel?>(null);

  void updateFacilities(List<FacilityModel> facilities, {double? latitude, double? longitude}) {
    allFacilities.value = facilities;
    
    final incidentController = Get.find<IncidentController>();
    final currentIncident = incidentController.currentIncident.value;
    
    final lat = latitude ?? currentIncident?.latitude;
    final lon = longitude ?? currentIncident?.longitude;
    
    if (lat == null || lon == null) {
      // Cannot rank without coordinates, just split by type without distance ranking
      _splitUnrankedFacilities(facilities);
      return;
    }

    final priority = incidentController.priorityScore;

    ambulanceFacilities.value = ServiceRankingAlgorithm.rankFacilities(
      facilities: facilities,
      userLatitude: lat,
      userLongitude: lon,
      priorityScore: priority ?? PriorityScore.NON_EMERGENCY,
      serviceType: ServiceType.AMBULANCE,
    );
    
    hospitalFacilities.value = ServiceRankingAlgorithm.rankFacilities(
      facilities: facilities,
      userLatitude: lat,
      userLongitude: lon,
      priorityScore: priority ?? PriorityScore.NON_EMERGENCY,
      serviceType: ServiceType.HOSPITAL,
    );
    
    policeFacilities.value = ServiceRankingAlgorithm.rankFacilities(
      facilities: facilities,
      userLatitude: lat,
      userLongitude: lon,
      priorityScore: priority ?? PriorityScore.NON_EMERGENCY,
      serviceType: ServiceType.POLICE,
    );
    
    towingFacilities.value = ServiceRankingAlgorithm.rankFacilities(
      facilities: facilities,
      userLatitude: lat,
      userLongitude: lon,
      priorityScore: priority ?? PriorityScore.NON_EMERGENCY,
      serviceType: ServiceType.TOWING,
    );
    
    punctureFacilities.value = ServiceRankingAlgorithm.rankFacilities(
      facilities: facilities,
      userLatitude: lat,
      userLongitude: lon,
      priorityScore: priority ?? PriorityScore.NON_EMERGENCY,
      serviceType: ServiceType.PUNCTURE,
    );
    
    showroomFacilities.value = ServiceRankingAlgorithm.rankFacilities(
      facilities: facilities,
      userLatitude: lat,
      userLongitude: lon,
      priorityScore: priority ?? PriorityScore.NON_EMERGENCY,
      serviceType: ServiceType.SHOWROOM,
    );
  }

  void _splitUnrankedFacilities(List<FacilityModel> facilities) {
    ambulanceFacilities.value = facilities.where((f) => f.serviceType == ServiceType.AMBULANCE).toList();
    hospitalFacilities.value = facilities.where((f) => f.serviceType == ServiceType.HOSPITAL).toList();
    policeFacilities.value = facilities.where((f) => f.serviceType == ServiceType.POLICE).toList();
    towingFacilities.value = facilities.where((f) => f.serviceType == ServiceType.TOWING).toList();
    punctureFacilities.value = facilities.where((f) => f.serviceType == ServiceType.PUNCTURE).toList();
    showroomFacilities.value = facilities.where((f) => f.serviceType == ServiceType.SHOWROOM).toList();
  }

  List<FacilityModel> getFacilitiesForPriorityOrder() {
    final incidentController = Get.find<IncidentController>();
    final triageResult = incidentController.currentIncident.value?.triageResult;
    
    if (triageResult == null) return [];
    
    final priorityOrder = TriageEngine.getPriorityOrder(triageResult);
    
    List<FacilityModel> topFacilities = [];
    
    // Pick the top 1 from each of the first 3 priority service types (or whatever is available)
    for (final serviceType in priorityOrder.take(3)) {
      final listForType = _getListForType(serviceType);
      if (listForType.isNotEmpty) {
        topFacilities.add(listForType.first);
      }
    }
    
    return topFacilities;
  }

  final Rx<FacilityModel?> lastFailedFacility = Rx<FacilityModel?>(null);

  void checkEscalation(FacilityModel failedFacility, ServiceType serviceType) {
    lastFailedFacility.value = failedFacility;
    final incidentController = Get.find<IncidentController>();
    final currentIncident = incidentController.currentIncident.value;
    
    if (currentIncident == null) return;
    
    final rankedList = _getListForType(serviceType);
    
    List<String> excludeIds = [
      ...currentIncident.servicesContactedIds,
      failedFacility.id,
    ];
    
    final nextFacility = EscalationManager.getNextFacility(
      rankedFacilities: rankedList,
      alreadyContactedIds: excludeIds,
    );
    
    escalationSuggestion.value = nextFacility;
  }

  List<FacilityModel> _getListForType(ServiceType serviceType) {
    switch (serviceType) {
      case ServiceType.AMBULANCE:
        return ambulanceFacilities;
      case ServiceType.HOSPITAL:
        return hospitalFacilities;
      case ServiceType.POLICE:
        return policeFacilities;
      case ServiceType.TOWING:
        return towingFacilities;
      case ServiceType.PUNCTURE:
        return punctureFacilities;
      case ServiceType.SHOWROOM:
        return showroomFacilities;
    }
  }
}
