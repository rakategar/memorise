import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'audio/sound_manager.dart';
import 'data/quiz_database.dart';
import 'data/quiz_repository.dart';
import 'state/quiz_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  final repository = QuizRepository(QuizDatabase());
  final soundManager = SoundManager();
  final controller = QuizController(
    repository: repository,
    soundManager: soundManager,
  );
  // Seed DB, load progress, and start BGM.
  controller.init();

  runApp(
    ChangeNotifierProvider.value(
      value: controller,
      child: const MemoriseApp(),
    ),
  );
}
