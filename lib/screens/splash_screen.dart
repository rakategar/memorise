import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/sound_manager.dart';
import '../state/quiz_controller.dart';
import '../widgets/bubble_title.dart';
import '../widgets/sky_meadow_background.dart';
import '../widgets/smiling_brain.dart';

/// Main menu: profile/stars header, mascot, PLAY + guide/settings buttons,
/// and Trophy / Statistik / Toko cards, each opening a dialog.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late final AnimationController _ctaPulse;
  late final AnimationController _brainPulse;

  @override
  void initState() {
    super.initState();
    _ctaPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 1.0,
      upperBound: 1.05,
    )..repeat(reverse: true);
    _brainPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      lowerBound: 0.96,
      upperBound: 1.04,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctaPulse.dispose();
    _brainPulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizController>();
    final totalStars = vm.progressList.fold<int>(0, (s, p) => s + p.starsCount);
    final solvedStages = vm.progressList.where((p) => p.isCompleted).length;

    return SkyMeadowBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header: profile + stars
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _pill(
                    bg: Colors.white,
                    border: const Color(0xFFE2E8F0),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🧑‍🚀', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 6),
                        Text('Player',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF475569))),
                      ],
                    ),
                  ),
                  _pill(
                    bg: const Color(0xFFFFFAED),
                    border: const Color(0xFFFFD54F),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 16)),
                        const SizedBox(width: 6),
                        Text('$totalStars',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Color(0xFFB45309))),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // Center mascot + title
              ScaleTransition(scale: _brainPulse, child: const SmilingBrain(size: 150)),
              const SizedBox(height: 14),
              const BubbleTitle(),
              const SizedBox(height: 4),
              const Text(
                'Uji Ingatanmu!',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF4F46E5), letterSpacing: 1),
              ),
              const SizedBox(height: 28),
              // PLAY button
              FractionallySizedBox(
                widthFactor: 0.9,
                child: ScaleTransition(
                  scale: _ctaPulse,
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () => vm.navigateTo(const LevelSelectState()),
                      style: _btnStyle(const Color(0xFFFBBF24), 22, const Color(0xFFB45309), 2.5),
                      child: const Text('PLAY',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF78350F))),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              FractionallySizedBox(
                widthFactor: 0.9,
                child: Row(
                  children: [
                    Expanded(child: _menuButton('PANDUAN', () => _showPanduan(context))),
                    const SizedBox(width: 12),
                    Expanded(child: _menuButton('PENGATURAN', () => _showPengaturan(context))),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              // Lower cards
              Row(
                children: [
                  Expanded(child: _infoCard('🏆', 'TROPHY', () => _showTrophy(context, totalStars))),
                  const SizedBox(width: 10),
                  Expanded(child: _infoCard('📊', 'STATISTIK', () => _showStatistik(context, totalStars, solvedStages))),
                  const SizedBox(width: 10),
                  Expanded(child: _infoCard('🧸', 'TOKO', () => _showToko(context, totalStars))),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---- small UI helpers ----
  Widget _pill({required Color bg, required Color border, required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border, width: 1.5),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: child,
    );
  }

  ButtonStyle _btnStyle(Color bg, double radius, Color border, double borderW) {
    return ElevatedButton.styleFrom(
      backgroundColor: bg,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
        side: BorderSide(color: border, width: borderW),
      ),
    );
  }

  Widget _menuButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2563EB),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Color(0xFF1E3A8A), width: 1.5),
          ),
        ),
        child: Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: Colors.white)),
      ),
    );
  }

  Widget _infoCard(String emoji, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 82,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFCBD5E1), width: 1.2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF1E3A8A))),
          ],
        ),
      ),
    );
  }

  // ---- Dialogs ----
  void _showPanduan(BuildContext context) {
    context.read<QuizController>().soundManager.playSound(SfxType.click);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(children: [
          Text('💡 ', style: TextStyle(fontSize: 22)),
          Text('Cara Bermain', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _GuideRow('⚡ 1. ', Color(0xFFE28743), 'Amati dan ingat susunan/letak gambar dengan teliti sebelum waktu habis!'),
            SizedBox(height: 10),
            _GuideRow('🧠 2. ', Color(0xFF9B59B6), 'Setelah gambar disembunyikan, jawab pertanyaan berdasarkan ingatan visualmu!'),
            SizedBox(height: 10),
            _GuideRow('⭐ 3. ', Color(0xFFF1C40F), 'Semakin cepat kamu menjawab dengan benar, semakin banyak BINTANG yang diraih!'),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('OK, MENGERTI!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showPengaturan(BuildContext context) {
    final vm = context.read<QuizController>();
    vm.soundManager.playSound(SfxType.click);
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: const Row(children: [
            Text('⚙️ ', style: TextStyle(fontSize: 22)),
            Text('Pengaturan Game', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
          ]),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [
                    Text('🎵  ', style: TextStyle(fontSize: 16)),
                    Text('Musik Background', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  ]),
                  Switch(
                    value: vm.soundManager.isMusicEnabled,
                    onChanged: (_) {
                      vm.toggleMusic();
                      setLocal(() {});
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(children: [
                    Text('🔊  ', style: TextStyle(fontSize: 16)),
                    Text('Efek Suara (SFX)', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155))),
                  ]),
                  Switch(
                    value: vm.soundManager.isSoundEnabled,
                    onChanged: (_) {
                      vm.toggleSound();
                      setLocal(() {});
                    },
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE2E8F0)),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text('MANAJEMEN PROGRESS DATA:',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: Color(0xFF4F46E5))),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        vm.resetGame();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFFEF4444),
                        side: const BorderSide(color: Color(0xFFEF4444), width: 1.5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Reset Data', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        vm.unlockAll();
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6366F1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Unlock All',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('SELESAI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrophy(BuildContext context, int totalStars) {
    context.read<QuizController>().soundManager.playSound(SfxType.click);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFAF0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(children: [
          Text('🏆 ', style: TextStyle(fontSize: 24)),
          Text('Piala Kejuaraan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFB45309))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🌟 RAJA MEMORI PINTAR 🌟',
                style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF78350F), fontSize: 16)),
            const SizedBox(height: 8),
            Text(
              'Raih bintang terbanyak di semua level untuk menyempurnakan koleksi piala pahlawan memorimu! \n\nKamu sudah meraih $totalStars bintang dari total 90 bintang!',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF475569), height: 1.4, fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD54F),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('OK!', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF78350F))),
          ),
        ],
      ),
    );
  }

  void _showStatistik(BuildContext context, int totalStars, int solvedStages) {
    context.read<QuizController>().soundManager.playSound(SfxType.click);
    final accuracy = solvedStages > 0 ? ((totalStars / (solvedStages * 3)) * 100).toInt() : 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(children: [
          Text('📊 ', style: TextStyle(fontSize: 22)),
          Text('Statistik Bermain', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E3A8A))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatRow('Bintang Terkumpul:', '$totalStars / 90 ⭐', Color(0xFFE67E22)),
            const SizedBox(height: 10),
            _StatRow('Soal Terpecahkan:', '$solvedStages / 30 Soal', const Color(0xFF2ECC71)),
            const SizedBox(height: 10),
            _StatRow('Predikat Akurasi:', '$accuracy %', const Color(0xFF3498DB)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('MANTAP!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showToko(BuildContext context, int totalStars) {
    context.read<QuizController>().soundManager.playSound(SfxType.click);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(children: [
          Text('🧸 ', style: TextStyle(fontSize: 24)),
          Text('Toko Mainan', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4A148C))),
        ]),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🚀 SKIN & MAINAN UNLOCKER 🚀',
                style: TextStyle(fontWeight: FontWeight.w900, color: Color(0xFF4A148C), fontSize: 14)),
            const SizedBox(height: 10),
            Text(
              'Kumpulkan minimal 20 Bintang ⭐ untuk membuka Mainan Alien Hijau Lucu 👽!\n\nKumpulkan minimal 45 Bintang ⭐ untuk membuka Skin Kostum Astronot Super 🧑‍🚀!\n\nProgress saat ini: $totalStars Bintang.',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Color(0xFF475569), height: 1.4, fontSize: 13),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B59B6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('MULAILAH KUMPULKAN!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class _GuideRow extends StatelessWidget {
  const _GuideRow(this.prefix, this.prefixColor, this.body);
  final String prefix;
  final Color prefixColor;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(prefix, style: TextStyle(fontWeight: FontWeight.bold, color: prefixColor)),
        Expanded(child: Text(body, style: const TextStyle(color: Color(0xFF334155)))),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow(this.label, this.value, this.valueColor);
  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF475569))),
        Text(value, style: TextStyle(fontWeight: FontWeight.w900, color: valueColor)),
      ],
    );
  }
}
