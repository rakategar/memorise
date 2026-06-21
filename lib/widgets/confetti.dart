import 'dart:math' as math;

import 'package:flutter/material.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Static decorative pieces (always visible behind summary content)
// ─────────────────────────────────────────────────────────────────────────────

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

// ─────────────────────────────────────────────────────────────────────────────
// Falling confetti — loops continuously, sits at the BACK layer.
// ─────────────────────────────────────────────────────────────────────────────

class _FallingParticle {
  _FallingParticle({
    required this.xFrac,
    required this.delay,
    required this.speed,
    required this.drift,
    required this.size,
    required this.rot,
    required this.rotSpeed,
    required this.color,
    required this.isCircle,
  });
  final double xFrac;
  final double delay;
  final double speed;
  final double drift;
  final double size;
  final double rot;
  final double rotSpeed;
  final Color color;
  final bool isCircle;
}

class FallingConfettiView extends StatefulWidget {
  const FallingConfettiView({super.key});

  @override
  State<FallingConfettiView> createState() => _FallingConfettiViewState();
}

class _FallingConfettiViewState extends State<FallingConfettiView>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    Color(0xFFFDC83A),
    Color(0xFFEF4444),
    Color(0xFF3B82F6),
    Color(0xFF10B981),
    Color(0xFFF97316),
    Color(0xFFEC4899),
    Color(0xFF8B5CF6),
  ];

  late final AnimationController _ctrl;
  late final List<_FallingParticle> _particles;

  @override
  void initState() {
    super.initState();
    final rng = math.Random();
    _particles = List.generate(20, (_) => _FallingParticle(
      xFrac: rng.nextDouble(),
      delay: rng.nextDouble(),
      speed: 0.5 + rng.nextDouble(),
      drift: (rng.nextDouble() - 0.5) * 50,
      size: 7 + rng.nextDouble() * 10,
      rot: rng.nextDouble() * math.pi * 2,
      rotSpeed: (rng.nextDouble() - 0.5) * 4,
      color: _colors[rng.nextInt(_colors.length)],
      isCircle: rng.nextBool(),
    ));

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (_, __) => CustomPaint(
          size: Size.infinite,
          painter: _FallingPainter(_particles, _ctrl.value),
        ),
      ),
    );
  }
}

class _FallingPainter extends CustomPainter {
  _FallingPainter(this.particles, this.t);
  final List<_FallingParticle> particles;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final phase = (t * p.speed + p.delay) % 1.0;
      final y = -p.size + phase * (size.height + p.size * 2);
      final x = p.xFrac * size.width + math.sin(phase * math.pi * 2) * p.drift;
      final rot = p.rot + phase * p.rotSpeed * math.pi * 2;

      canvas.save();
      canvas.translate(x + p.size / 2, y + p.size / 2);
      canvas.rotate(rot);
      final paint = Paint()..color = p.color.withValues(alpha: 0.75);
      if (p.isCircle) {
        canvas.drawCircle(Offset.zero, p.size / 2, paint);
      } else {
        canvas.drawRect(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 1.4),
          paint,
        );
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _FallingPainter old) => old.t != t;
}

// ─────────────────────────────────────────────────────────────────────────────
// Burst explosion confetti — 120 particles from center, plays once (4s).
// ─────────────────────────────────────────────────────────────────────────────

class _BurstParticle {
  _BurstParticle({required this.color, required this.size, required this.rot, required this.rotV});
  double x = 0, y = 0, vx = 0, vy = 0;
  double rot;
  final double rotV;
  final Color color;
  final double size;
  bool initialized = false;
}

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
  late final List<_BurstParticle> _particles;
  final _rng = math.Random();

  @override
  void initState() {
    super.initState();
    _particles = List.generate(120, (_) => _BurstParticle(
      color: _colors[_rng.nextInt(_colors.length)],
      size: _rng.nextDouble() * 15 + 15,
      rot: _rng.nextDouble() * 360,
      rotV: _rng.nextDouble() * 10 - 5,
    ));
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
        builder: (_, __) => CustomPaint(
          size: Size.infinite,
          painter: _BurstPainter(_particles, _controller.value, _rng),
        ),
      ),
    );
  }
}

class _BurstPainter extends CustomPainter {
  _BurstPainter(this.particles, this.progress, this.rng);
  final List<_BurstParticle> particles;
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

    final alpha = (progress > 0.8 ? (1 - progress) * 5 : 1.0).clamp(0.0, 1.0);
    for (final p in particles) {
      canvas.save();
      final pivot = Offset(p.x + p.size / 2, p.y + p.size / 2);
      canvas.translate(pivot.dx, pivot.dy);
      canvas.rotate(p.rot * math.pi / 180);
      canvas.translate(-pivot.dx, -pivot.dy);
      canvas.drawRect(
        Rect.fromLTWH(p.x, p.y, p.size, p.size * 1.5),
        Paint()..color = p.color.withValues(alpha: alpha),
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _BurstPainter old) => true;
}
