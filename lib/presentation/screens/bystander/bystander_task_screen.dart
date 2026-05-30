// lib/presentation/screens/bystander/bystander_task_screen.dart
// ROADSoS - Bystander Task Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app/routes.dart';
import '../../controllers/bystander_controller.dart';

class BystanderTaskScreen extends StatelessWidget {
  const BystanderTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bystanderController = Get.find<BystanderController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Get.back(),
        ),
        title: Text(
          AppStrings.bystanderHeader,
          style: AppTextStyles.subheadline.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // TOP INFO CARD
              Container(
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.bystanderActiveMsg,
                      style: AppTextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Obx(() {
                      final code = bystanderController.incidentCode.value;
                      if (code.isNotEmpty) {
                        return Text(
                          code,
                          style: AppTextStyles.incidentCode.copyWith(
                            color: AppColors.primaryRed,
                            fontSize: 28.0,
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Title
              Text(
                AppStrings.selectYourRole,
                style: AppTextStyles.subheadline.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16.0),

              // TASK LIST
              Expanded(
                child: Obx(() {
                  final tasks = bystanderController.availableTasks;
                  final selected = bystanderController.selectedTask.value;

                  return ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12.0),
                    itemBuilder: (context, idx) {
                      final task = tasks[idx];
                      final isSelected = selected == task;

                      return InkWell(
                        onTap: () => bystanderController.selectTask(task),
                        borderRadius: BorderRadius.circular(8.0),
                        child: Container(
                          height: 80.0, // Touch target height: 80px (satisfying Rule 4)
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          decoration: BoxDecoration(
                            color: isSelected 
                                ? AppColors.confirmedGreen.withValues(alpha: 0.2) 
                                : AppColors.surface,
                            border: Border.all(
                              color: isSelected ? AppColors.confirmedGreen : AppColors.textSecondary,
                              width: isSelected ? 2.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Row(
                            children: [
                              // Radio-style indicator
                              Icon(
                                isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                color: isSelected ? AppColors.confirmedGreen : AppColors.textSecondary,
                                size: 24.0,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Text(
                                  task,
                                  style: AppTextStyles.bodyLarge.copyWith( // Rule 5: min 18sp
                                    color: AppColors.textPrimary,
                                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              const SizedBox(height: 16.0),

              // CONFIRM BUTTON
              Obx(() {
                final selected = bystanderController.selectedTask.value;
                final isEnabled = selected.isNotEmpty;

                return SizedBox(
                  height: 80.0, // Touch target height: 80px
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEnabled ? AppColors.confirmedGreen : AppColors.surface,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                    onPressed: isEnabled
                        ? () {
                            bystanderController.confirmTask();
                            Get.snackbar(
                              AppStrings.appName,
                              '${AppStrings.roleConfirmedPrefix} $selected',
                              backgroundColor: AppColors.surface,
                              colorText: AppColors.textPrimary,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            Get.toNamed(Routes.coordination);
                          }
                        : null,
                    child: Text(
                      AppStrings.confirmRoleBtn,
                      style: AppTextStyles.buttonLabel.copyWith(
                        color: isEnabled 
                            ? AppColors.textPrimary 
                            : AppColors.textSecondary.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
