import 'package:clerk_flutter/clerk_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'audio/sound_manager.dart';
import 'config/app_config.dart';
import 'data/quiz_database.dart';
import 'data/quiz_repository.dart';
import 'data/remote_progress_service.dart';
import 'state/quiz_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Load .env (CLERK_PUBLISHABLE_KEY, GOOGLE_SHEETS_*). Tolerate a missing file
  // so the app still boots with a "configure .env" notice.
  try {
    await AppConfig.load();
  } catch (_) {/* .env not present yet */}

  final controller = QuizController(
    repository: QuizRepository(QuizDatabase()),
    soundManager: SoundManager(),
    remote: RemoteProgressService(),
  );
  controller.start();

  // On web (debug-only target) skip Clerk: its init + the Google Sheets service
  // account flow are blocked by browser CORS and would hang the UI. Android/iOS
  // get the full Clerk + Sheets stack.
  Widget root = const MemoriseApp();
  if (AppConfig.isClerkConfigured && !kIsWeb) {
    root = ClerkAuth(
      config: ClerkAuthConfig(publishableKey: AppConfig.clerkPublishableKey),
      child: root,
    );
  }

  runApp(
    ChangeNotifierProvider.value(
      value: controller,
      child: root,
    ),
  );
}
