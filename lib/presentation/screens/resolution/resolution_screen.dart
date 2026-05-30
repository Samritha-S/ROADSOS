// lib/presentation/screens/resolution/resolution_screen.dart
// ROADSoS - Resolution Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app/routes.dart';
import '../../controllers/incident_controller.dart';
import '../../controllers/timeline_controller.dart';

class ResolutionScreen extends StatelessWidget {
  const ResolutionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final incidentController = Get.find<IncidentController>();
    final timelineController = Get.find<TimelineController>();

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.confirmedGreen,
          title: Text(
            AppStrings.incidentResolvedTitle,
            style: AppTextStyles.subheadline.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SafeArea(
          child: Obx(() {
            final incident = incidentController.currentIncident.value;

            final String incidentId = incident?.id ?? '';
            final String shortId = incidentId.length >= 8 ? incidentId.substring(0, 8) : 'N/A';
            
            final String timeStr = incident != null 
                ? DateFormat('HH:mm:ss').format(incident.createdAt) 
                : 'N/A';

            final String durationStr = timelineController.elapsedTimeDisplay.value;
            final int servicesCount = incident?.servicesContactedIds.length ?? 0;
            final String familyAlertedStr = incident?.familyAlerted == true 
                ? AppStrings.valueYes 
                : AppStrings.valueNo;
            final int bystanderCount = incident?.bystanderCount ?? 0;

            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // TOP SECTION
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.confirmedGreen,
                      size: 120.0,
                    ),
                    const SizedBox(height: 16.0),
                    Text(
                      AppStrings.youAreSafe,
                      style: AppTextStyles.headline,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      AppStrings.incidentDocumented,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32.0),

                    // SUMMARY CARD
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Column(
                        children: [
                          _buildSummaryRow(AppStrings.labelIncidentId, shortId),
                          const SizedBox(height: 12.0),
                          _buildSummaryRow(AppStrings.labelTime, timeStr),
                          const SizedBox(height: 12.0),
                          _buildSummaryRow(AppStrings.labelDuration, durationStr),
                          const SizedBox(height: 12.0),
                          _buildSummaryRow(AppStrings.labelServices, '$servicesCount'),
                          const SizedBox(height: 12.0),
                          _buildSummaryRow(AppStrings.labelFamilyAlert, familyAlertedStr),
                          const SizedBox(height: 12.0),
                          _buildSummaryRow(AppStrings.labelBystander, '$bystanderCount'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32.0),

                    // ARCHIVE BUTTON
                    SizedBox(
                      height: 80.0, // Touch target height: 80px
                      width: double.infinity,
                      child: Center(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 64.0),
                            backgroundColor: AppColors.surface,
                            side: const BorderSide(
                              color: AppColors.confirmedGreen,
                              width: 1.0,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          ),
                          onPressed: () {
                            Get.snackbar(
                              AppStrings.appName,
                              AppStrings.incidentReportSavedMsg,
                              backgroundColor: AppColors.surface,
                              colorText: AppColors.textPrimary,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          },
                          icon: const Icon(
                            Icons.download,
                            color: AppColors.confirmedGreen,
                            size: 24.0,
                          ),
                          label: Text(
                            AppStrings.saveIncidentReportBtn,
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: AppColors.confirmedGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16.0),

                    // NEW INCIDENT BUTTON
                    SizedBox(
                      height: 80.0, // Touch target height: 80px
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          incidentController.stateMachine.reset();
                          Get.offAllNamed(Routes.idle);
                        },
                        child: Text(
                          AppStrings.returnToHomeBtn,
                          style: AppTextStyles.buttonLabel,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyLarge.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
