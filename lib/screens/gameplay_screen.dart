import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../state/quiz_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/quiz_illustration.dart';

class GameplayScreen extends StatelessWidget {
  const GameplayScreen({super.key, required this.levelId, required this.stageId});

  final int levelId;
  final int stageId;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizController>();
    final q = vm.currentQuestion;
    final accent = AppColors.levelAccentAlt(levelId);

    if (q == null) return const SizedBox.shrink();

    final isObs = vm.isObservationPhase;
    final ansElapsedMs = vm.answerTimeElapsedMs;
    final selectedIdx = vm.selectedOptionIndex;
    final shouldShowIllustration = isObs ? true : (levelId == 2);

    return Container(
      color: AppColors.gameplayBackground,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _squareButton(Icons.close, () => vm.navigateTo(StageSelectState(levelId))),
                  Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E355E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    child: Text('LEVEL $levelId • SOAL $stageId',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                  ),
                  const SizedBox(width: 46),
                ],
              ),
              const SizedBox(height: 12),
              // Phase panel
              if (isObs)
                _observationPanel(q.observationTimeSecs, vm.observationTimer, accent)
              else
                _answerPanel(ansElapsedMs),
              const SizedBox(height: 10),
              // Illustration card
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFCBD5E1), width: 1.5),
                  ),
                  alignment: Alignment.center,
                  child: QuizIllustration(question: q, isVisible: shouldShowIllustration),
                ),
              ),
              const SizedBox(height: 8),
              // Question card
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(color: accent, borderRadius: BorderRadius.circular(8)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      child: const Text('PERTANYAAN',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1)),
                    ),
                    const SizedBox(height: 6),
                    Text(q.text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF1F2937), height: 1.25)),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Actions
              if (isObs)
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: vm.skipObservation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFBBF24),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                        side: const BorderSide(color: Color(0xFFB45309), width: 2),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('💡', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text('YUK, JAWAB SOAL!',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: Color(0xFF78350F))),
                      ],
                    ),
                  ),
                )
              else
                Column(
                  children: [
                    for (var index = 0; index < q.options.length; index++) ...[
                      _OptionCard(
                        letter: const ['A', 'B', 'C', 'D'][index],
                        text: q.options[index],
                        isSelected: selectedIdx == index,
                        bulletColor: const [
                          Color(0xFFEF4444),
                          Color(0xFF3B82F6),
                          Color(0xFF10B981),
                          Color(0xFF8B5CF6),
                        ][index],
                        onTap: () => vm.submitAnswer(index),
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _observationPanel(int totalSecs, int timer, Color accent) {
    return Column(
      children: [
        SizedBox(
          width: 76,
          height: 76,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 76,
                height: 76,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                ),
              ),
              SizedBox(
                width: 76,
                height: 76,
                child: CircularProgressIndicator(
                  value: totalSecs > 0 ? timer / totalSecs : 0,
                  strokeWidth: 4,
                  color: accent,
                  backgroundColor: const Color(0xFFF1F5F9),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$timer', style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: Color(0xFF1E2937))),
                  const Text('detik', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF64748B))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text('PERHATIKAN & INGAT DETAIL GAMBAR!',
            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A), letterSpacing: 1)),
      ],
    );
  }

  Widget _answerPanel(int ansElapsedMs) {
    final elapsedSec = ansElapsedMs / 1000.0;
    final starsGained = ansElapsedMs < 3000 ? 3 : (ansElapsedMs < 7000 ? 2 : 1);
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('⏱️', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
              Text('${elapsedSec.toStringAsFixed(2)} s',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFF1F2937))),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (var st = 1; st <= 3; st++)
              Transform.scale(
                scale: st <= starsGained ? 1.2 : 1.0,
                child: Icon(Icons.star,
                    size: 24,
                    color: st <= starsGained ? const Color(0xFFFFC107) : const Color(0xFFCBD5E1).withValues(alpha: 0.5)),
              ),
          ],
        ),
      ],
    );
  }

  static Widget _squareButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
      ),
    );
  }
}

class _OptionCard extends StatelessWidget {
  const _OptionCard({
    required this.letter,
    required this.text,
    required this.isSelected,
    required this.bulletColor,
    required this.onTap,
  });

  final String letter;
  final String text;
  final bool isSelected;
  final Color bulletColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFEFF6FF) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 34,
              height: 34,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? const Color(0xFF3B82F6) : bulletColor.withValues(alpha: 0.12),
              ),
              alignment: Alignment.center,
              child: Text(letter,
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: isSelected ? Colors.white : bulletColor)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF334155), height: 1.3)),
            ),
          ],
        ),
      ),
    );
  }
}
