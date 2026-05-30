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
import '../../controllers/incident_controller.dart';
import '../../controllers/service_controller.dart';

class DispatchScreen extends StatelessWidget {
  const DispatchScreen({super.key});

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

  void _showCallStatusDialog(BuildContext context, FacilityModel facility) {
    final incidentController = Get.find<IncidentController>();
    final serviceController = Get.find<ServiceController>();

    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          AppStrings.didSomeoneAnswer,
          style: AppTextStyles.subheadline,
        ),
        actions: [
          // NO Button
          SizedBox(
            height: 80.0, // Minimum touch target height: 80px
            child: TextButton(
              onPressed: () {
                incidentController.recordServiceNoAnswer(facility.id, facility.name);
                serviceController.checkEscalation(facility, facility.serviceType);
                Get.back();
              },
              child: Text(
                AppStrings.answerNo,
                style: AppTextStyles.buttonLabel.copyWith(color: AppColors.criticalRed),
              ),
            ),
          ),
          // YES Button
          SizedBox(
            height: 80.0, // Minimum touch target height: 80px
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.confirmedGreen,
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
        ],
      ),
      barrierDismissible: false,
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
          final priority = incidentController.priorityScore ?? PriorityScore.NON_EMERGENCY;
          final titleText = TriageEngine.getPriorityMessage(priority);
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
        child: Column(
          children: [
            // Priority Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              color: AppColors.criticalRed,
              child: Obx(() {
                final priority = incidentController.priorityScore ?? PriorityScore.NON_EMERGENCY;
                final message = TriageEngine.getPriorityMessage(priority);
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
            Expanded(
              child: SingleChildScrollView(
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
                          final double distance = ServiceRankingAlgorithm.calculateDistanceKm(
                            incident?.latitude ?? 11.6643,
                            incident?.longitude ?? 78.1460,
                            facility.latitude,
                            facility.longitude,
                          );
                          return _buildServiceCard(context, facility, distance);
                        },
                      );
                    }),
                    const SizedBox(height: 24.0),
                    // Escalation Suggestion
                    Obx(() {
                      final nextFacility = serviceController.escalationSuggestion.value;
                      if (nextFacility == null) return const SizedBox.shrink();
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: AppColors.warningAmber,
                            width: 2.0,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.noAnswerPrompt,
                              style: AppTextStyles.bodyLarge.copyWith(
                                color: AppColors.warningAmber,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              nextFacility.name,
                              style: AppTextStyles.bodyLarge,
                            ),
                            const SizedBox(height: 16.0),
                            SizedBox(
                              height: 80.0,
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primaryRed,
                                ),
                                onPressed: () {
                                  _makeCall(nextFacility.phone);
                                  _showCallStatusDialog(context, nextFacility);
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
                    }),
                    Obx(() {
                      if (serviceController.escalationSuggestion.value != null) {
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
                                onPressed: () => incidentController.sendFamilyAlert(),
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
            ),
          ],
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
              color: iconColor.withOpacity(0.15),
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
                _showCallStatusDialog(context, facility);
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
