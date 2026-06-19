import 'dart:async';

import 'package:flutter/foundation.dart';

import '../audio/sound_manager.dart';
import '../data/quiz_questions.dart';
import '../data/quiz_repository.dart';
import '../data/remote_progress_service.dart';
import '../models/app_user.dart';
import '../models/question.dart';
import '../models/stage_progress.dart';
import 'scoring.dart';

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
/// answer timers, scoring, progress persistence) plus per-user identity and
/// two-way Google Sheets sync.
class QuizController extends ChangeNotifier {
  QuizController({
    required this.repository,
    required this.soundManager,
    required this.remote,
  });

  final QuizRepository repository;
  final SoundManager soundManager;
  final RemoteProgressService remote;

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  String get _userId => _currentUser?.id ?? '';

  bool _isSyncing = false;
  bool get isSyncing => _isSyncing;

  /// Set by the auth gate; performs the actual Clerk sign-out.
  Future<void> Function()? signOutHandler;

  Future<void> requestSignOut() async {
    soundManager.playSound(SfxType.click);
    await signOutHandler?.call();
  }

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

  /// Start background music. Progress is loaded per-user via [onUserSignedIn].
  void start() {
    soundManager.startBgmLoop();
  }

  /// Called once when a user signs in (or changes). Seeds local data, pulls the
  /// user's cloud progress and merges it, then pushes a fresh summary row.
  Future<void> onUserSignedIn(AppUser user) async {
    if (_currentUser?.id == user.id) return;
    _currentUser = user;
    _currentScreen = const SplashScreenState();
    _isSyncing = true;
    notifyListeners();

    try {
      await repository.initializeDefaultDataIfEmpty(user.id);
      if (remote.isEnabled) {
        final remoteProgress = await remote.pullUserProgress(user.id);
        if (remoteProgress.isNotEmpty) {
          await repository.mergeRemoteProgress(user.id, remoteProgress);
        }
      }
    } catch (e) {
      debugPrint('Cloud sync on sign-in failed: $e');
    }

    await _refreshProgress();
    if (remote.isEnabled) {
      unawaited(_pushUserSummary());
    }
    _isSyncing = false;
    notifyListeners();
  }

  void onSignedOut() {
    _cancelTimers();
    _currentUser = null;
    _progressList = const [];
    _currentScreen = const SplashScreenState();
    notifyListeners();
  }

  Future<void> _refreshProgress() async {
    if (_currentUser == null) return;
    _progressList = await repository.getAllProgress(_userId);
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
    final elapsed = _answerTimeElapsedMs;

    if (isCorrect) {
      final stars = elapsed < 3000
          ? 3
          : elapsed < 7000
              ? 2
              : 1;
      soundManager.playSound(SfxType.correct);
      if (_currentUser != null) {
        await repository.saveProgress(_userId, q.levelId, q.stageId, stars, elapsed);
        await _refreshProgress();
      }
      _pushRemote(q, stars, elapsed, true);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      navigateTo(SummaryState(
        levelId: q.levelId,
        stageId: q.stageId,
        isSuccess: true,
        stars: stars,
        timeSpentMs: elapsed,
      ));
    } else {
      soundManager.playSound(SfxType.incorrect);
      _pushRemote(q, 0, elapsed, false);
      await Future<void>.delayed(const Duration(milliseconds: 350));
      navigateTo(SummaryState(
        levelId: q.levelId,
        stageId: q.stageId,
        isSuccess: false,
        stars: 0,
        timeSpentMs: elapsed,
      ));
    }
  }

  /// Fire-and-forget push of a completion event + refreshed user summary.
  void _pushRemote(Question q, int stars, int timeMs, bool isSuccess) {
    if (!remote.isEnabled) return;
    final user = _currentUser;
    if (user == null) return;
    final score = Scoring.total(isSuccess, stars, timeMs);
    unawaited(() async {
      try {
        await remote.appendProgressLog(
          userId: user.id,
          email: user.email,
          name: user.name,
          levelId: q.levelId,
          stageId: q.stageId,
          stars: stars,
          timeSpentMs: timeMs,
          score: score,
          isSuccess: isSuccess,
        );
        await _pushUserSummary();
      } catch (e) {
        debugPrint('Remote progress push failed: $e');
      }
    }());
  }

  Future<void> _pushUserSummary() async {
    final user = _currentUser;
    if (user == null) return;
    final totalStars = _progressList.fold<int>(0, (s, p) => s + p.starsCount);
    final solved = _progressList.where((p) => p.isCompleted).length;
    try {
      await remote.upsertUserSummary(
        userId: user.id,
        email: user.email,
        name: user.name,
        totalStars: totalStars,
        solvedStages: solved,
      );
    } catch (e) {
      debugPrint('User summary upsert failed: $e');
    }
  }

  Future<void> resetGame() async {
    soundManager.playSound(SfxType.click);
    if (_currentUser == null) return;
    await repository.resetAllProgress(_userId);
    await _refreshProgress();
    if (remote.isEnabled) unawaited(_pushUserSummary());
  }

  Future<void> unlockAll() async {
    soundManager.playSound(SfxType.click);
    if (_currentUser == null) return;
    await repository.unlockAllProgress(_userId);
    await _refreshProgress();
    if (remote.isEnabled) unawaited(_pushUserSummary());
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
