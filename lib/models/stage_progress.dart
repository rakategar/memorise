/// Persisted progress for one stage. Mirrors the original Room `StageProgress`
/// entity (composite primary key of levelId + stageId).
class StageProgress {
  final int levelId;
  final int stageId;
  final int starsCount;
  final int timeSpentMs;
  final bool isCompleted;
  final bool isUnlocked;

  const StageProgress({
    required this.levelId,
    required this.stageId,
    required this.starsCount,
    required this.timeSpentMs,
    required this.isCompleted,
    required this.isUnlocked,
  });

  Map<String, Object?> toMap() => {
        'levelId': levelId,
        'stageId': stageId,
        'starsCount': starsCount,
        'timeSpentMs': timeSpentMs,
        'isCompleted': isCompleted ? 1 : 0,
        'isUnlocked': isUnlocked ? 1 : 0,
      };

  factory StageProgress.fromMap(Map<String, Object?> map) => StageProgress(
        levelId: map['levelId'] as int,
        stageId: map['stageId'] as int,
        starsCount: map['starsCount'] as int,
        timeSpentMs: (map['timeSpentMs'] as num).toInt(),
        isCompleted: (map['isCompleted'] as int) == 1,
        isUnlocked: (map['isUnlocked'] as int) == 1,
      );
}
