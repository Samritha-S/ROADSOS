// lib/presentation/screens/triage/triage_screen.dart
// ROADSoS - Triage Screen

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../app/routes.dart';
import '../../controllers/triage_controller.dart';

class TriageScreen extends StatefulWidget {
  const TriageScreen({super.key});

  @override
  State<TriageScreen> createState() => _TriageScreenState();
}

class _TriageScreenState extends State<TriageScreen> {
  final _triageController = Get.find<TriageController>();
  late Worker _speakWorker;
  late Worker _completeWorker;

  @override
  void initState() {
    super.initState();
    _triageController.resetTriage();

    // Speak initial question
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _triageController.speakQuestion(_triageController.currentQuestion.voicePrompt);
    });

    // Speak when question index changes
    _speakWorker = ever(_triageController.currentQuestionIndex, (index) {
      if (index >= 0 && index < 3) {
        _triageController.speakQuestion(_triageController.currentQuestion.voicePrompt);
      }
    });

    // Handle triage complete
    _completeWorker = ever(_triageController.isTriageComplete, (complete) {
      if (complete) {
        Get.toNamed(Routes.dispatch);
      }
    });
  }

  @override
  void dispose() {
    _speakWorker.dispose();
    _completeWorker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            Obx(() {
              if (_triageController.isTriageComplete.value) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  Get.toNamed(Routes.dispatch);
                });
              }
              return const SizedBox.shrink();
            }),
            Obx(() {
              final index = _triageController.currentQuestionIndex.value;
              final question = _triageController.currentQuestion;

          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(1.0, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              );
            },
            // Unique key per question index to trigger AnimatedSwitcher
            child: Container(
              key: ValueKey<int>(index),
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  // Top 20%: Dots Indicator
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(3, (dotIndex) {
                          final isActive = dotIndex == index;
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6.0),
                            width: 12.0,
                            height: 12.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isActive
                                  ? AppColors.primaryRed
                                  : AppColors.textSecondary, // Simple non-opacity color for safety
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  // Middle 40%: Question Text
                  Expanded(
                    flex: 4,
                    child: Center(
                      child: Text(
                        question.questionText,
                        style: AppTextStyles.headline,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),

                  // Bottom 40%: Answer Buttons
                  Expanded(
                    flex: 4,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // YES button
                        SizedBox(
                          height: 80.0, // Minimum touch target height: 80px
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.confirmedGreen,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            onPressed: () => _triageController.answerYes(index),
                            child: Text(
                              AppStrings.answerYes,
                              style: AppTextStyles.buttonLabel,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // NO button
                        SizedBox(
                          height: 80.0, // Minimum touch target height: 80px
                          width: double.infinity,
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
                            onPressed: () => _triageController.answerNo(index),
                            child: Text(
                              AppStrings.answerNo,
                              style: AppTextStyles.buttonLabel,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),

                        // NOT SURE button
                        SizedBox(
                          height: 80.0, // Touch target height: 80px
                          width: double.infinity,
                          child: Center(
                            child: TextButton(
                              style: TextButton.styleFrom(
                                minimumSize: const Size(double.infinity, 56.0), // Visual smaller height
                                backgroundColor: Colors.transparent,
                              ),
                              onPressed: () => _triageController.answerNotSure(index),
                              child: Text(
                                AppStrings.answerNotSure,
                                style: AppTextStyles.bodyLarge.copyWith( // Minimum 18sp
                                  color: AppColors.textSecondary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    ),
  ),
);
  }
}
