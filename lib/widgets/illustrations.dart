import 'package:flutter/material.dart';

import '../models/question.dart';

// =====================================================================
// Widget-based illustrations (ported from QuizIllustration.kt composables)
// =====================================================================

/// 1. Emoji row.
class EmojiRowIllustration extends StatelessWidget {
  const EmojiRowIllustration({super.key, required this.emojis});
  final List<String> emojis;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final emoji in emojis) ...[
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF2D2A54),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFF423F73)),
              ),
              alignment: Alignment.center,
              child: Text(emoji, style: const TextStyle(fontSize: 32)),
            ),
            const SizedBox(width: 16),
          ],
        ],
      ),
    );
  }
}

/// 2. Geometric numbered cards.
class GeometricNumbersIllustration extends StatelessWidget {
  const GeometricNumbersIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    const data = [
      ('1', Color(0xFF8E44AD), '🌀'),
      ('2', Color(0xFF2980B9), '▲'),
      ('3', Color(0xFF27AE60), '🌑'),
      ('4', Color(0xFFD35400), '⛰'),
    ];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (num, color, icon) in data) ...[
            Container(
              width: 44,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: color, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Text(num,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  Text(icon, style: TextStyle(fontSize: 20, color: color)),
                ],
              ),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

/// 3. Simulated playlist album cards.
class PlaylistCardsIllustration extends StatelessWidget {
  const PlaylistCardsIllustration({super.key, required this.songs});
  final List<String> songs;

  @override
  Widget build(BuildContext context) {
    const colors = [
      Color(0xFF2C3E50),
      Color(0xFF16A085),
      Color(0xFF8E44AD),
      Color(0xFFE74C3C),
    ];
    const singers = ['P. Teduh', 'Tulus', 'Maliq', 'R. Febian'];

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var idx = 0; idx < songs.length; idx++) ...[
            Container(
              width: 68,
              height: 110,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: colors[idx % colors.length],
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                    alignment: Alignment.center,
                    child: Container(
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    ),
                  ),
                  Column(
                    children: [
                      Text(
                        songs[idx],
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: Colors.white, height: 1.1),
                      ),
                      Text(
                        singers[idx % singers.length],
                        maxLines: 1,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 7, color: Colors.white.withValues(alpha: 0.6)),
                      ),
                    ],
                  ),
                  const Text('▶', style: TextStyle(fontSize: 8, color: Colors.white)),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

/// 4. Social branding icons.
class SocialIconsIllustration extends StatelessWidget {
  const SocialIconsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Instagram
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: const RadialGradient(
                colors: [Color(0xFFFEC564), Color(0xFFFD5C63), Color(0xFFA12C99)],
              ),
            ),
            alignment: Alignment.center,
            child: const Text('📸', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          // Tiktok
          Container(
            width: 45,
            height: 45,
            decoration: BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF00F2FE), width: 1.5),
            ),
            alignment: Alignment.center,
            child: const Text('🎵', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          // WhatsApp
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(color: Color(0xFF25D366), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text('💬', style: TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 14),
          // Facebook
          Container(
            width: 45,
            height: 45,
            decoration: const BoxDecoration(color: Color(0xFF1877F2), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: const Text('f',
                style: TextStyle(fontSize: 26, color: Colors.white, fontWeight: FontWeight.w800)),
          ),
        ],
      ),
    );
  }
}

/// 5. Traffic lights (red, yellow, green active in sequence).
class TrafficLightsIllustration extends StatelessWidget {
  const TrafficLightsIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    Widget bulb(Color color, bool active) => Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: active ? color : color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
        );

    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < 3; i++) ...[
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 22,
                  height: 60,
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF34495E),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: const Color(0xFF2C3E50), width: 1.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bulb(Colors.red, i == 0),
                      bulb(Colors.yellow, i == 1),
                      bulb(Colors.green, i == 2),
                    ],
                  ),
                ),
                Container(width: 4, height: 20, color: const Color(0xFF7F8C8D)),
              ],
            ),
            if (i < 2) const SizedBox(width: 28),
          ],
        ],
      ),
    );
  }
}

/// 6. Whiteboard with red chalk letters (M top, K bottom-left, P bottom-right).
class WhiteboardLettersIllustration extends StatelessWidget {
  const WhiteboardLettersIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    const letterStyle = TextStyle(
      fontSize: 26,
      fontWeight: FontWeight.bold,
      color: Color(0xFFE74C3C),
    );
    return FractionallySizedBox(
      widthFactor: 0.85,
      child: Container(
        height: 110,
        decoration: BoxDecoration(
          color: const Color(0xFF1E3F20),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF8E6E53), width: 6),
        ),
        child: Stack(
          children: const [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(padding: EdgeInsets.only(top: 10), child: Text('M', style: letterStyle)),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(padding: EdgeInsets.only(left: 24, bottom: 12), child: Text('K', style: letterStyle)),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(padding: EdgeInsets.only(right: 24, bottom: 12), child: Text('P', style: letterStyle)),
            ),
          ],
        ),
      ),
    );
  }
}

/// 8. Post-it memo notes (even numbers get a white border).
class PostItNotesIllustration extends StatelessWidget {
  const PostItNotesIllustration({super.key, required this.numbers});
  final List<String> numbers;

  @override
  Widget build(BuildContext context) {
    const backgrounds = [
      Color(0xFF3498DB),
      Color(0xFFE91E63),
      Color(0xFFF1C40F),
      Color(0xFFE67E22),
      Color(0xFF9E7E63),
      Color(0xFF2ECC71),
    ];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < numbers.length; i++) ...[
            Builder(builder: (_) {
              final num = numbers[i];
              final parsed = int.tryParse(num);
              final isEven = parsed != null && parsed % 2 == 0;
              return Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: backgrounds[i % backgrounds.length],
                  borderRadius: BorderRadius.circular(4),
                  border: isEven ? Border.all(color: Colors.white, width: 2) : null,
                ),
                alignment: Alignment.center,
                child: Text(num,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
              );
            }),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

/// 9. Letter bubbles.
class LetterBubblesIllustration extends StatelessWidget {
  const LetterBubblesIllustration({super.key, required this.letters});
  final List<String> letters;

  @override
  Widget build(BuildContext context) {
    const bubbleColors = [
      Color(0xFF1ABC9C),
      Color(0xFF9B59B6),
      Color(0xFF34495E),
      Color(0xFFE67E22),
      Color(0xFFF1C40F),
    ];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < letters.length; i++) ...[
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: bubbleColors[i % bubbleColors.length],
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white.withValues(alpha: 0.5)),
              ),
              alignment: Alignment.center,
              child: Text(letters[i],
                  style: const TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: Colors.white)),
            ),
            const SizedBox(width: 10),
          ],
        ],
      ),
    );
  }
}

