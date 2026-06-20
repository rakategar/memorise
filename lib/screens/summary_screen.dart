import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/sound_manager.dart';
import '../data/quiz_questions.dart';
import '../models/question.dart';
import '../state/quiz_controller.dart';
import '../state/scoring.dart';
import '../widgets/confetti.dart';

class SummaryScreen extends StatefulWidget {
  const SummaryScreen({
    super.key,
    required this.levelId,
    required this.stageId,
    required this.isSuccess,
    required this.stars,
    required this.timeSpentMs,
  });

  final int levelId;
  final int stageId;
  final bool isSuccess;
  final int stars;
  final int timeSpentMs;

  @override
  State<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends State<SummaryScreen> with TickerProviderStateMixin {
  // Star pop controllers: index 0 = center, 1 = left, 2 = right.
  late final List<AnimationController> _starCtrls;
  late final AnimationController _scoreCtrl;

  int get _baseScore => Scoring.baseScore(widget.isSuccess);
  int get _starBonus => Scoring.starBonus(widget.isSuccess, widget.stars);
  int get _timeBonus => Scoring.timeBonus(widget.isSuccess, widget.timeSpentMs);
  int get _totalScore => _baseScore + _starBonus + _timeBonus;

  @override
  void initState() {
    super.initState();
    _starCtrls = List.generate(
      3,
      (_) => AnimationController(vsync: this, duration: const Duration(milliseconds: 600)),
    );
    _scoreCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1100),
    );
    _runSequence();
  }

  Future<void> _runSequence() async {
    final vm = context.read<QuizController>();
    if (widget.isSuccess) {
      final earned = [widget.stars >= 1, widget.stars >= 2, widget.stars >= 3];
      for (var i = 0; i < 3; i++) {
        await Future<void>.delayed(Duration(milliseconds: i == 0 ? 300 : 250));
        if (!mounted) return;
        if (earned[i]) vm.soundManager.playSound(SfxType.click);
        _starCtrls[i].forward();
      }
      await Future<void>.delayed(const Duration(milliseconds: 1200 - 800));
      if (!mounted) return;
      _scoreCtrl.forward();
    } else {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      for (final c in _starCtrls) {
        c.forward();
      }
    }
  }

  @override
  void dispose() {
    for (final c in _starCtrls) {
      c.dispose();
    }
    _scoreCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<QuizController>();
    final q = QuizQuestions.getQuestions()
        .cast<Question?>()
        .firstWhere((it) => it!.levelId == widget.levelId && it.stageId == widget.stageId, orElse: () => null);
    if (q == null) return const SizedBox.shrink();

    final secondsTotal = widget.timeSpentMs ~/ 1000;
    final timeFormatted =
        '${(secondsTotal ~/ 60).toString().padLeft(2, '0')}:${(secondsTotal % 60).toString().padLeft(2, '0')}';
    final accuracyFormatted = Scoring.accuracyLabel(widget.isSuccess, widget.stars);

    return Container(
      color: const Color(0xFF0C1F3D),
      child: Stack(
        children: [
          const DecorativeConfetti(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  _levelPill(),
                  const SizedBox(height: 12),
                  Text(widget.isSuccess ? 'SELESAI!' : 'BELUM TEPAT!',
                      style: const TextStyle(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                  const SizedBox(height: 16),
                  _starsRow(),
                  const SizedBox(height: 24),
                  _scoreCard(timeFormatted, accuracyFormatted),
                  const SizedBox(height: 22),
                  _actionButtons(vm),
                  const SizedBox(height: 16),
                  _homeButton(vm),
                  const SizedBox(height: 20),
                  _explanationCard(q.explanation),
                ],
              ),
            ),
          ),
          if (widget.isSuccess) const Positioned.fill(child: ConfettiView()),
        ],
      ),
    );
  }

  Widget _levelPill() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1B365D),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFF2E5B8E)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Text('LEVEL ${widget.levelId}',
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF90CDF4), letterSpacing: 1)),
    );
  }

  Widget _starsRow() {
    final centerEarned = widget.isSuccess && widget.stars >= 1;
    final leftEarned = widget.isSuccess && widget.stars >= 2;
    final rightEarned = widget.isSuccess && widget.stars >= 3;
    const off = Color(0x40FFFFFF); // white 25%
    const on = Color(0xFFFDC83A);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _animatedStar(_starCtrls[1], 46, leftEarned ? on : off),
        const SizedBox(width: 16),
        _animatedStar(_starCtrls[0], 68, centerEarned ? on : off),
        const SizedBox(width: 16),
        _animatedStar(_starCtrls[2], 46, rightEarned ? on : off),
      ],
    );
  }

  Widget _animatedStar(AnimationController ctrl, double size, Color color) {
    return AnimatedBuilder(
      animation: ctrl,
      builder: (context, child) {
        final scale = Curves.elasticOut.transform(ctrl.value).clamp(0.0, 1.2);
        final rotation = (1 - ctrl.value) * (-45) * 3.1415926 / 180;
        return Transform.rotate(
          angle: rotation,
          child: Transform.scale(scale: scale, child: child),
        );
      },
      child: Icon(Icons.star, size: size, color: color),
    );
  }

  Widget _scoreCard(String timeFormatted, String accuracyFormatted) {
    return FractionallySizedBox(
      widthFactor: 0.88,
      child: Container(
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          children: [
            const Text('Skor Anda', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF5A7295))),
            const SizedBox(height: 4),
            AnimatedBuilder(
              animation: _scoreCtrl,
              builder: (context, _) {
                final shown = widget.isSuccess ? (_scoreCtrl.value * _totalScore).toInt() : 0;
                return Text('$shown',
                    style: const TextStyle(fontSize: 62, fontWeight: FontWeight.w900, color: Color(0xFF0F315E)));
              },
            ),
            const SizedBox(height: 12),
            _scoreRow('Skor Dasar', '$_baseScore', const Color(0xFF2D3748)),
            const SizedBox(height: 4),
            _scoreRow('Bonus Bintang', '+$_starBonus', const Color(0xFFD97706)),
            const SizedBox(height: 4),
            _scoreRow('Bonus Kecepatan', '+$_timeBonus', const Color(0xFF0D9488)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12),
              height: 1,
              color: const Color(0xFFE2E8F0),
            ),
            _metricRow('Waktu', timeFormatted),
            _metricRow('Akurasi', accuracyFormatted),
          ],
        ),
      ),
    );
  }

  Widget _scoreRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 14, color: Color(0xFF718096))),
          Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: valueColor)),
        ],
      ),
    );
  }

  Widget _metricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Color(0xFF4A5568))),
          Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF0F315E))),
        ],
      ),
    );
  }

  Widget _actionButtons(QuizController vm) {
    VoidCallback onLanjut() {
      final nextStg = widget.stageId + 1;
      if (nextStg <= 10) return () => vm.navigateTo(GameplayState(widget.levelId, nextStg));
      if (widget.levelId < 3) return () => vm.navigateTo(StageSelectState(widget.levelId + 1));
      return () => vm.navigateTo(const SplashScreenState());
    }

    return FractionallySizedBox(
      widthFactor: 0.88,
      child: widget.isSuccess
          ? Row(
              children: [
                Expanded(
                  child: _actionButton(
                    label: 'ULANGI',
                    icon: Icons.refresh,
                    bg: const Color(0xFF2D81CD),
                    fg: Colors.white,
                    iconLeading: true,
                    onTap: () => vm.navigateTo(GameplayState(widget.levelId, widget.stageId)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _actionButton(
                    label: 'LANJUT',
                    icon: Icons.arrow_forward,
                    bg: const Color(0xFFFDC83A),
                    fg: const Color(0xFF0F2547),
                    iconLeading: false,
                    onTap: onLanjut(),
                  ),
                ),
              ],
            )
          : _actionButton(
              label: 'COBA LAGI',
              icon: Icons.refresh,
              bg: const Color(0xFF2D81CD),
              fg: Colors.white,
              iconLeading: true,
              onTap: () => vm.navigateTo(GameplayState(widget.levelId, widget.stageId)),
            ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color bg,
    required Color fg,
    required bool iconLeading,
    required VoidCallback onTap,
  }) {
    final iconWidget = Icon(icon, color: fg, size: 18);
    final textWidget = Text(label, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: fg));
    return SizedBox(
      height: 54,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: bg,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: iconLeading
              ? [iconWidget, const SizedBox(width: 6), textWidget]
              : [textWidget, const SizedBox(width: 6), iconWidget],
        ),
      ),
    );
  }

  Widget _homeButton(QuizController vm) {
    return GestureDetector(
      onTap: () => vm.navigateTo(StageSelectState(widget.levelId)),
      child: Container(
        width: 54,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF1A3961),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF2C5585)),
        ),
        child: const Icon(Icons.home, color: Colors.white, size: 24),
      ),
    );
  }

  Widget _explanationCard(String explanation) {
    return FractionallySizedBox(
      widthFactor: 0.88,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1B365D).withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF2A4D80).withValues(alpha: 0.4)),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('💡 PENJELASAN:',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF90CDF4))),
            const SizedBox(height: 4),
            Text(explanation,
                style: TextStyle(fontSize: 12, height: 1.4, color: Colors.white.withValues(alpha: 0.9))),
          ],
        ),
      ),
    );
  }
}
