import '../models/stage_progress.dart';
import 'quiz_database.dart';

/// Data access layer for stage progress (per user). Mirrors the original Kotlin
/// `QuizRepository`, extended with userId scoping + remote-merge for cloud sync.
class QuizRepository {
  QuizRepository(this._db);

  final QuizDatabase _db;

  Future<List<StageProgress>> getAllProgress(String userId) => _db.getAllProgress(userId);

  Future<void> initializeDefaultDataIfEmpty(String userId) async {
    final current = await _db.getAllProgress(userId);
    if (current.isEmpty) {
      await resetAllProgress(userId);
    }
  }

  Future<void> resetAllProgress(String userId) async {
    await _db.clearProgress(userId);
    for (var lvl = 1; lvl <= 3; lvl++) {
      for (var stg = 1; stg <= 10; stg++) {
        final unlocked = lvl == 1 && stg == 1;
        await _db.insertProgress(StageProgress(
          userId: userId,
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

  Future<void> unlockAllProgress(String userId) async {
    await _db.clearProgress(userId);
    for (var lvl = 1; lvl <= 3; lvl++) {
      for (var stg = 1; stg <= 10; stg++) {
        await _db.insertProgress(StageProgress(
          userId: userId,
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
    String userId,
    int levelId,
    int stageId,
    int stars,
    int elapsedMs,
  ) async {
    final current = await _db.getProgressForStage(userId, levelId, stageId);

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
      userId: userId,
      levelId: levelId,
      stageId: stageId,
      starsCount: newStars,
      timeSpentMs: newTime,
      isCompleted: true,
      isUnlocked: true,
    ));

    await _unlockNextStage(userId, levelId, stageId);
  }

  Future<void> _unlockNextStage(String userId, int currentLvl, int currentStg) async {
    final int nextLvl;
    final int nextStg;
    if (currentStg < 10) {
      nextLvl = currentLvl;
      nextStg = currentStg + 1;
    } else if (currentLvl < 3) {
      nextLvl = currentLvl + 1;
      nextStg = 1;
    } else {
      return;
    }

    final next = await _db.getProgressForStage(userId, nextLvl, nextStg);
    await _db.insertProgress(StageProgress(
      userId: userId,
      levelId: nextLvl,
      stageId: nextStg,
      starsCount: next?.starsCount ?? 0,
      timeSpentMs: next?.timeSpentMs ?? 0,
      isCompleted: next?.isCompleted ?? false,
      isUnlocked: true,
    ));
  }

  /// Merge cloud progress into local: take best stars (max) and best time (min)
  /// per stage, mark completed, then recompute unlocks. Used on login (cloud
  /// save). Ensures defaults exist first.
  Future<void> mergeRemoteProgress(String userId, List<StageProgress> remote) async {
    await initializeDefaultDataIfEmpty(userId);

    for (final r in remote) {
      final local = await _db.getProgressForStage(userId, r.levelId, r.stageId);
      final bestStars = local == null ? r.starsCount : (local.starsCount > r.starsCount ? local.starsCount : r.starsCount);
      final int bestTime;
      if (local == null || local.timeSpentMs <= 0) {
        bestTime = r.timeSpentMs;
      } else if (r.timeSpentMs <= 0) {
        bestTime = local.timeSpentMs;
      } else {
        bestTime = local.timeSpentMs < r.timeSpentMs ? local.timeSpentMs : r.timeSpentMs;
      }
      await _db.insertProgress(StageProgress(
        userId: userId,
        levelId: r.levelId,
        stageId: r.stageId,
        starsCount: bestStars,
        timeSpentMs: bestTime,
        isCompleted: (local?.isCompleted ?? false) || r.isCompleted,
        isUnlocked: true,
      ));
    }

    await _recomputeUnlocks(userId);
  }

  /// Recompute which stages are unlocked from completion state:
  /// L1S1 always; a stage unlocks if the previous stage is completed; the first
  /// stage of a level unlocks if the last stage of the previous level is completed.
  Future<void> _recomputeUnlocks(String userId) async {
    final all = await _db.getAllProgress(userId);
    final byKey = {for (final p in all) '${p.levelId}_${p.stageId}': p};

    bool completed(int lvl, int stg) => byKey['${lvl}_$stg']?.isCompleted ?? false;

    for (var lvl = 1; lvl <= 3; lvl++) {
      for (var stg = 1; stg <= 10; stg++) {
        final current = byKey['${lvl}_$stg'];
        if (current == null) continue;
        final bool unlocked;
        if (lvl == 1 && stg == 1) {
          unlocked = true;
        } else if (stg > 1) {
          unlocked = completed(lvl, stg - 1);
        } else {
          unlocked = completed(lvl - 1, 10);
        }
        if (unlocked && !current.isUnlocked) {
          await _db.insertProgress(current.copyWith(isUnlocked: true));
        }
      }
    }
  }
}
