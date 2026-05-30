// lib/domain/triage/triage_questions.dart
// ROADSoS - Triage Questions Model and Bank

import '../../core/constants/app_strings.dart';

class TriageQuestion {
  final String id;
  final String questionText;
  final String yesLabel;
  final String noLabel;
  final String notSureLabel;
  final String voicePrompt;

  const TriageQuestion({
    required this.id,
    required this.questionText,
    this.yesLabel = 'YES',
    this.noLabel = 'NO',
    this.notSureLabel = 'NOT SURE',
    required this.voicePrompt,
  });
}

class TriageQuestions {
  TriageQuestions._();

  static final List<TriageQuestion> questions = [
    TriageQuestion(
      id: 'q1',
      questionText: AppStrings.triageQ1,
      voicePrompt: AppStrings.triageQ1,
    ),
    TriageQuestion(
      id: 'q2',
      questionText: AppStrings.triageQ2,
      voicePrompt: AppStrings.triageQ2,
    ),
    TriageQuestion(
      id: 'q3',
      questionText: AppStrings.triageQ3,
      voicePrompt: AppStrings.triageQ3,
    ),
  ];
}
