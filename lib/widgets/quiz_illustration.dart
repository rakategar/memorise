import 'package:flutter/material.dart';

import '../models/question.dart';
import 'illustrations.dart';

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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE1E2EC), width: 1.5),
      ),
      padding: const EdgeInsets.all(8),
      alignment: Alignment.center,
      child: _buildGraphic(question),
    );
  }

  Widget _buildGraphic(Question q) {
    switch (q.graphicType) {
      case GraphicType.imageAsset:
        if (q.graphicData.length == 1) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.asset(
              q.graphicData.first,
              fit: BoxFit.contain,
            ),
          );
        }
        // Multiple images (e.g. L1Q5 playlist atas+bawah, L1Q9 lampu+pilihan)
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: q.graphicData
                .map((path) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 2),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(path, fit: BoxFit.contain),
                      ),
                    ))
                .toList(),
          ),
        );
      case GraphicType.letterBubbles:
        return LetterBubblesIllustration(letters: q.graphicData);
    }
  }
}
