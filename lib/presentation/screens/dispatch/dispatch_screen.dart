// lib/presentation/screens/dispatch/dispatch_screen.dart
// ROADSoS - Dispatch Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/enums/priority_score.dart';
import '../../../core/enums/service_type.dart';
import '../../../core/models/facility_model.dart';
import '../../../core/utils/confidence_utils.dart';
import '../../../core/utils/distance_utils.dart';
import '../../../domain/ranking/service_ranking_algorithm.dart';
import '../../../domain/triage/triage_engine.dart';
import '../../../app/routes.dart';
import '../../../core/models/timeline_entry_model.dart';
import '../../../data/repository/incident_repository.dart';
import '../../controllers/incident_controller.dart';
import '../../controllers/service_controller.dart';

class DispatchScreen extends StatelessWidget {
  final ScrollController _scrollController = ScrollController();

  DispatchScreen({super.key});

  // Map ServiceType to IconData and color
  IconData _iconData(ServiceType type) {
    switch (type) {
      case ServiceType.HOSPITAL:
        return Icons.local_hospital;
      case ServiceType.AMBULANCE:
        return Icons.emergency;
      case ServiceType.POLICE:
        return Icons.local_police;
      case ServiceType.TOWING:
        return Icons.car_repair;
      case ServiceType.PUNCTURE:
        return Icons.tire_repair;
      case ServiceType.SHOWROOM:
        return Icons.directions_car;
    }
  }

  Color _iconColor(ServiceType type) {
    switch (type) {
      case ServiceType.HOSPITAL:
        return AppColors.nonEmergencyBlue;
      case ServiceType.AMBULANCE:
        return AppColors.confirmedGreen;
      case ServiceType.POLICE:
        return AppColors.warningAmber;
      default:
        return AppColors.textSecondary;
    }
  }

