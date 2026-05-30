import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/models/timeline_entry_model.dart';
import '../../../domain/triage/triage_engine.dart';
import '../../../app/routes.dart';
import '../../controllers/incident_controller.dart';
import '../../controllers/timeline_controller.dart';

class WaitingScreen extends StatefulWidget {
  const WaitingScreen({super.key});

  @override
  State<WaitingScreen> createState() => _WaitingScreenState();
}

class _WaitingScreenState extends State<WaitingScreen> {
  final _incidentController = Get.find<IncidentController>();
  final _timelineController = Get.find<TimelineController>();
  late Worker _incidentWorker;

  @override
  void initState() {
    super.initState();

    final currentIncident = _incidentController.currentIncident.value;
    if (currentIncident != null) {
      _timelineController.syncFromIncident(currentIncident);
      _timelineController.startElapsedTimer(currentIncident.createdAt);
    }

    _incidentWorker = ever(_incidentController.currentIncident, (incident) {
      if (incident != null) {
        _timelineController.syncFromIncident(incident);
      }
    });
  }

  @override
  void dispose() {
    _incidentWorker.dispose();
    super.dispose();
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }

  Color _getEntryColor(TimelineEntryType type) {
    switch (type) {
      case TimelineEntryType.INCIDENT_OPENED:
      case TimelineEntryType.GPS_ACQUIRED:
      case TimelineEntryType.STATE_TRANSITION:
        return AppColors.textSecondary;
      case TimelineEntryType.TRIAGE_COMPLETED:
      case TimelineEntryType.SERVICE_CONTACTED:
      case TimelineEntryType.FAMILY_ALERTED:
        return AppColors.confirmedGreen;
      case TimelineEntryType.SERVICE_NO_ANSWER:
        return AppColors.warningAmber;
      case TimelineEntryType.BYSTANDER_JOINED:
        return AppColors.nonEmergencyBlue;
      case TimelineEntryType.ESCALATION_TRIGGERED:
        return AppColors.urgentOrange;
      case TimelineEntryType.INCIDENT_RESOLVED:
        return AppColors.confirmedGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text(
          AppStrings.helpIsComing,
          style: AppTextStyles.subheadline.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              // TOP SECTION (flex 2)
              Expanded(
                flex: 2,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: AppColors.confirmedGreen,
                        size: 80.0,
                      ),
                      const SizedBox(height: 12.0),
                      Text(
                        AppStrings.helpContacted,
                        style: AppTextStyles.subheadline.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8.0),
                      Obx(() {
                        return Text(
                          '${AppStrings.timeElapsed} ${_timelineController.elapsedTimeDisplay.value}',
                          style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
                            color: AppColors.textSecondary,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),

              // CALM INSTRUCTIONS CARD (flex 2)
              Expanded(
                flex: 2,
                child: Center(
                  child: Obx(() {
                    final incident = _incidentController.currentIncident.value;
                    final triageResult = incident?.triageResult;
                    final instructions = triageResult != null
                        ? TriageEngine.getCalmInstructions(triageResult)
                        : 'Stay calm. Help is on the way.';

                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(12.0),
                        border: const Border(
                          left: BorderSide(
                            color: AppColors.confirmedGreen,
                            width: 4.0,
                          ),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          instructions,
                          style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
                            height: 1.8,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              // SERVICES SUMMARY (flex 1)
              Expanded(
                flex: 1,
                child: Center(
                  child: Obx(() {
                    final incident = _incidentController.currentIncident.value;
                    final contactedCount = incident?.servicesContactedIds.length ?? 0;
                    final helpersCount = incident?.bystanderCount ?? 0;
                    final familyText = incident?.familyAlerted == true
                        ? AppStrings.familyAlertSent
                        : 'Family alert not sent';

                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$contactedCount ${AppStrings.servicesContactedSuffix} • $helpersCount ${AppStrings.helpersPresentSuffix}',
                          style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          familyText,
                          style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
                            color: incident?.familyAlerted == true
                                ? AppColors.confirmedGreen
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),

              // TIMELINE PREVIEW (flex 2)
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Obx(() {
                        // Take last 3 timeline entries
                        final entries = _timelineController.timelineEntries.take(3).toList();
                        if (entries.isEmpty) {
                          return const Center(child: CircularProgressIndicator());
                        }

                        return ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: entries.length,
                          itemBuilder: (context, idx) {
                            final entry = entries[idx];
                            return _buildTimelineEntryRow(entry);
                          },
                        );
                      }),
                    ),
                    Center(
                      child: SizedBox(
                        height: 80.0, // Minimum touch target height: 80px
                        child: TextButton(
                          onPressed: () => Get.toNamed(Routes.coordination),
                          child: Text(
                            AppStrings.viewFullTimeline,
                            style: AppTextStyles.buttonLabel.copyWith(
                              color: AppColors.primaryRed,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // BOTTOM: Mark Resolved Button
              SizedBox(
                height: 80.0, // Minimum touch target height: 80px
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.criticalRed,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        backgroundColor: AppColors.surface,
                        title: Text(
                          AppStrings.markResolvedDialogTitle,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        content: Text(
                          AppStrings.markResolvedDialogContent,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        actions: [
                          SizedBox(
                            height: 80.0, // Touch target height: 80px
                            child: TextButton(
                              onPressed: () => Get.back(),
                              child: Text(
                                AppStrings.cancelBtn,
                                style: AppTextStyles.buttonLabel.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 80.0, // Touch target height: 80px
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.criticalRed,
                              ),
                              onPressed: () {
                                Get.back();
                                _incidentController.resolveIncident();
                                Get.offAllNamed(Routes.resolution);
                              },
                              child: Text(
                                AppStrings.resolveBtn,
                                style: AppTextStyles.buttonLabel.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    AppStrings.markResolvedBtn,
                    style: AppTextStyles.buttonLabel.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTimelineEntryRow(TimelineEntryModel entry) {
    final entryColor = _getEntryColor(entry.type);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timestamp
          Text(
            _formatTime(entry.timestamp),
            style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 8.0),

          // Vertical timeline line segment
          Container(
            width: 2.0,
            height: 24.0,
            // ignore: deprecated_member_use
            color: entryColor.withOpacity(0.5),
          ),
          const SizedBox(width: 8.0),

          // Message Text
          Expanded(
            child: Text(
              entry.message,
              style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
                color: entryColor,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
