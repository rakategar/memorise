import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Static tilted confetti shapes scattered behind the summary content.
class DecorativeConfetti extends StatelessWidget {
  const DecorativeConfetti({super.key});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          _piece(Alignment.centerLeft, const Offset(24, 100), 24, 12, 35, const Color(0xFF4ADE80)),
          _piece(Alignment.centerRight, const Offset(-24, 140), 18, 10, -20, const Color(0xFFF87171)),
          _piece(Alignment.topRight, const Offset(-30, 180), 14, 14, 15, const Color(0xFFFB923C)),
          _piece(Alignment.centerRight, const Offset(-10, -50), 16, 16, 45, const Color(0xFFF472B6)),
          _piece(Alignment.topLeft, const Offset(40, 120), 12, 12, -30, const Color(0xFF60A5FA)),
        ],
      ),
    );
  }

  Widget _piece(Alignment align, Offset offset, double w, double h, double deg, Color color) {
    return Align(
      alignment: align,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: deg * math.pi / 180,
          child: Container(width: w, height: h, color: color),
        ),
      ),
    );
  }
}

class _Particle {
  _Particle({
    required this.color,
    required this.size,
    required this.rot,
    required this.rotV,
  });
  double x = 0;
  double y = 0;
  double vx = 0;
  double vy = 0;
  double rot;
  final double rotV;
  final Color color;
  final double size;
  bool initialized = false;
}

/// Burst confetti animation (120 particles with gravity & drag, fading out
/// over 4s). Ported from the original `ConfettiView`.
class ConfettiView extends StatefulWidget {
  const ConfettiView({super.key});

  @override
  State<ConfettiView> createState() => _ConfettiViewState();
}

class _ConfettiViewState extends State<ConfettiView> with SingleTickerProviderStateMixin {
  static const _colors = [
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFFFC107),
    Color(0xFF8B5CF6),
  ];

  late final AnimationController _controller;
  late final List<_Particle> _particles;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(120, (_) {
      return _Particle(
        color: _colors[_rng.nextInt(_colors.length)],
        size: _rng.nextDouble() * 15 + 15,
        rot: _rng.nextDouble() * 360,
        rotV: _rng.nextDouble() * 10 - 5,
      );
    });
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    )..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return CustomPaint(
            size: Size.infinite,
            painter: _ConfettiPainter(_particles, _controller.value, _rng),
          );
        },
      ),
    );
  }
}

class _ConfettiPainter extends CustomPainter {
  _ConfettiPainter(this.particles, this.progress, this.rng);

  final List<_Particle> particles;
  final double progress;
  final math.Random rng;

  @override
  void paint(Canvas canvas, Size size) {
    if (progress >= 1) return;

    final cx = size.width / 2;
    final cy = size.height * 0.2;

    if (!particles.first.initialized) {
      for (final p in particles) {
        p.x = cx + (rng.nextDouble() - 0.5) * size.width * 0.05;
        p.y = cy + (rng.nextDouble() - 0.5) * size.height * 0.05;
        p.vx = (rng.nextDouble() - 0.5) * size.width * 0.06;
        p.vy = -(rng.nextDouble() * size.height * 0.035 + size.height * 0.01);
        p.initialized = true;
      }
    }

    final gravity = size.height * 0.0008;
    const drag = 0.98;

    for (final p in particles) {
      p.x += p.vx;
      p.y += p.vy;
      p.vy += gravity;
      p.vx *= drag;
      p.vy *= drag;
      p.rot += p.rotV;
    }

    final globalAlpha = (progress > 0.8 ? (1 - progress) * 5 : 1.0).clamp(0.0, 1.0);

    for (final p in particles) {
      canvas.save();
      final pivot = Offset(p.x + p.size / 2, p.y + p.size / 2);
      canvas.translate(pivot.dx, pivot.dy);
      canvas.rotate(p.rot * math.pi / 180);
      canvas.translate(-pivot.dx, -pivot.dy);
      canvas.drawRect(
        Rect.fromLTWH(p.x, p.y, p.size, p.size * 1.5),
        Paint()..color = p.color.withValues(alpha: globalAlpha),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) => true;
}
