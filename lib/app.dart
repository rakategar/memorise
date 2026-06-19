import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/gameplay_screen.dart';
import 'screens/intro_loading_screen.dart';
import 'screens/level_select_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/stage_select_screen.dart';
import 'screens/summary_screen.dart';
import 'state/quiz_controller.dart';
import 'theme/app_colors.dart';
import 'theme/app_theme.dart';

class MemoriseApp extends StatelessWidget {
  const MemoriseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Memorise',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: const _RootRouter(),
    );
  }
}

/// Drives the active screen from [QuizController.currentScreen] with a 350ms
/// crossfade, mirroring the original Compose `Crossfade` navigation router.
class _RootRouter extends StatefulWidget {
  const _RootRouter();

  @override
  State<_RootRouter> createState() => _RootRouterState();
}

class _RootRouterState extends State<_RootRouter> {
  bool _isIntroLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 1600), () {
      if (mounted) setState(() => _isIntroLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screen = context.watch<QuizController>().currentScreen;

    Widget child;
    switch (screen) {
      case SplashScreenState():
        child = _isIntroLoading
            ? const IntroLoadingScreen(key: ValueKey('intro'))
            : const SplashScreen(key: ValueKey('splash'));
      case LevelSelectState():
        child = const LevelSelectScreen(key: ValueKey('levelSelect'));
      case StageSelectState(:final levelId):
        child = StageSelectScreen(levelId: levelId, key: const ValueKey('stageSelect'));
      case GameplayState(:final levelId, :final stageId):
        child = GameplayScreen(
          levelId: levelId,
          stageId: stageId,
          key: ValueKey('gameplay_${levelId}_$stageId'),
        );
      case SummaryState(
          :final levelId,
          :final stageId,
          :final isSuccess,
          :final stars,
          :final timeSpentMs,
        ):
        child = SummaryScreen(
          levelId: levelId,
          stageId: stageId,
          isSuccess: isSuccess,
          stars: stars,
          timeSpentMs: timeSpentMs,
          key: ValueKey('summary_${levelId}_$stageId'),
        );
    }

    return Container(
      color: AppColors.background,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 350),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        child: child,
      ),
    );
  }
}
