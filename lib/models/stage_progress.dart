/// Persisted progress for one stage, scoped to a signed-in user.
/// Composite primary key: (userId, levelId, stageId).
class StageProgress {
  final String userId;
  final int levelId;
  final int stageId;
  final int starsCount;
  final int timeSpentMs;
  final bool isCompleted;
  final bool isUnlocked;

  const StageProgress({
    required this.userId,
    required this.levelId,
    required this.stageId,
    required this.starsCount,
    required this.timeSpentMs,
    required this.isCompleted,
    required this.isUnlocked,
  });

  StageProgress copyWith({
    int? starsCount,
    int? timeSpentMs,
    bool? isCompleted,
    bool? isUnlocked,
  }) =>
      StageProgress(
        userId: userId,
        levelId: levelId,
        stageId: stageId,
        starsCount: starsCount ?? this.starsCount,
        timeSpentMs: timeSpentMs ?? this.timeSpentMs,
        isCompleted: isCompleted ?? this.isCompleted,
        isUnlocked: isUnlocked ?? this.isUnlocked,
      );

  Map<String, Object?> toMap() => {
        'userId': userId,
        'levelId': levelId,
        'stageId': stageId,
        'starsCount': starsCount,
        'timeSpentMs': timeSpentMs,
        'isCompleted': isCompleted ? 1 : 0,
        'isUnlocked': isUnlocked ? 1 : 0,
      };

  factory StageProgress.fromMap(Map<String, Object?> map) => StageProgress(
        userId: (map['userId'] as String?) ?? '',
        levelId: map['levelId'] as int,
        stageId: map['stageId'] as int,
        starsCount: map['starsCount'] as int,
        timeSpentMs: (map['timeSpentMs'] as num).toInt(),
        isCompleted: (map['isCompleted'] as int) == 1,
        isUnlocked: (map['isUnlocked'] as int) == 1,
      );
}
