import 'package:flutter/material.dart';

/// Cute cartoon brain mascot, ported from the original `SmilingBrainCharacter`
/// Compose canvas drawing.
class SmilingBrain extends StatelessWidget {
  const SmilingBrain({super.key, this.size = 150});

  final double size;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.square(size),
      painter: _SmilingBrainPainter(),
    );
  }
}

class _SmilingBrainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    const pink = Color(0xFFFFC0D9);
    const pinkDark = Color(0xFFF48FB1);

    final darkPaint = Paint()..color = pinkDark;
    final pinkPaint = Paint()..color = pink;

    Offset o(double x, double y) => Offset(x, y);

    // Base lobe circles.
    canvas.drawCircle(o(w * 0.35, h * 0.46), w * 0.28, darkPaint);
    canvas.drawCircle(o(w * 0.65, h * 0.46), w * 0.28, darkPaint);
    canvas.drawCircle(o(w * 0.5, h * 0.32), w * 0.24, darkPaint);
    canvas.drawCircle(o(w * 0.5, h * 0.64), w * 0.24, darkPaint);

    // Inner fill.
    canvas.drawCircle(o(w * 0.35, h * 0.46), w * 0.26, pinkPaint);
    canvas.drawCircle(o(w * 0.65, h * 0.46), w * 0.26, pinkPaint);
    canvas.drawCircle(o(w * 0.5, h * 0.32), w * 0.22, pinkPaint);
    canvas.drawCircle(o(w * 0.5, h * 0.64), w * 0.22, pinkPaint);

    // Side lobes.
    canvas.drawCircle(o(w * 0.26, h * 0.54), w * 0.21, pinkPaint);
    canvas.drawCircle(o(w * 0.74, h * 0.54), w * 0.21, pinkPaint);

    // Eyes.
    final eyeRadius = w * 0.045;
    final leftEye = o(w * 0.41, h * 0.49);
    final rightEye = o(w * 0.59, h * 0.49);
    final black = Paint()..color = Colors.black;
    canvas.drawCircle(leftEye, eyeRadius, black);
    canvas.drawCircle(rightEye, eyeRadius, black);

    final white = Paint()..color = Colors.white;
    canvas.drawCircle(
      Offset(leftEye.dx - eyeRadius * 0.28, leftEye.dy - eyeRadius * 0.28),
      eyeRadius * 0.4,
      white,
    );
    canvas.drawCircle(
      Offset(rightEye.dx - eyeRadius * 0.28, rightEye.dy - eyeRadius * 0.28),
      eyeRadius * 0.4,
      white,
    );

    // Rosy cheeks.
    final cheek = Paint()..color = const Color(0xFFE91E63).withValues(alpha: 0.4);
    canvas.drawCircle(o(w * 0.31, h * 0.57), w * 0.052, cheek);
    canvas.drawCircle(o(w * 0.69, h * 0.57), w * 0.052, cheek);

    // Smile.
    final smile = Path()
      ..moveTo(w * 0.47, h * 0.54)
      ..quadraticBezierTo(w * 0.5, h * 0.61, w * 0.53, h * 0.54);
    canvas.drawPath(
      smile,
      Paint()
        ..color = const Color(0xFF2C3E50)
        ..style = PaintingStyle.stroke
        ..strokeWidth = w * 0.016
        ..strokeCap = StrokeCap.round,
    );

    // Brain fold lines.
    final foldPaint = Paint()
      ..color = pinkDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.012
      ..strokeCap = StrokeCap.round;
    final fold1 = Path()
      ..moveTo(w * 0.25, h * 0.36)
      ..quadraticBezierTo(w * 0.31, h * 0.33, w * 0.37, h * 0.38);
    canvas.drawPath(fold1, foldPaint);
    final fold2 = Path()
      ..moveTo(w * 0.75, h * 0.36)
      ..quadraticBezierTo(w * 0.69, h * 0.33, w * 0.63, h * 0.38);
    canvas.drawPath(fold2, foldPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
