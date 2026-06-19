import '../models/stage_progress.dart';
import 'quiz_database.dart';

/// Data access layer for stage progress. Mirrors the original Kotlin
/// `QuizRepository` (seed / reset / save / unlock logic).
class QuizRepository {
  QuizRepository(this._db);

  final QuizDatabase _db;

  Future<List<StageProgress>> getAllProgress() => _db.getAllProgress();

  Future<void> initializeDefaultDataIfEmpty() async {
    final current = await _db.getAllProgress();
    if (current.isEmpty) {
      await resetAllProgress();
    }
  }

  Future<void> resetAllProgress() async {
    await _db.clearProgress();
    // Prepopulate 3 levels, each with 10 stages.
    for (var lvl = 1; lvl <= 3; lvl++) {
      for (var stg = 1; stg <= 10; stg++) {
        // First stage of Level 1 is unlocked by default.
        final unlocked = lvl == 1 && stg == 1;
        await _db.insertProgress(StageProgress(
          levelId: lvl,
          stageId: stg,
          starsCount: 0,
          timeSpentMs: 0,
          isCompleted: false,
          isUnlocked: unlocked,
        ));
      }
    }
  }

  Future<void> unlockAllProgress() async {
    await _db.clearProgress();
    for (var lvl = 1; lvl <= 3; lvl++) {
      for (var stg = 1; stg <= 10; stg++) {
        await _db.insertProgress(StageProgress(
          levelId: lvl,
          stageId: stg,
          starsCount: 3,
          timeSpentMs: 1200,
          isCompleted: true,
          isUnlocked: true,
        ));
      }
    }
  }

  Future<void> saveProgress(
    int levelId,
    int stageId,
    int stars,
    int elapsedMs,
  ) async {
    final current = await _db.getProgressForStage(levelId, stageId);

    // Preserve best stars and fastest time.
    final newStars =
        current != null ? (current.starsCount > stars ? current.starsCount : stars) : stars;

    final int newTime;
    if (current != null) {
      newTime = current.timeSpentMs <= 0
          ? elapsedMs
          : (current.timeSpentMs < elapsedMs ? current.timeSpentMs : elapsedMs);
    } else {
      newTime = elapsedMs;
    }

    await _db.insertProgress(StageProgress(
      levelId: levelId,
      stageId: stageId,
      starsCount: newStars,
      timeSpentMs: newTime,
      isCompleted: true,
      isUnlocked: true,
    ));

    await _unlockNextStage(levelId, stageId);
  }

  Future<void> _unlockNextStage(int currentLvl, int currentStg) async {
    final int nextLvl;
    final int nextStg;

    if (currentStg < 10) {
      nextLvl = currentLvl;
      nextStg = currentStg + 1;
    } else if (currentLvl < 3) {
      nextLvl = currentLvl + 1;
      nextStg = 1;
    } else {
      return; // Already at last stage of last level.
    }

    final next = await _db.getProgressForStage(nextLvl, nextStg);
    await _db.insertProgress(StageProgress(
      levelId: nextLvl,
      stageId: nextStg,
      starsCount: next?.starsCount ?? 0,
      timeSpentMs: next?.timeSpentMs ?? 0,
      isCompleted: next?.isCompleted ?? false,
      isUnlocked: true,
    ));
  }
}
