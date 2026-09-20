import 'dart:async';
import 'package:get/get.dart';
import '../data/data_service.dart';
import '../models/question.dart';
import '../screens/result_screen.dart';

class ExamQuestion {
  final Question question;
  int? selectedAnswer;
  ExamQuestion(this.question);
}

class ExamController extends GetxController {
  final _dataService = DataService();

  final examQuestions = <ExamQuestion>[].obs;
  final currentIndex = 0.obs;
  final isLoading = true.obs;
  final timeLeft = (45 * 60).obs;
  final isFinished = false.obs;
  final priorityFailed = false.obs;
  final priorityFailedIndex = (-1).obs; // which question caused the fail

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _buildExam();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> _buildExam() async {
    isLoading.value = true;

    final all = await _dataService.loadAll();
    final generalQ = List<Question>.from(all['general']!);
    final signQ = List<Question>.from(all['sign']!);
    final priorityQ = List<Question>.from(all['priority']!);
    final techniqueQ = List<Question>.from(all['technique']!);
    final emergencyQ = List<Question>.from(all['emergency']!);

    generalQ.shuffle();
    signQ.shuffle();
    priorityQ.shuffle();
    techniqueQ.shuffle();
    emergencyQ.shuffle();

    final List<Question> exam = [];

    final first15General = generalQ.take(15).toList();
    exam.addAll(first15General);
    exam.addAll(signQ.take(10));
    exam.addAll(priorityQ.take(5));

    final usedGeneralIds = first15General.map((q) => q.id).toSet();
    final remaining = generalQ.where((q) => !usedGeneralIds.contains(q.id)).take(5).toList();
    exam.addAll(remaining);
    exam.addAll(techniqueQ.take(5));
    exam.addAll(emergencyQ.take(5));

    examQuestions.value = exam.map((q) => ExamQuestion(q)).toList();
    isLoading.value = false;
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (timeLeft.value > 0) {
        timeLeft.value--;
      } else {
        _timer?.cancel();
        _finishExam(timeout: true);
      }
    });
  }

  ExamQuestion get current => examQuestions[currentIndex.value];
  bool get isLastQuestion => currentIndex.value == examQuestions.length - 1;
  bool get isFirstQuestion => currentIndex.value == 0;

  void selectAnswer(int answer) {
    current.selectedAnswer = answer;
    examQuestions.refresh();
  }

  void next() {
    final eq = current;
    final isPriority = eq.question.category == 'priority';
    final isWrong = eq.selectedAnswer != eq.question.answer;

    // ⚡ Priority wrong → stop exam immediately
    if (isPriority && isWrong) {
      priorityFailedIndex.value = currentIndex.value;
      _finishExam(priorityFail: true);
      return;
    }

    if (isLastQuestion) {
      _finishExam();
    } else {
      currentIndex.value++;
    }
  }

  void previous() {
    if (!isFirstQuestion) currentIndex.value--;
  }

  void _finishExam({bool timeout = false, bool priorityFail = false}) {
    _timer?.cancel();
    isFinished.value = true;

    int score = 0;
    // Only count answered questions up to current index (inclusive) if priority fail
    final countUpTo = priorityFail ? currentIndex.value + 1 : examQuestions.length;

    for (int i = 0; i < countUpTo; i++) {
      final eq = examQuestions[i];
      if (eq.selectedAnswer == eq.question.answer) score++;
    }

    priorityFailed.value = priorityFail;

    Get.off(() => ResultScreen(
      score: score,
      total: examQuestions.length,
      priorityFailed: priorityFail,
      priorityFailedIndex: priorityFailedIndex.value,
      timeout: timeout,
      examQuestions: examQuestions,
      answeredUpTo: countUpTo,
    ));
  }

  String get formattedTime {
    final m = timeLeft.value ~/ 60;
    final s = timeLeft.value % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  int get answeredCount => examQuestions.where((q) => q.selectedAnswer != null).length;
}
