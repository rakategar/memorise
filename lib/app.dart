import 'package:clerk_flutter/clerk_flutter.dart' as clerk;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/app_config.dart';
import 'models/app_user.dart';
import 'screens/gameplay_screen.dart';
import 'screens/intro_loading_screen.dart';
import 'screens/level_select_screen.dart';
import 'screens/sign_in_screen.dart';
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
      home: const _AuthGate(),
    );
  }
}

/// Gates the game behind Clerk authentication. Shows a config notice when keys
/// are missing, the sign-in screen when signed out, and the game when signed in.
class _AuthGate extends StatelessWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context) {
    if (!AppConfig.isClerkConfigured) {
      return const _ConfigNeededScreen();
    }
    return clerk.ClerkErrorListener(
      child: clerk.ClerkAuthBuilder(
        signedOutBuilder: (context, authState) => const SignInScreen(),
        signedInBuilder: (context, authState) => _AuthenticatedRoot(authState: authState),
      ),
    );
  }
}

class _AuthenticatedRoot extends StatefulWidget {
  const _AuthenticatedRoot({required this.authState});
  final clerk.ClerkAuthState authState;

  @override
  State<_AuthenticatedRoot> createState() => _AuthenticatedRootState();
}

class _AuthenticatedRootState extends State<_AuthenticatedRoot> {
  String? _syncedUserId;

  AppUser? _appUser() {
    final u = widget.authState.user;
    if (u == null) return null;
    final fullName = u.name.trim();
    final email = u.email ?? '';
    return AppUser(
      id: u.id,
      email: email,
      name: fullName.isNotEmpty ? fullName : (email.isNotEmpty ? email : 'Player'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.read<QuizController>();
    final user = _appUser();

    if (user != null && _syncedUserId != user.id) {
      _syncedUserId = user.id;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.signOutHandler = () async {
          await widget.authState.signOut();
          controller.onSignedOut();
          if (mounted) setState(() => _syncedUserId = null);
        };
        controller.onUserSignedIn(user);
      });
    }

    final vm = context.watch<QuizController>();
    if (user == null || vm.currentUser == null || vm.isSyncing) {
      return const _SyncingScreen();
    }
    return const _RootRouter();
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

class _SyncingScreen extends StatelessWidget {
  const _SyncingScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: Color(0xFF3B82F6)),
          SizedBox(height: 16),
          Text('Menyiapkan progresmu...',
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF475569))),
        ],
      ),
    );
  }
}

class _ConfigNeededScreen extends StatelessWidget {
  const _ConfigNeededScreen();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.background,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(28),
      child: const Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('⚙️', style: TextStyle(fontSize: 44)),
          SizedBox(height: 12),
          Text('Konfigurasi diperlukan',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E355E))),
          SizedBox(height: 8),
          Text(
            'Isi CLERK_PUBLISHABLE_KEY (dan GOOGLE_SHEETS_*) di file .env, '
            'lalu jalankan ulang aplikasi. Lihat .env.example.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: Color(0xFF475569), height: 1.4),
          ),
        ],
      ),
    );
  }
}
