import 'package:flutter/material.dart';

import '../models/question.dart';
import 'illustrations.dart';

/// Renders the visual for a question inside a presentation card, or a "recall
/// memory" placeholder when [isVisible] is false. Ports `QuizIllustration`.
class QuizIllustration extends StatelessWidget {
  const QuizIllustration({
    super.key,
    required this.question,
    required this.isVisible,
  });

  final Question question;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    if (!isVisible) {
      return Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFF7F2FA), Color(0xFFE8DEF8)],
          ),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xFF6750A4), width: 1.5),
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(16),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('🧠✨', style: TextStyle(fontSize: 50)),
            SizedBox(height: 8),
            Text(
              'RECALL MEMORY',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6750A4),
                letterSpacing: 2,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'Sebutkan jawabannya berdasarkan memori visualmu!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Color(0xFF49454F)),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1B3E),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE1E2EC), width: 1.5),
      ),
      padding: const EdgeInsets.all(12),
      alignment: Alignment.center,
      child: _buildGraphic(question),
    );
  }

  Widget _buildGraphic(Question q) {
    switch (q.graphicType) {
      case GraphicType.emojiRow:
        return EmojiRowIllustration(emojis: q.graphicData);
      case GraphicType.geometricNumbers:
        return const GeometricNumbersIllustration();
      case GraphicType.playlistCards:
        return PlaylistCardsIllustration(songs: q.graphicData);
      case GraphicType.socialIcons:
        return const SocialIconsIllustration();
      case GraphicType.trafficLights:
        return const TrafficLightsIllustration();
      case GraphicType.whiteboardLetters:
        return const WhiteboardLettersIllustration();
      case GraphicType.woodRoom:
        return const CanvasIllustration(type: GraphicType.woodRoom);
      case GraphicType.postItNotes:
        return PostItNotesIllustration(numbers: q.graphicData);
      case GraphicType.letterBubbles:
        return LetterBubblesIllustration(letters: q.graphicData);
      case GraphicType.spatialCampus:
        return const CanvasIllustration(type: GraphicType.spatialCampus);
      case GraphicType.spatialOffice:
        return CanvasIllustration(type: GraphicType.spatialOffice, elements: q.graphicData);
      case GraphicType.spatialPark:
        return const CanvasIllustration(type: GraphicType.spatialPark);
      case GraphicType.spatialParking:
        return CanvasIllustration(type: GraphicType.spatialParking, elements: q.graphicData);
      case GraphicType.spatialClassroom:
        return const CanvasIllustration(type: GraphicType.spatialClassroom);
      case GraphicType.spatialLibrary:
        return const CanvasIllustration(type: GraphicType.spatialLibrary);
      case GraphicType.spatialDiner:
        return const CanvasIllustration(type: GraphicType.spatialDiner);
    }
  }
}
