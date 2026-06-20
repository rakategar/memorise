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

// =====================================================================
// Canvas-based illustrations (ported from QuizIllustration.kt Canvas blocks)
// =====================================================================

/// Wraps a [CustomPaint] sized to the original Compose dimensions for the
/// canvas-drawn spatial/scene illustrations.
class CanvasIllustration extends StatelessWidget {
  const CanvasIllustration({super.key, required this.type, this.elements = const []});

  final GraphicType type;
  final List<String> elements;

  double get _height => type == GraphicType.woodRoom ? 120 : 130;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: _height,
      child: CustomPaint(painter: _ScenePainter(type, elements)),
    );
  }
}

class _ScenePainter extends CustomPainter {
  _ScenePainter(this.type, this.elements);
  final GraphicType type;
  final List<String> elements;

  Paint _fill(Color c) => Paint()..color = c;
  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w;

  void _roundRect(Canvas c, double l, double t, double w, double h, double r, Color color) {
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(l, t, w, h), Radius.circular(r)), _fill(color));
  }

  @override
  void paint(Canvas canvas, Size size) {
    switch (type) {
      case GraphicType.woodRoom:
        _woodRoom(canvas, size);
      case GraphicType.spatialCampus:
        _spatialCampus(canvas, size);
      case GraphicType.spatialOffice:
        _spatialOffice(canvas, size);
      case GraphicType.spatialPark:
        _spatialPark(canvas, size);
      case GraphicType.spatialParking:
        _spatialParking(canvas, size);
      case GraphicType.spatialClassroom:
        _spatialClassroom(canvas, size);
      case GraphicType.spatialLibrary:
        _spatialLibrary(canvas, size);
      case GraphicType.spatialDiner:
        _spatialDiner(canvas, size);
      default:
        break;
    }
  }

  // 7. Wood elements classroom.
  void _woodRoom(Canvas canvas, Size size) {
    final wallY = size.height * 0.4;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, wallY), _fill(const Color(0xFF2C3E50)));
    canvas.drawRect(
        Rect.fromLTWH(0, wallY, size.width, size.height - wallY), _fill(const Color(0xFFBDC3C7)));

    const deskW = 120.0;
    const deskH = 65.0;
    final deskX = (size.width - deskW) / 2;
    final deskY = (size.height - deskH) - 10;

    _roundRect(canvas, deskX, deskY, deskW, 14, 4, const Color(0xFFD35400));
    final leg = _stroke(const Color(0xFF7F8C8D), 4);
    canvas.drawLine(Offset(deskX + 15, deskY + 12), Offset(deskX + 15, deskY + deskH), leg);
    canvas.drawLine(Offset(deskX + deskW - 15, deskY + 12), Offset(deskX + deskW - 15, deskY + deskH), leg);

    final chairX = deskX - 70;
    final chairY = deskY + 14;
    canvas.drawRect(Rect.fromLTWH(chairX, chairY - 26, 35, 6), _fill(const Color(0xFFE67E22)));
    final leg3 = _stroke(const Color(0xFF7F8C8D), 3);
    canvas.drawLine(Offset(chairX + 5, chairY - 20), Offset(chairX + 5, chairY + 25), leg3);
    canvas.drawLine(Offset(chairX + 30, chairY - 20), Offset(chairX + 30, chairY + 25), leg3);
    _roundRect(canvas, chairX - 2, chairY - 2, 40, 6, 0, const Color(0xFFD35400));
    canvas.drawLine(Offset(chairX + 5, chairY + 4), Offset(chairX + 5, chairY + 36), leg3);
    canvas.drawLine(Offset(chairX + 30, chairY + 4), Offset(chairX + 30, chairY + 36), leg3);
  }

  // 10. Spatial campus layout.
  void _spatialCampus(Canvas canvas, Size size) {
    const wallH = 65.0;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, wallH), _fill(const Color(0xFF7F8C8D)));
    for (var x = 20; x <= size.width.toInt(); x += 60) {
      _roundRect(canvas, x.toDouble(), 15, 35, 35, 4, Colors.white.withValues(alpha: 0.8));
    }

    const roadY = wallH;
    final roadH = size.height - wallH;
    canvas.drawRect(Rect.fromLTWH(0, roadY, size.width, roadH), _fill(const Color(0xFF2C3E50)));

    // Dashed yellow center line.
    final dash = _stroke(Colors.yellow, 3);
    final y = roadY + roadH / 2;
    for (var x = 0.0; x < size.width; x += 35) {
      canvas.drawLine(Offset(x, y), Offset((x + 20).clamp(0, size.width), y), dash);
    }

    // Silver car (left).
    const carX = 40.0;
    final carY = roadY + 12;
    _roundRect(canvas, carX, carY, 65, 25, 6, const Color(0xFFBDC3C7));
    canvas.drawRect(Rect.fromLTWH(carX + 12, carY + 3, 40, 19), _fill(const Color(0xFF34495E)));

    // Red scooter (middle).
    final scooterX = size.width / 2.2;
    final scooterY = roadY + 8;
    _roundRect(canvas, scooterX, scooterY + 6, 30, 15, 4, const Color(0xFFE74C3C));
    canvas.drawCircle(Offset(scooterX + 5, scooterY + 22), 5.5, _fill(Colors.black));
    canvas.drawCircle(Offset(scooterX + 25, scooterY + 22), 5.5, _fill(Colors.black));

    // Red bus (right).
    final busX = size.width - 130;
    final busY = roadY + 5;
    _roundRect(canvas, busX, busY, 100, 35, 5, const Color(0xFFC0392B));
    for (var bx = 0; bx <= 4; bx++) {
      canvas.drawRect(Rect.fromLTWH(busX + 6 + bx * 18, busY + 5, 12, 12), _fill(const Color(0xFFECF0F1)));
    }
  }

  // 11. Spatial office workstation.
  void _spatialOffice(Canvas canvas, Size size) {
    final deskY = size.height - 35;
    canvas.drawRect(Rect.fromLTWH(10, deskY, size.width - 20, 15), _fill(const Color(0xFF8E6E53)));
    canvas.drawRect(Rect.fromLTWH(20, deskY + 15, 20, 20), _fill(const Color(0xFF6E5642)));
    canvas.drawRect(Rect.fromLTWH(size.width - 40, deskY + 15, 20, 20), _fill(const Color(0xFF6E5642)));

    const lpW = 85.0;
    const lpH = 45.0;
    final lpX = (size.width - lpW) / 2;
    final lpY = deskY - lpH;
    _roundRect(canvas, lpX, lpY, lpW, lpH, 6, const Color(0xFF2C3E50));
    canvas.drawRect(Rect.fromLTWH(lpX + 4, lpY + 4, lpW - 8, lpH - 12), _fill(const Color(0xFF5DADE2)));
    canvas.drawRect(Rect.fromLTWH(lpX - 8, deskY - 3, lpW + 16, 5), _fill(const Color(0xFF95A5A6)));

    if (elements.contains('Botol_Kiri')) {
      final botX = lpX - 45;
      final botY = deskY - 35;
      _roundRect(canvas, botX, botY, 12, 35, 3, const Color(0xFF3498DB));
      canvas.drawRect(Rect.fromLTWH(botX + 2, botY - 4, 8, 4), _fill(Colors.white));
    }
    if (elements.contains('Buku_Kiri')) {
      final bookX = lpX - 60;
      final bookY = deskY - 14;
      _roundRect(canvas, bookX, bookY, 35, 14, 2, const Color(0xFF2980B9));
      canvas.drawLine(Offset(bookX + 5, bookY + 6), Offset(bookX + 30, bookY + 6), _stroke(Colors.white, 2.5));
    }
    if (elements.contains('Mouse_Kanan')) {
      final mX = lpX + lpW + 18;
      final mY = deskY - 8;
      _roundRect(canvas, mX, mY, 15, 8, 4, Colors.black);
    }
    if (elements.contains('Tanaman_Kanan') || elements.contains('Tanaman_KananJauh')) {
      final pX = elements.contains('Tanaman_KananJauh') ? size.width - 65 : lpX + lpW + 45;
      final pY = deskY - 24;
      _roundRect(canvas, pX, pY, 18, 24, 2, const Color(0xFFE67E22));
      canvas.drawCircle(Offset(pX + 9, pY - 6), 10, _fill(const Color(0xFF27AE60)));
      canvas.drawCircle(Offset(pX, pY - 3), 8, _fill(const Color(0xFF2ECC71)));
      canvas.drawCircle(Offset(pX + 18, pY - 3), 8, _fill(const Color(0xFF2ECC71)));
    }
  }

  // 12. Spatial park.
  void _spatialPark(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _fill(const Color(0xFF27AE60)));

    final treeCx = size.width / 2;
    final treeCy = size.height - 35;
    canvas.drawRect(Rect.fromLTWH(treeCx - 8, treeCy - 45, 16, 45), _fill(const Color(0xFF7E5109)));
    canvas.drawCircle(Offset(treeCx, treeCy - 55), 35, _fill(const Color(0xFF1E8449)));
    canvas.drawCircle(Offset(treeCx + 12, treeCy + 40), 35,
        _fill(const Color(0xFF2E4053).withValues(alpha: 0.15)));

    // Bench (left).
    final bX = treeCx - 110;
    final bY = size.height - 40;
    canvas.drawRect(Rect.fromLTWH(bX, bY, 50, 6), _fill(const Color(0xFFBA4A00)));
    canvas.drawRect(Rect.fromLTWH(bX, bY - 14, 50, 6), _fill(const Color(0xFFD35400)));
    final black3 = _stroke(Colors.black, 3);
    canvas.drawLine(Offset(bX + 5, bY), Offset(bX + 5, bY + 18), black3);
    canvas.drawLine(Offset(bX + 45, bY), Offset(bX + 45, bY + 18), black3);

    // Bicycle (right).
    final bkX = treeCx + 60;
    final bkY = size.height - 25;
    canvas.drawCircle(Offset(bkX, bkY), 11, _stroke(const Color(0xFFD3D3D3), 2.5));
    canvas.drawCircle(Offset(bkX + 38, bkY), 11, _stroke(const Color(0xFFD3D3D3), 2.5));
    canvas.drawCircle(Offset(bkX, bkY), 12, _stroke(Colors.black, 1.5));
    canvas.drawCircle(Offset(bkX + 38, bkY), 12, _stroke(Colors.black, 1.5));
    final red3 = _stroke(Colors.red, 3);
    canvas.drawLine(Offset(bkX, bkY), Offset(bkX + 18, bkY - 16), red3);
    canvas.drawLine(Offset(bkX + 38, bkY), Offset(bkX + 18, bkY - 16), red3);
    canvas.drawLine(Offset(bkX, bkY), Offset(bkX + 38, bkY), red3);
    canvas.drawLine(Offset(bkX + 38, bkY), Offset(bkX + 36, bkY - 22), _stroke(const Color(0xFF444444), 2.5));
    canvas.drawLine(Offset(bkX + 32, bkY - 22), Offset(bkX + 42, bkY - 22), _stroke(Colors.black, 3));
  }

  // 13. Parking spots.
  void _spatialParking(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _fill(const Color(0xFF34495E)));
    final whiteLine = _stroke(Colors.white, 3);
    for (final x in [20.0, size.width / 3, size.width * 2 / 3, size.width - 20]) {
      canvas.drawLine(Offset(x, 15), Offset(x, size.height - 15), whiteLine);
    }

    if (elements.contains('Mobil_Kiri')) {
      const mX = 40.0, mY = 30.0;
      _roundRect(canvas, mX, mY, 46, 70, 6, Colors.white);
      canvas.drawRect(Rect.fromLTWH(mX + 4, mY + 12, 38, 10), _fill(const Color(0xFF2C3E50)));
      canvas.drawRect(Rect.fromLTWH(mX + 4, mY + 44, 38, 14), _fill(const Color(0xFF2C3E50)));
    } else if (elements.contains('Motor_Kiri')) {
      const bX = 50.0, bY = 40.0;
      _roundRect(canvas, bX, bY, 20, 48, 4, Colors.black);
      canvas.drawCircle(const Offset(bX + 10, bY + 4), 3.5, _fill(Colors.yellow));
    }

    if (elements.contains('Motor_Tengah')) {
      final bX = size.width / 2.2;
      const bY = 42.0;
      _roundRect(canvas, bX, bY, 20, 45, 4, const Color(0xFFE74C3C));
    }

    if (elements.contains('Bus_Kanan')) {
      final busX = size.width - 95;
      const busY = 22.0;
      _roundRect(canvas, busX, busY, 65, 85, 6, const Color(0xFF2471A3));
      canvas.drawRect(Rect.fromLTWH(busX + 8, busY + 15, 49, 50), _fill(Colors.black));
    } else if (elements.contains('Mobil_Kanan')) {
      final mX = size.width - 85;
      const mY = 32.0;
      _roundRect(canvas, mX, mY, 42, 65, 6, const Color(0xFFBDC3C7));
    }

    if (elements.contains('Pohon_Belakang')) {
      canvas.drawRect(Rect.fromLTWH(0, 0, size.width, 14), _fill(const Color(0xFF196F3D)));
      for (var tx = 30; tx <= size.width.toInt(); tx += 50) {
        canvas.drawCircle(Offset(tx.toDouble(), 4), 12, _fill(const Color(0xFF27AE60)));
      }
    }
  }

  // 14. Classroom.
  void _spatialClassroom(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _fill(const Color(0xFFBDC3C7)));
    final fH = size.height * 0.35;
    canvas.drawRect(Rect.fromLTWH(0, size.height - fH, size.width, fH), _fill(const Color(0xFF7F8C8D)));

    const wbW = 145.0, wbH = 60.0, wbX = 50.0, wbY = 15.0;
    canvas.drawRect(Rect.fromLTWH(wbX, wbY, wbW, wbH), _fill(const Color(0xFF8E6E53)));
    canvas.drawRect(Rect.fromLTWH(wbX + 5, wbY + 5, wbW - 10, wbH - 10), _fill(Colors.white));

    canvas.drawRect(Rect.fromLTWH(10, size.height - 45, 35, 35), _fill(const Color(0xFFD35400)));

    const drW = 40.0, drH = 90.0, drY = 8.0;
    final drX = size.width - 65;
    canvas.drawRect(Rect.fromLTWH(drX, drY, drW, drH), _fill(const Color(0xFFBA4A00)));
    canvas.drawCircle(Offset(drX + 8, drY + drH / 2), 3.5, _fill(const Color(0xFFF1C40F)));
  }

  // 15. Library.
  void _spatialLibrary(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _fill(const Color(0xFF5D6D7E)));

    const bsW = 75.0, bsH = 100.0, bsX = 20.0, bsY = 10.0;
    canvas.drawRect(Rect.fromLTWH(bsX, bsY, bsW, bsH), _fill(const Color(0xFF7E5109)));
    for (var row = 0; row <= 2; row++) {
      final rY = bsY + 10 + row * 28;
      canvas.drawRect(Rect.fromLTWH(bsX + 6, rY + 18, bsW - 12, 4), _fill(const Color(0xFF4A3403)));
      canvas.drawRect(Rect.fromLTWH(bsX + 12, rY, 10, 18), _fill(Colors.red));
      canvas.drawRect(Rect.fromLTWH(bsX + 24, rY + 2, 8, 16), _fill(Colors.blue));
      canvas.drawRect(Rect.fromLTWH(bsX + 34, rY - 1, 12, 19), _fill(Colors.green));
      canvas.drawRect(Rect.fromLTWH(bsX + 48, rY + 4, 9, 14), _fill(Colors.yellow));
    }

    const tW = 150.0;
    final tX = size.width - 180;
    final tY = size.height - 45;
    _roundRect(canvas, tX, tY, tW, 12, 2, const Color(0xFFBA4A00));
    canvas.drawRect(Rect.fromLTWH(tX + 15, tY + 12, 8, 23), _fill(const Color(0xFF7E5109)));
    canvas.drawRect(Rect.fromLTWH(tX + tW - 23, tY + 12, 8, 23), _fill(const Color(0xFF7E5109)));

    final lpX = tX + tW + 15;
    final lpY = size.height - 95;
    canvas.drawLine(Offset(lpX, lpY), Offset(lpX, size.height - 10), _stroke(const Color(0xFFD3D3D3), 3));
    _roundRect(canvas, lpX - 12, size.height - 14, 24, 6, 0, Colors.grey);
    final shade = Path()
      ..moveTo(lpX - 16, lpY + 20)
      ..lineTo(lpX + 16, lpY + 20)
      ..lineTo(lpX + 8, lpY)
      ..lineTo(lpX - 8, lpY)
      ..close();
    canvas.drawPath(shade, _fill(const Color(0xFFF39C12)));
    canvas.drawCircle(Offset(lpX, lpY + 35), 28, _fill(const Color(0xFFF1C40F).withValues(alpha: 0.25)));
  }

  // 16. Diner / restaurant.
  void _spatialDiner(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _fill(const Color(0xFFE5E7E9)));

    const kX = 20.0;
    final kY = size.height - 65;
    _roundRect(canvas, kX, kY, 65, 50, 4, const Color(0xFF2C3E50));
    canvas.drawRect(Rect.fromLTWH(kX + 10, kY + 10, 20, 15), _fill(Colors.black));
    canvas.drawRect(Rect.fromLTWH(kX + 12, kY + 12, 16, 11), _fill(Colors.green));

    final dtX = size.width / 2.3;
    final dtY = size.height - 50;
    canvas.drawCircle(Offset(dtX, dtY), 24, _fill(const Color(0xFFE67E22)));
    canvas.drawCircle(Offset(dtX, dtY), 6, _fill(const Color(0xFF5D6D7E)));

    const dW = 130.0, dH = 75.0, dY = 12.0;
    final dX = size.width - 150;
    _roundRect(canvas, dX, dY, dW, dH, 5, const Color(0xFFBDC3C7));
    canvas.drawRect(Rect.fromLTWH(dX + 15, dY + 15, dW - 30, dH - 35), _fill(const Color(0xFF34495E)));
  }

  @override
  bool shouldRepaint(covariant _ScenePainter oldDelegate) =>
      oldDelegate.type != type || oldDelegate.elements != elements;
}
