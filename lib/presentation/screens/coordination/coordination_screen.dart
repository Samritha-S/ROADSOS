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
import '../../controllers/bystander_controller.dart';

class CoordinationScreen extends StatefulWidget {
  const CoordinationScreen({super.key});

  @override
  State<CoordinationScreen> createState() => _CoordinationScreenState();
}

class _CoordinationScreenState extends State<CoordinationScreen> {
  final _incidentController = Get.find<IncidentController>();
  final _timelineController = Get.find<TimelineController>();
  final _bystanderController = Get.find<BystanderController>();
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

  void _showBystanderBottomSheet() {
    _bystanderController.generateIncidentCode();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24.0),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppStrings.shareCodePrompt,
              style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            Obx(() {
              return Text(
                _bystanderController.incidentCode.value,
                style: AppTextStyles.incidentCode,
              );
            }),
            const SizedBox(height: 32.0),
            SizedBox(
              height: 80.0, // Minimum touch target height: 80px
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                ),
                onPressed: () => Get.back(),
                child: Text(
                  AppStrings.gaveCodeBtn,
                  style: AppTextStyles.buttonLabel,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.background,
        title: Text(
          AppStrings.incidentActiveHeader,
          style: AppTextStyles.subheadline.copyWith(
            color: AppColors.primaryRed,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, size: 28.0),
            onPressed: _showBystanderBottomSheet,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
          child: Column(
            children: [
              // Top Card: Calm Instructions
              Obx(() {
                final incident = _incidentController.currentIncident.value;
                final triageResult = incident?.triageResult;
                final instructions = triageResult != null
                    ? TriageEngine.getCalmInstructions(triageResult)
                    : 'Stay calm. Help is on the way.';

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    border: Border(
                      left: BorderSide(
                        color: AppColors.confirmedGreen,
                        width: 4.0,
                      ),
                    ),
                  ),
                  child: Text(
                    instructions,
                    style: AppTextStyles.bodyLarge.copyWith(
                      height: 1.5,
                    ),
                  ),
                );
              }),
              const SizedBox(height: 20.0),

              // Elapsed Time
              Obx(() {
                return Text(
                  '${AppStrings.timeSinceIncident} ${_timelineController.elapsedTimeDisplay.value}',
                  style: AppTextStyles.subheadline.copyWith(
                    color: AppColors.textSecondary,
                  ),
                );
              }),
              const SizedBox(height: 20.0),

              // Timeline list
              Expanded(
                child: Obx(() {
                  final entries = _timelineController.timelineEntries;
                  if (entries.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return ListView.builder(
                    itemCount: entries.length,
                    itemBuilder: (context, idx) {
                      final entry = entries[idx];
                      return _buildTimelineEntryRow(entry);
                    },
                  );
                }),
              ),
              const SizedBox(height: 16.0),

              // Bottom buttons
              Row(
                children: [
                  // Back to Services
                  Expanded(
                    child: SizedBox(
                      height: 80.0, // Minimum touch target height: 80px
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          backgroundColor: AppColors.surface,
                          side: const BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () => Get.toNamed(Routes.dispatch),
                        child: Text(
                          AppStrings.backToServicesBtn,
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  // Mark Resolved
                  Expanded(
                    child: SizedBox(
                      height: 80.0, // Minimum touch target height: 80px
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
                  ),
                ],
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
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Alignment
          Text(
            _formatTime(entry.timestamp),
            style: AppTextStyles.bodyLarge.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(width: 12.0),

          // Vertical timeline line segment
          Container(
            width: 2.0,
            height: 36.0,
            color: entryColor.withValues(alpha: 0.5),
          ),
          const SizedBox(width: 12.0),

          // Message Text
          Expanded(
            child: Text(
              entry.message,
              style: AppTextStyles.bodyLarge.copyWith(
                color: entryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
