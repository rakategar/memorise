import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/sound_manager.dart';
import '../data/quiz_questions.dart';
import '../models/stage_progress.dart';
import '../state/quiz_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/sky_meadow_background.dart';

class StageSelectScreen extends StatelessWidget {
  const StageSelectScreen({super.key, required this.levelId});

  final int levelId;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizController>();
    final levelName = QuizQuestions.levelNames[levelId] ?? '';
    final levelProgress = vm.progressList.where((p) => p.levelId == levelId).toList();
    final totalStarsObtained = levelProgress.fold<int>(0, (s, p) => s + p.starsCount);
    final accent = AppColors.levelAccentAlt(levelId);

    return SkyMeadowBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _squareButton(Icons.arrow_back, () => vm.navigateTo(const LevelSelectState())),
                  Text('LEVEL $levelId SOAL MAP',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1F2937), letterSpacing: 1.2)),
                  const SizedBox(width: 46),
                ],
              ),
              const SizedBox(height: 12),
              // Level metadata banner
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.95),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Text(levelName,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: accent)),
                    const Padding(
                      padding: EdgeInsets.only(top: 2),
                      child: Text('Kumpulkan bintang untuk membuka kunci level berikutnya!',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B))),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFAED),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFD54F)),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFC107), size: 18),
                          const SizedBox(width: 6),
                          Text('$totalStarsObtained / 30 Bintang',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              Expanded(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    final stgId = index + 1;
                    final progress = levelProgress.cast<StageProgress?>().firstWhere(
                          (p) => p?.stageId == stgId,
                          orElse: () => null,
                        );
                    final isUnlocked = progress?.isUnlocked ?? (stgId == 1 && levelId == 1);
                    final isCompleted = progress?.isCompleted ?? false;
                    final stars = progress?.starsCount ?? 0;
                    final bestTimeSec = (progress != null && progress.timeSpentMs > 0)
                        ? progress.timeSpentMs / 1000.0
                        : null;

                    return StageMapNode(
                      stageId: stgId,
                      isUnlocked: isUnlocked,
                      isCompleted: isCompleted,
                      stars: stars,
                      bestTimeSec: bestTimeSec,
                      accent: accent,
                      onTap: () {
                        if (isUnlocked) {
                          vm.navigateTo(GameplayState(levelId, stgId));
                        } else {
                          vm.soundManager.playSound(SfxType.incorrect);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
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
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1.2),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))],
        ),
        child: Icon(icon, color: const Color(0xFF1E3A8A), size: 20),
      ),
    );
  }
}

class StageMapNode extends StatelessWidget {
  const StageMapNode({
    super.key,
    required this.stageId,
    required this.isUnlocked,
    required this.isCompleted,
    required this.stars,
    required this.bestTimeSec,
    required this.accent,
    required this.onTap,
  });

  final int stageId;
  final bool isUnlocked;
  final bool isCompleted;
  final int stars;
  final double? bestTimeSec;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : const Color(0xFFF1F5F9).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isUnlocked ? accent.withValues(alpha: 0.5) : const Color(0xFFCBD5E1),
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? accent
                    : isUnlocked
                        ? accent.withValues(alpha: 0.12)
                        : const Color(0xFFE2E8F0),
              ),
              alignment: Alignment.center,
              child: isUnlocked
                  ? Text('$stageId',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: isCompleted ? Colors.white : accent))
                  : const Icon(Icons.lock, color: Color(0xFF94A3B8), size: 16),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (var s = 1; s <= 3; s++)
                  Icon(Icons.star,
                      size: 11,
                      color: s <= stars ? const Color(0xFFFFC107) : const Color(0xFFCBD5E1).withValues(alpha: 0.5)),
              ],
            ),
            if (bestTimeSec != null && isCompleted)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('⏱️ ${bestTimeSec!.toStringAsFixed(1)}s',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF10B981))),
              ),
          ],
        ),
      ),
    );
  }
}
