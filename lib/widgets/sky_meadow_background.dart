import 'package:flutter/material.dart';

/// Full-screen sky/meadow scenery, ported from the original `bgmenu.xml`
/// vector drawable (sky gradient, clouds, mountains, rolling green fields,
/// and little flowers). Coordinates use the original 360x740 viewport and are
/// scaled to fill the available size.
class SkyMeadowBackground extends StatelessWidget {
  const SkyMeadowBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(painter: _SkyMeadowPainter()),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}

class _SkyMeadowPainter extends CustomPainter {
  static const double vw = 360;
  static const double vh = 740;

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / vw;
    final sy = size.height / vh;

    Offset pt(double x, double y) => Offset(x * sx, y * sy);

    // 1. Sky gradient (bright blue to soft horizon cyan).
    final skyRect = Offset.zero & size;
    final skyPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF3897F2),
          Color(0xFF5DAEF7),
          Color(0xFF96D5FA),
          Color(0xFFD6F0FE),
          Color(0xFFE8F7FF),
        ],
        stops: [0.0, 0.30, 0.55, 0.75, 1.0],
      ).createShader(skyRect);
    canvas.drawRect(skyRect, skyPaint);

    // 4. Distant mountain ranges.
    final mountains = Path()
      ..moveTo(-50 * sx, 600 * sy)
      ..lineTo(10 * sx, 560 * sy)
      ..quadraticBezierTo(80 * sx, 520 * sy, 150 * sx, 550 * sy)
      ..quadraticBezierTo(210 * sx, 520 * sy, 280 * sx, 560 * sy)
      ..lineTo(410 * sx, 510 * sy)
      ..lineTo(410 * sx, 750 * sy)
      ..lineTo(-50 * sx, 750 * sy)
      ..close();
    canvas.drawPath(
      mountains,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF7BB7D8), Color(0xFF8BBED9), Color(0xFFA2D2CE)],
        ).createShader(Rect.fromPoints(pt(180, 520), pt(180, 740))),
    );

    // 5. Middle green hills.
    final hills = Path()
      ..moveTo(-20 * sx, 640 * sy)
      ..quadraticBezierTo(60 * sx, 590 * sy, 140 * sx, 610 * sy)
      ..quadraticBezierTo(220 * sx, 580 * sy, 300 * sx, 600 * sy)
      ..quadraticBezierTo(340 * sx, 585 * sy, 380 * sx, 600 * sy)
      ..lineTo(380 * sx, 750 * sy)
      ..lineTo(-20 * sx, 750 * sy)
      ..close();
    canvas.drawPath(
      hills,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF83CF5E), Color(0xFF97D968), Color(0xFF8AB851)],
        ).createShader(Rect.fromPoints(pt(180, 580), pt(180, 750))),
    );

    // 6. Foreground vibrant fields.
    final fields = Path()
      ..moveTo(-20 * sx, 680 * sy)
      ..cubicTo(120 * sx, 640 * sy, 240 * sx, 680 * sy, 380 * sx, 630 * sy)
      ..lineTo(380 * sx, 750 * sy)
      ..lineTo(-20 * sx, 750 * sy)
      ..close();
    canvas.drawPath(
      fields,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF5EB82D), Color(0xFF77CC3C), Color(0xFF388F1D)],
        ).createShader(Rect.fromPoints(pt(180, 630), pt(180, 750))),
    );

    // Close foreground turf slope.
    final turf = Path()
      ..moveTo(-10 * sx, 720 * sy)
      ..quadraticBezierTo(70 * sx, 700 * sy, 150 * sx, 715 * sy)
      ..quadraticBezierTo(250 * sx, 695 * sy, 370 * sx, 710 * sy)
      ..lineTo(370 * sx, 750 * sy)
      ..lineTo(-10 * sx, 750 * sy)
      ..close();
    canvas.drawPath(
      turf,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: const [Color(0xFF40A313), Color(0xFF1A5E04)],
        ).createShader(Rect.fromPoints(pt(180, 695), pt(180, 750))),
    );

    // Little flowers.
    void flower(double cx, double cy, double r) {
      canvas.drawCircle(pt(cx, cy), r * sx, Paint()..color = const Color(0xFFFFEB3B));
      canvas.drawCircle(pt(cx, cy), r * 0.5 * sx, Paint()..color = const Color(0xFFFF9800));
    }

    flower(27, 730, 3);
    flower(156, 724, 4);
    flower(276.5, 728, 3.5);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
