import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/sky_meadow_background.dart';
import '../widgets/smiling_brain.dart';

/// Animated 1.6s splash with a pulsing brain, title, and a loading bar.
class IntroLoadingScreen extends StatefulWidget {
  const IntroLoadingScreen({super.key});

  @override
  State<IntroLoadingScreen> createState() => _IntroLoadingScreenState();
}

class _IntroLoadingScreenState extends State<IntroLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  double _progress = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
      lowerBound: 1.0,
      upperBound: 1.08,
    )..repeat(reverse: true);

    const steps = 40;
    var i = 0;
    _timer = Timer.periodic(const Duration(milliseconds: 35), (t) {
      i++;
      if (mounted) setState(() => _progress = i / steps);
      if (i >= steps) t.cancel();
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SkyMeadowBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 16),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ScaleTransition(
                      scale: _pulse,
                      child: const SmilingBrain(size: 165),
                    ),
                    const SizedBox(height: 14),
                    const _BubbleTitle(),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      child: const Text(
                        'Uji Ingatanmu!',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Column(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 0.85,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          _IntroCard(emoji: '🌅', bg: Colors.white, border: Color(0xFFBDD7EE)),
                          _IntroCard(emoji: '⭐', bg: Color(0xFFFFFAED), border: Color(0xFFFFD54F)),
                          _IntroCard(emoji: '❓', bg: Color(0xFFE8F5E9), border: Color(0xFF81C784)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 26),
                    FractionallySizedBox(
                      widthFactor: 0.82,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: _progress,
                          minHeight: 13,
                          color: const Color(0xFF3B82F6),
                          backgroundColor: const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(_progress * 100).toInt()}%',
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFF475569)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BubbleTitle extends StatelessWidget {
  const _BubbleTitle();

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: const Offset(2, 3),
          child: Text(
            'MEMORY CHALLENGE',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
              color: const Color(0xFF1E3A8A).withValues(alpha: 0.15),
            ),
          ),
        ),
        const Text(
          'MEMORY CHALLENGE',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.2,
            color: Color(0xFF1E355E),
          ),
        ),
      ],
    );
  }
}

class _IntroCard extends StatelessWidget {
  const _IntroCard({required this.emoji, required this.bg, required this.border});
  final String emoji;
  final Color bg;
  final Color border;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: border, width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 28)),
    );
  }
}
