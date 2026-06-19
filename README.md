# Memorise

An interactive cognitive quiz game that measures **memory, attention, and spatial
observation** skills, with kid-friendly visuals and cheerful glockenspiel audio.

This is the **Flutter** version of the game (Android **and** iOS from a single
codebase). It was migrated faithfully from the original native Android
(Kotlin + Jetpack Compose) app.

## Game overview

- 3 levels × 10 stages = **30 questions**:
  1. **Memory & Sequence** – remember & reorder sequences (15s observation).
  2. **Focus & Filter** – filter distractions, find patterns (5s observation).
  3. **Spatial Observation** – remember object positions in scenes (6s observation).
- Observation phase → answer phase (timed). Faster correct answers earn more of
  the 3 stars (`<3s → 3★`, `<7s → 2★`, else `1★`).
- Gamified score = base (500) + star bonus + speed bonus.
- Progress (best stars / fastest time / unlocks) is persisted locally with sqflite.
- All 16 question illustrations are drawn with `CustomPainter`; audio is bundled
  in `assets/audio/`.

## Project structure

```
lib/
  models/      Question + GraphicType, StageProgress
  data/        quiz_questions (30 Qs), quiz_database (sqflite), quiz_repository
  state/       quiz_controller (ChangeNotifier game logic)
  audio/       sound_manager (audioplayers)
  theme/       colors + Material 3 theme
  screens/     intro, splash, level select, stage select, gameplay, summary
  widgets/     sky meadow bg, brain mascot, confetti, quiz illustrations
assets/audio/  bgm.mp3 + click/correct/incorrect/victory/tick .wav
tool/          generate_sfx.py (regenerates the SFX wavs)
```

## Run locally

**Prerequisites:** [Flutter SDK](https://docs.flutter.dev/get-started/install)
(3.12+). For Android you need the Android SDK; for **iOS you need macOS + Xcode**.

```bash
flutter pub get
flutter run            # pick an Android emulator or iOS simulator
```

Other useful commands:

```bash
flutter analyze        # static analysis
flutter test           # unit/widget tests
flutter build apk      # Android
flutter build ios      # iOS (macOS only)
```

## Regenerating sound effects

The SFX in `assets/audio/*.wav` are generated procedurally (sine/bell-wave
synthesis ported from the original app):

```bash
python3 tool/generate_sfx.py
```