  Future<void> _makeCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      }
    } catch (_) {}
  }

  void _showCallStatusDialog(FacilityModel facility) {
    final incidentController = Get.find<IncidentController>();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          AppStrings.didSomeoneAnswer,
          style: AppTextStyles.subheadline,
        ),
        content: Row(
          children: [
            // NO Button
            Expanded(
              child: SizedBox(
                height: 56.0,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.criticalRed, width: 1.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    _showNoAnswerFollowUpDialog(facility);
                  },
                  child: Text(
                    AppStrings.answerNo,
                    style: AppTextStyles.buttonLabel.copyWith(color: AppColors.criticalRed),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16.0),
            // YES Button
            Expanded(
              child: SizedBox(
                height: 56.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.confirmedGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    incidentController.recordServiceContacted(facility.id, facility.name);
                    Get.back();
                  },
                  child: Text(
                    AppStrings.answerYes,
                    style: AppTextStyles.buttonLabel,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  void _showNoAnswerFollowUpDialog(FacilityModel facility) {
    final incidentController = Get.find<IncidentController>();
    final serviceController = Get.find<ServiceController>();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'No answer — what would you like to do?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Option 1: Try calling again (Red button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.criticalRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    Get.back();
                    await _makeCall(facility.phone);
                    _showCallStatusDialog(facility);
                  },
                  child: const Text(
                    'Try calling again',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Option 2: Try next service (Green button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.confirmedGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    incidentController.recordServiceNoAnswer(facility.id, facility.name);
                    serviceController.checkEscalation(facility, facility.serviceType);
                    
                    // Smoothly scroll to the bottom of the scroll view
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (_scrollController.hasClients) {
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      }
                    });
                  },
                  child: const Text(
                    'Try next service',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Option 3: Call 112 directly (Outlined Surface button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    Get.back();
                    final uri = Uri(scheme: 'tel', path: '112');
                    if (await canLaunchUrl(uri)) {
                      await launchUrl(uri);
                    }
                    incidentController.stateMachine.addTimelineEntry(
                      TimelineEntryType.SERVICE_NO_ANSWER,
                      'National emergency number called: 112',
                    );
                    if (incidentController.currentIncident.value != null) {
                      await IncidentRepository.saveIncident(incidentController.currentIncident.value!);
                    }
                  },
                  child: const Text(
                    'Call 112 directly',
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
            ],
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  void _showFamilyAlertDialog() {
    final incidentController = Get.find<IncidentController>();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Who needs help?',
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Select who is injured to send the correct alert message.',
              style: TextStyle(color: AppColors.textSecondary, fontSize: 14.0),
            ),
          ],
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Option 1: I am injured (Red button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.criticalRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    incidentController.sendFamilyAlert(isVictim: true);
                    Get.back();
                  },
                  child: const Text(
                    'I am injured',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Option 2: Someone else is injured (Amber button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.warningAmber,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    _showBystanderFamilyAlertDialog();
                  },
                  child: const Text(
                    'Someone else is injured',
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Cancel option
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  void _showBystanderFamilyAlertDialog() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          "Alert the victim's family",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Option 1: I have the victim's phone (Green button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.confirmedGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Family Alert',
                      "Open ROADSoS on the victim's phone and hold the SOS button to alert their family.",
                      backgroundColor: AppColors.surface,
                      colorText: AppColors.textPrimary,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text(
                    "I have the victim's phone",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 12.0),
              // Option 2: I don't have their phone (Outlined Surface button)
              SizedBox(
                height: 50.0,
                width: double.infinity,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    side: const BorderSide(color: AppColors.cardBorder, width: 1.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      'Family Alert',
                      'Focus on calling emergency services. Ambulance and police have been notified.',
                      backgroundColor: AppColors.surface,
                      colorText: AppColors.textPrimary,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  child: const Text(
                    "I don't have their phone",
                    style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15.0),
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              // Option 3: Cancel (Text button)
              TextButton(
                onPressed: () => Get.back(),
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final incidentController = Get.find<IncidentController>();
    final serviceController = Get.find<ServiceController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Obx(() {
          final triageResult = incidentController.currentIncident.value?.triageResult;
          final priority = triageResult?.priorityScore ?? PriorityScore.NON_EMERGENCY;
          final titleText = TriageEngine.getPriorityMessage(triageResult);
          return Text(
            titleText,
            style: AppTextStyles.subheadline.copyWith(
              color: AppColors.priorityColor(priority),
            ),
            overflow: TextOverflow.ellipsis,
          );
        }),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Priority Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                color: AppColors.criticalRed,
                child: Obx(() {
                  final triageResult = incidentController.currentIncident.value?.triageResult;
                  final message = TriageEngine.getPriorityMessage(triageResult);
                  return Text(
                    message,
                    style: AppTextStyles.subheadline.copyWith(color: Colors.white),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
              // Offline banner
              Obx(() {
                if (incidentController.isOffline.value) {
                  return Container(
                    width: double.infinity,
                    color: AppColors.warningAmber,
                    padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
                    child: Center(
                      child: Text(
                        AppStrings.offlineBannerText,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Emergency Services Header
                    Text(
                      AppStrings.emergencyServicesHeader,
                      style: AppTextStyles.subheadline,
                    ),
                    const SizedBox(height: 16.0),
                    // Services List
                    Obx(() {
                      final facilities = serviceController.getFacilitiesForPriorityOrder();
                      if (facilities.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 24.0),
                          child: Text(
                            AppStrings.noFacilitiesMessage,
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: facilities.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 16.0),
                        itemBuilder: (context, idx) {
                          final facility = facilities[idx];
                          final incident = incidentController.currentIncident.value;
                          debugPrint('Incident coords: ${incident?.latitude}, ${incident?.longitude}');
                          debugPrint('Facility: ${facility.name} at ${facility.latitude}, ${facility.longitude}');
                          final double distance = ServiceRankingAlgorithm.calculateDistanceKm(
                            incident?.latitude ?? 11.6643,
                            incident?.longitude ?? 78.1460,
                            facility.latitude,
                            facility.longitude,
                          );
                          debugPrint('Distance: $distance km');
                          return _buildServiceCard(context, facility, distance);
                        },
                      );
                    }),
                    const SizedBox(height: 24.0),
                    // Escalation Suggestion
                    Obx(() {
                      final nextFacility = serviceController.escalationSuggestion.value;
                      final failedFacility = serviceController.lastFailedFacility.value;

                      if (failedFacility != null && (nextFacility == null || nextFacility.id == failedFacility.id)) {
                        return Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: AppColors.cardBackground,
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border.all(
                              color: AppColors.cardBorder,
                              width: 1.0,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'No more options nearby. Call 112 directly.',
                                style: TextStyle(
                                  color: AppColors.criticalRed,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12.0),
                              SizedBox(
                                height: 48.0,
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.primaryRed,
                                    foregroundColor: Colors.white,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final uri = Uri(scheme: 'tel', path: '112');
                                    if (await canLaunchUrl(uri)) {
                                      await launchUrl(uri);
                                    }
                                  },
                                  icon: const Icon(Icons.phone, size: 18),
                                  label: const Text(
                                    'Call 112',
                                    style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      if (nextFacility == null) return const SizedBox.shrink();

                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: AppColors.cardBorder,
                            width: 1.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'No answer — next option available below',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              nextFacility.name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 12.0),
                            SizedBox(
                              height: 48.0,
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surface,
                                  foregroundColor: AppColors.textPrimary,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: const BorderSide(color: AppColors.cardBorder),
                                  ),
                                ),
                                onPressed: () {
                                  _makeCall(nextFacility.phone);
                                  _showCallStatusDialog(nextFacility);
                                },
                                icon: const Icon(Icons.phone, size: 18),
                                label: Text(
                                  'Call ${nextFacility.name}',
                                  style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Obx(() {
                      final nextFacility = serviceController.escalationSuggestion.value;
                      final failedFacility = serviceController.lastFailedFacility.value;
                      if (nextFacility != null && (failedFacility == null || nextFacility.id != failedFacility.id)) {
                        return const SizedBox(height: 24.0);
                      }
                      if (failedFacility != null) {
                        return const SizedBox(height: 24.0);
                      }
                      return const SizedBox.shrink();
                    }),
                    // Family Alert Card
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.alertFamilyHeader,
                            style: AppTextStyles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Obx(() {
                            final incident = incidentController.currentIncident.value;
                            final familyAlerted = incident?.familyAlerted ?? false;
                            if (familyAlerted) {
                              return Row(
                                children: [
                                  const Icon(
                                    Icons.check_circle,
                                    color: AppColors.confirmedGreen,
                                    size: 28.0,
                                  ),
                                  const SizedBox(width: 8.0),
                                  Expanded(
                                    child: Text(
                                      AppStrings.familyAlertSent,
                                      style: AppTextStyles.bodyLarge.copyWith(
                                        color: AppColors.confirmedGreen,
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }
                            return SizedBox(
                              height: 80.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.surface,
                                  side: const BorderSide(
                                    color: AppColors.textSecondary,
                                    width: 1.0,
                                  ),
                                ),
                                onPressed: () {
                                  _showFamilyAlertDialog();
                                },
                                child: Text(
                                  AppStrings.sendEmergencyAlertBtn,
                                  style: AppTextStyles.buttonLabel.copyWith(
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),
                    const SizedBox(height: 48.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.primaryRed,
        onPressed: () => Get.toNamed(Routes.coordination),
        label: Text(
          AppStrings.viewTimeline,
          style: AppTextStyles.buttonLabel,
        ),
        icon: const Icon(
          Icons.timeline,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, FacilityModel facility, double distanceKm) {
    final iconData = _iconData(facility.serviceType);
    final iconColor = _iconColor(facility.serviceType);
    final confLabel = ConfidenceUtils.getConfidenceLabel(facility.confidenceScore);
    final confColor = ConfidenceUtils.getConfidenceColor(facility.confidenceScore);
    final confIconStr = ConfidenceUtils.getConfidenceIcon(facility.confidenceScore);

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon in circle background
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              iconData,
              color: iconColor,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 16.0),
          // Details Section
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  facility.name,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 4.0),
                Text(
                  '${DistanceUtils.formatDistance(distanceKm)} • ${DistanceUtils.formatEta(distanceKm)}',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Text(
                      '$confIconStr $confLabel',
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: confColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      '•',
                      style: TextStyle(color: AppColors.textSecondary.withValues(alpha: 0.5)),
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        facility.verificationAge.toLowerCase().contains('today')
                            ? AppStrings.today
                            : facility.verificationAge,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16.0),
          // Call Trigger Action
          SizedBox(
            width: 80.0,
            height: 80.0, // Minimum touch target height: 80px
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryRed,
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              onPressed: () {
                _makeCall(facility.phone);
                _showCallStatusDialog(facility);
              },
              child: Text(
                AppStrings.callingLabel,
                style: AppTextStyles.buttonLabel,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
