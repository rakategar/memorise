import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/sound_manager.dart';
import '../data/quiz_questions.dart';
import '../state/quiz_controller.dart';
import '../theme/app_colors.dart';
import '../widgets/sky_meadow_background.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizController>();
    final totalStars = vm.progressList.fold<int>(0, (s, p) => s + p.starsCount);

    return SkyMeadowBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _backButton(() => vm.navigateTo(const SplashScreenState())),
                  const Text('PILIH LEVEL',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: AppColors.navyTitle, letterSpacing: 1.2)),
                  _starsPill(totalStars),
                ],
              ),
              const SizedBox(height: 24),
              for (var lvl = 1; lvl <= 3; lvl++) ...[
                _buildLevelCard(context, vm, lvl),
                const SizedBox(height: 16),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLevelCard(BuildContext context, QuizController vm, int lvl) {
    final name = QuizQuestions.levelNames[lvl] ?? '';
    final desc = QuizQuestions.levelDescriptions[lvl] ?? '';
    final levelProgress = vm.progressList.where((p) => p.levelId == lvl).toList();
    final completedCount = levelProgress.where((p) => p.isCompleted).length;
    final starsCollected = levelProgress.fold<int>(0, (s, p) => s + p.starsCount);

    final isUnlocked = lvl == 1
        ? true
        : vm.progressList.where((p) => p.levelId == lvl - 1).every((p) => p.isCompleted) ||
            levelProgress.any((p) => p.isUnlocked);

    return LevelCard(
      levelId: lvl,
      name: name,
      description: desc,
      completedCount: completedCount,
      starsCollected: starsCollected,
      isUnlocked: isUnlocked,
      onTap: () {
        if (isUnlocked) {
          vm.navigateTo(StageSelectState(lvl));
        } else {
          vm.soundManager.playSound(SfxType.incorrect);
        }
      },
    );
  }

  static Widget _backButton(VoidCallback onTap) {
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
        child: const Icon(Icons.arrow_back, color: Color(0xFF1E3A8A), size: 20),
      ),
    );
  }

  static Widget _starsPill(int totalStars) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFAED),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFFFD54F), width: 1.2),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('⭐', style: TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text('$totalStars', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
        ],
      ),
    );
  }
}

class LevelCard extends StatelessWidget {
  const LevelCard({
    super.key,
    required this.levelId,
    required this.name,
    required this.description,
    required this.completedCount,
    required this.starsCollected,
    required this.isUnlocked,
    required this.onTap,
  });

  final int levelId;
  final String name;
  final String description;
  final int completedCount;
  final int starsCollected;
  final bool isUnlocked;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.levelAccent(levelId);
    final opacity = isUnlocked ? 1.0 : 0.5;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isUnlocked ? Colors.white : const Color(0xFFF1F0F4),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isUnlocked ? accent.withValues(alpha: 0.5) : const Color(0xFFCAC4D0),
            width: 1.5,
          ),
          boxShadow: isUnlocked ? const [BoxShadow(color: Colors.black12, blurRadius: 2, offset: Offset(0, 1))] : null,
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 68,
              height: 68,
              decoration: BoxDecoration(
                color: isUnlocked ? accent.withValues(alpha: 0.15) : const Color(0xFFE1E2EC),
                borderRadius: BorderRadius.circular(18),
              ),
              alignment: Alignment.center,
              child: isUnlocked
                  ? Text('L$levelId', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: accent))
                  : const Icon(Icons.lock, color: Color(0xFF938F99)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('LEVEL $levelId',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: accent.withValues(alpha: opacity), letterSpacing: 1)),
                  Text(name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 19, fontWeight: FontWeight.bold, color: const Color(0xFF1C1B1F).withValues(alpha: opacity))),
                  const SizedBox(height: 4),
                  Text(description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 11, height: 1.35, color: const Color(0xFF49454F).withValues(alpha: opacity))),
                  if (isUnlocked && completedCount > 0)
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          const Icon(Icons.star, color: Color(0xFFFFD60A), size: 16),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              '$starsCollected/30 ⭐   |   Tuntas: $completedCount/10 Soal',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF6750A4)),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
