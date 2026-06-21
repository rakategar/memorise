/// Visual illustration type for a quiz question.
enum GraphicType {
  imageAsset, // One or more image asset paths in graphicData
  letterBubbles, // Rounded text bubble rows (fallback for text-only questions)
}

/// A single quiz question. Mirrors the original Kotlin `Question` data class.
class Question {
  final String id;
  final int levelId;
  final int stageId;
  final String text;
  final List<String> options;
  final int correctAnswerIndex;
  final int observationTimeSecs; // 0 if no observation phase needed
  final String explanation;
  final GraphicType graphicType;
  final List<String> graphicData;

  const Question({
    required this.id,
    required this.levelId,
    required this.stageId,
    required this.text,
    required this.options,
    required this.correctAnswerIndex,
    required this.observationTimeSecs,
    required this.explanation,
    required this.graphicType,
    this.graphicData = const [],
  });
}
