import 'package:audioplayers/audioplayers.dart';

enum SfxType { click, correct, incorrect, victory, tick }

/// Plays bundled audio assets (BGM loop + SFX). Mirrors the role of the
/// original Kotlin `SoundManager`, but plays pre-rendered files instead of
/// synthesizing PCM at runtime.
class SoundManager {
  SoundManager() {
    _bgmPlayer.setReleaseMode(ReleaseMode.loop);
    _bgmPlayer.setVolume(0.4);
  }

  bool isSoundEnabled = true;
  bool _isMusicEnabled = true;

  bool get isMusicEnabled => _isMusicEnabled;
  set isMusicEnabled(bool value) {
    _isMusicEnabled = value;
    if (value) {
      resumeMusic();
    } else {
      pauseMusic();
    }
  }

  final AudioPlayer _bgmPlayer = AudioPlayer(playerId: 'bgm');
  // A small pool of players so overlapping SFX don't cut each other off.
  final List<AudioPlayer> _sfxPool =
      List.generate(4, (i) => AudioPlayer(playerId: 'sfx_$i'));
  int _sfxIndex = 0;
  bool _bgmStarted = false;

  static const Map<SfxType, String> _sfxAsset = {
    SfxType.click: 'audio/click.wav',
    SfxType.correct: 'audio/correct.wav',
    SfxType.incorrect: 'audio/incorrect.wav',
    SfxType.victory: 'audio/victory.wav',
    SfxType.tick: 'audio/tick.wav',
  };

  void playSound(SfxType type) {
    if (!isSoundEnabled) return;
    final asset = _sfxAsset[type];
    if (asset == null) return;
    final player = _sfxPool[_sfxIndex];
    _sfxIndex = (_sfxIndex + 1) % _sfxPool.length;
    // Fire-and-forget; ignore transient playback errors.
    player.stop().then((_) {
      player.play(AssetSource(asset), volume: 0.9);
    }).catchError((_) {});
  }

  Future<void> startBgmLoop() async {
    if (!_isMusicEnabled) return;
    try {
      if (!_bgmStarted) {
        await _bgmPlayer.play(AssetSource('audio/bgm.mp3'), volume: 0.4);
        _bgmStarted = true;
      } else {
        await _bgmPlayer.resume();
      }
    } catch (_) {
      // Ignore audio init errors (e.g. unsupported platform in tests).
    }
  }

  Future<void> pauseMusic() async {
    try {
      await _bgmPlayer.pause();
    } catch (_) {}
  }

  Future<void> resumeMusic() async {
    await startBgmLoop();
  }

  void dispose() {
    _bgmPlayer.dispose();
    for (final p in _sfxPool) {
      p.dispose();
    }
  }
}
