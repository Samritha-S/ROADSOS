// lib/presentation/controllers/triage_controller.dart
// ROADSoS - Triage Controller

import 'package:get/get.dart';

import '../../domain/triage/triage_questions.dart';
import 'incident_controller.dart';

class TriageController extends GetxController {
  // Observable state
  final RxInt currentQuestionIndex = 0.obs;
  final RxList<bool?> answers = RxList<bool?>([null, null, null]);
  final RxList<bool> notSureAnswers = RxList<bool>([false, false, false]);
  final RxBool isTriageComplete = false.obs;
  final RxBool isSpeaking = false.obs;

  void answerYes(int questionIndex) {
    answers[questionIndex] = true;
    notSureAnswers[questionIndex] = false;
    _advanceOrComplete(questionIndex);
  }

  void answerNo(int questionIndex) {
    answers[questionIndex] = false;
    notSureAnswers[questionIndex] = false;
    _advanceOrComplete(questionIndex);
  }

  void answerNotSure(int questionIndex) {
    answers[questionIndex] = false;
    notSureAnswers[questionIndex] = true;
    _advanceOrComplete(questionIndex);
  }

  void _advanceOrComplete(int answeredIndex) {
    if (answeredIndex < 2) {
      currentQuestionIndex.value = answeredIndex + 1;
    } else {
      isTriageComplete.value = true;
      _completeTriage();
    }
  }

  Future<void> _completeTriage() async {
    await Get.find<IncidentController>().submitTriage(
      q1Answer: answers[0] == true,
      q2Answer: answers[1] == true,
      q3Answer: answers[2] == true,
      q1NotSure: notSureAnswers[0],
      q2NotSure: notSureAnswers[1],
      q3NotSure: notSureAnswers[2],
    );
  }

  Future<void> speakQuestion(String questionText) async {
    // TTS removed - voice feature disabled for Android compatibility
    // Future: re-add with compatible TTS package
    isSpeaking.value = false;
  }

  void resetTriage() {
    currentQuestionIndex.value = 0;
    answers.value = [null, null, null];
    notSureAnswers.value = [false, false, false];
    isTriageComplete.value = false;
    isSpeaking.value = false;
  }

  TriageQuestion get currentQuestion =>
      TriageQuestions.questions[currentQuestionIndex.value];
}
