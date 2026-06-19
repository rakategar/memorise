/// Visual illustration type for a quiz question.
/// Mirrors the original Kotlin `GraphicType` enum 1:1.
enum GraphicType {
  emojiRow, // Renders emoji row (Level 1 Q1, Q3, Q4, Q7, Q8, Q10)
  geometricNumbers, // Geometric numbers cards (Level 1 Q2)
  playlistCards, // Simulated playlist album arts (Level 1 Q5)
  socialIcons, // Social media brand icons (Level 1 Q6)
  trafficLights, // Natively drawn traffic light structures (Level 1 Q9)
  whiteboardLetters, // Red letter chalkboard memory (Level 2 Q1)
  woodRoom, // Classroom wooden elements (Level 2 Q2)
  postItNotes, // Even numbers paper squares (Level 2 Q3)
  letterBubbles, // Rounded text bubble rows (Level 2 Q4-Q10)
  spatialCampus, // Campus layout (Level 3 Q1)
  spatialOffice, // Laptop office workspace (Level 3 Q2, Q3, Q8)
  spatialPark, // Landscape park garden (Level 3 Q4)
  spatialParking, // Parking spots with vehicles (Level 3 Q5, Q10)
  spatialClassroom, // Classroom whiteboard/door (Level 3 Q6)
  spatialLibrary, // Library bookshelves and lamps (Level 3 Q7)
  spatialDiner, // Cafe/diner kitchen cashier placement (Level 3 Q9)
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
