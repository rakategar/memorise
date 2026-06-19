import 'dart:async';

import 'package:flutter/foundation.dart';

import '../audio/sound_manager.dart';
import '../data/quiz_questions.dart';
import '../data/quiz_repository.dart';
import '../models/question.dart';
import '../models/stage_progress.dart';

/// Navigation destinations. Mirrors the original sealed `Screen` interface.
sealed class AppScreen {
  const AppScreen();
}

class SplashScreenState extends AppScreen {
  const SplashScreenState();
}

class LevelSelectState extends AppScreen {
  const LevelSelectState();
}

class StageSelectState extends AppScreen {
  const StageSelectState(this.levelId);
  final int levelId;
}

class GameplayState extends AppScreen {
  const GameplayState(this.levelId, this.stageId);
  final int levelId;
  final int stageId;
}

class SummaryState extends AppScreen {
  const SummaryState({
    required this.levelId,
    required this.stageId,
    required this.isSuccess,
    required this.stars,
    required this.timeSpentMs,
  });
  final int levelId;
  final int stageId;
  final bool isSuccess;
  final int stars;
  final int timeSpentMs;
}

/// Central game state. Mirrors `QuizViewModel` (navigation, observation /
/// answer timers, scoring, progress persistence).
class QuizController extends ChangeNotifier {
  QuizController({required this.repository, required this.soundManager});

  final QuizRepository repository;
  final SoundManager soundManager;

  AppScreen _currentScreen = const SplashScreenState();
  AppScreen get currentScreen => _currentScreen;

  List<StageProgress> _progressList = const [];
  List<StageProgress> get progressList => _progressList;

  Question? _currentQuestion;
  Question? get currentQuestion => _currentQuestion;

  bool _isObservationPhase = false;
  bool get isObservationPhase => _isObservationPhase;

  int _observationTimer = 0;
  int get observationTimer => _observationTimer;

  bool _isAnswerPhase = false;
  bool get isAnswerPhase => _isAnswerPhase;

  int _answerTimeElapsedMs = 0;
  int get answerTimeElapsedMs => _answerTimeElapsedMs;

  int? _selectedOptionIndex;
  int? get selectedOptionIndex => _selectedOptionIndex;

  Timer? _observationTicker;
  Timer? _answerTicker;
  Stopwatch? _answerStopwatch;

  Future<void> init() async {
    await repository.initializeDefaultDataIfEmpty();
    await _refreshProgress();
    // Auto-run background music loop.
    soundManager.startBgmLoop();
  }

  Future<void> _refreshProgress() async {
    _progressList = await repository.getAllProgress();
    notifyListeners();
  }

  void navigateTo(AppScreen screen) {
    soundManager.playSound(SfxType.click);
    _currentScreen = screen;
    if (screen is GameplayState) {
      _setupGameplay(screen.levelId, screen.stageId);
    }
    notifyListeners();
  }

  void _setupGameplay(int levelId, int stageId) {
    _cancelTimers();
    final q = QuizQuestions.getQuestions()
        .where((it) => it.levelId == levelId && it.stageId == stageId)
        .cast<Question?>()
        .firstWhere((_) => true, orElse: () => null);
    _currentQuestion = q;
    _selectedOptionIndex = null;

    if (q != null) {
      if (q.observationTimeSecs > 0) {
        _isObservationPhase = true;
        _isAnswerPhase = false;
        _observationTimer = q.observationTimeSecs;
        _startObservationTimer();
      } else {
        _isObservationPhase = false;
        _isAnswerPhase = true;
        _startAnswerTiming();
      }
    }
  }

  void skipObservation() {
    soundManager.playSound(SfxType.click);
    _observationTicker?.cancel();
    _enterAnswerPhase();
  }

  void _startObservationTimer() {
    _observationTicker?.cancel();
    _observationTicker = Timer.periodic(const Duration(seconds: 1), (_) {
      _observationTimer -= 1;
      if (_observationTimer > 0 && _observationTimer <= 4) {
        soundManager.playSound(SfxType.tick);
      }
      if (_observationTimer <= 0) {
        _observationTicker?.cancel();
        _enterAnswerPhase();
      } else {
        notifyListeners();
      }
    });
  }

  void _enterAnswerPhase() {
    _isObservationPhase = false;
    _isAnswerPhase = true;
    _startAnswerTiming();
    notifyListeners();
  }

  void _startAnswerTiming() {
    _answerTicker?.cancel();
    _answerTimeElapsedMs = 0;
    _answerStopwatch = Stopwatch()..start();
    _answerTicker = Timer.periodic(const Duration(milliseconds: 30), (_) {
      if (!_isAnswerPhase) {
        _answerTicker?.cancel();
        return;
      }
      _answerTimeElapsedMs = _answerStopwatch!.elapsedMilliseconds;
      notifyListeners();
    });
  }

  Future<void> submitAnswer(int optionIndex) async {
    if (_selectedOptionIndex != null || _currentQuestion == null) return;
    _selectedOptionIndex = optionIndex;
    _isAnswerPhase = false;
    _answerTicker?.cancel();
    _answerStopwatch?.stop();
    notifyListeners();

    final q = _currentQuestion!;
    final isCorrect = optionIndex == q.correctAnswerIndex;

    if (isCorrect) {
      final stars = _answerTimeElapsedMs < 3000
          ? 3
          : _answerTimeElapsedMs < 7000
              ? 2
              : 1;
      soundManager.playSound(SfxType.correct);
      await repository.saveProgress(q.levelId, q.stageId, stars, _answerTimeElapsedMs);
      await _refreshProgress();
      await Future<void>.delayed(const Duration(milliseconds: 350));
      navigateTo(SummaryState(
        levelId: q.levelId,
        stageId: q.stageId,
        isSuccess: true,
        stars: stars,
        timeSpentMs: _answerTimeElapsedMs,
      ));
    } else {
      soundManager.playSound(SfxType.incorrect);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      navigateTo(SummaryState(
        levelId: q.levelId,
        stageId: q.stageId,
        isSuccess: false,
        stars: 0,
        timeSpentMs: _answerTimeElapsedMs,
      ));
    }
  }

  Future<void> resetGame() async {
    soundManager.playSound(SfxType.click);
    await repository.resetAllProgress();
    await _refreshProgress();
  }

  Future<void> unlockAll() async {
    soundManager.playSound(SfxType.click);
    await repository.unlockAllProgress();
    await _refreshProgress();
  }

  void toggleMusic() {
    soundManager.playSound(SfxType.click);
    soundManager.isMusicEnabled = !soundManager.isMusicEnabled;
    notifyListeners();
  }

  void toggleSound() {
    soundManager.isSoundEnabled = !soundManager.isSoundEnabled;
    soundManager.playSound(SfxType.click);
    notifyListeners();
  }

  void _cancelTimers() {
    _observationTicker?.cancel();
    _answerTicker?.cancel();
    _answerStopwatch?.stop();
  }

  @override
  void dispose() {
    _cancelTimers();
    soundManager.pauseMusic();
    super.dispose();
  }
}
