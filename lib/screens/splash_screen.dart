import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../audio/sound_manager.dart';
import '../state/quiz_controller.dart';
import '../widgets/bubble_title.dart';
import '../widgets/sky_meadow_background.dart';
import '../widgets/smiling_brain.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _ctaPulse;
  late final AnimationController _brainBob;

  @override
  void initState() {
    super.initState();
    _ctaPulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
      lowerBound: 1.0,
      upperBound: 1.05,
    )..repeat(reverse: true);
    _brainBob = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
      lowerBound: 0.0,
      upperBound: 1.0,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctaPulse.dispose();
    _brainBob.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<QuizController>();
    final totalStars = vm.progressList.fold<int>(0, (s, p) => s + p.starsCount);
    final solvedStages = vm.progressList.where((p) => p.isCompleted).length;

    return Scaffold(
      body: SkyMeadowBackground(
        child: SafeArea(
          child: Column(
            children: [
              // Header: profile + stars — pinned at top
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _pill(
                      bg: Colors.white,
                      border: const Color(0xFFE2E8F0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text('🧑‍🚀', style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 6),
                          ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 120),
                            child: Text(
                              vm.currentUser?.name ?? 'Player',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF475569),
                                decoration: TextDecoration.none,
                              ),
                            ),
                          ),
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
                          Text(
                            '$totalStars',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFFB45309),
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Main content — vertically centered in remaining space
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Mascot with idle bobbing animation
                        AnimatedBuilder(
                          animation: _brainBob,
                          builder: (_, child) => Transform.translate(
                            offset: Offset(0, -6 * _brainBob.value),
                            child: child,
                          ),
                          child: const SmilingBrain(size: 140),
                        ),
                        const SizedBox(height: 12),

                        const BubbleTitle(),
                        const SizedBox(height: 4),
                        const Text(
                          'Uji Ingatanmu!',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4F46E5),
                            letterSpacing: 1,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // PLAY button — primary CTA
                        FractionallySizedBox(
                          widthFactor: 0.88,
                          child: ScaleTransition(
                            scale: _ctaPulse,
                            child: SizedBox(
                              height: 62,
                              child: ElevatedButton.icon(
                                onPressed: () =>
                                    vm.navigateTo(const LevelSelectState()),
                                icon: const Icon(
                                  Icons.play_arrow_rounded,
                                  size: 28,
                                  color: Color(0xFF78350F),
                                ),
                                label: const Text(
                                  'PLAY',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF78350F),
                                    decoration: TextDecoration.none,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFFBBF24),
                                  elevation: 6,
                                  shadowColor: const Color(
                                    0xFFB45309,
                                  ).withValues(alpha: 0.4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    side: const BorderSide(
                                      color: Color(0xFFB45309),
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 200),
                        // Secondary buttons — outline style (lower visual weight)
                        FractionallySizedBox(
                          widthFactor: 0.88,
                          child: Row(
                            children: [
                              Expanded(
                                child: _outlineButton(
                                  '💡 Panduan',
                                  () => _showPanduan(context),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _outlineButton(
                                  '⚙️ Pengaturan',
                                  () => _showPengaturan(context),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 28),

                        // Floating navigation buttons (no bar) — Trophy / Statistik / Toko
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _navButton(
                              icon: Icons.emoji_events,
                              label: 'Trophy',
                              color: const Color(0xFFB45309),
                              onTap: () {
                                context
                                    .read<QuizController>()
                                    .soundManager
                                    .playSound(SfxType.click);
                                _showTrophy(context, totalStars);
                              },
                            ),
                            const SizedBox(width: 28),
                            _navButton(
                              icon: Icons.bar_chart,
                              label: 'Statistik',
                              color: const Color(0xFF2563EB),
                              onTap: () {
                                context
                                    .read<QuizController>()
                                    .soundManager
                                    .playSound(SfxType.click);
                                _showStatistik(
                                  context,
                                  totalStars,
                                  solvedStages,
                                );
                              },
                            ),
                            const SizedBox(width: 28),
                            _navButton(
                              icon: Icons.store,
                              label: 'Toko',
                              color: const Color(0xFF7C3AED),
                              onTap: () {
                                context
                                    .read<QuizController>()
                                    .soundManager
                                    .playSound(SfxType.click);
                                _showToko(context, totalStars);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// A circular floating icon button with a label underneath (no surrounding bar).
  Widget _navButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withValues(alpha: 0.28),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E355E),
              decoration: TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill({
    required Color bg,
    required Color border,
    required Widget child,
  }) {
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

  Widget _outlineButton(String label, VoidCallback onTap) {
    return SizedBox(
      height: 44,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF1E3A8A),
          side: const BorderSide(color: Color(0xFF93C5FD), width: 1.5),
          backgroundColor: Colors.white.withValues(alpha: 0.85),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E3A8A),
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  // ---- Dialogs ----
  void _showPanduan(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('💡 ', style: TextStyle(fontSize: 22)),
            Text(
              'Cara Bermain',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            _GuideRow(
              '⚡ 1. ',
              Color(0xFFE28743),
              'Amati dan ingat susunan/letak gambar dengan teliti sebelum waktu habis!',
            ),
            SizedBox(height: 10),
            _GuideRow(
              '🧠 2. ',
              Color(0xFF9B59B6),
              'Setelah gambar disembunyikan, jawab pertanyaan berdasarkan ingatan visualmu!',
            ),
            SizedBox(height: 10),
            _GuideRow(
              '⭐ 3. ',
              Color(0xFFF1C40F),
              'Semakin cepat kamu menjawab dengan benar, semakin banyak BINTANG yang diraih!',
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK, MENGERTI!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPengaturan(BuildContext context) {
    final vm = context.read<QuizController>();
    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setLocal) => AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: const Row(
            children: [
              Text('⚙️ ', style: TextStyle(fontSize: 22)),
              Text(
                'Pengaturan Game',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A8A),
                  decoration: TextDecoration.none,
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Text('🎵  ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Musik Background',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
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
                  const Row(
                    children: [
                      Text('🔊  ', style: TextStyle(fontSize: 16)),
                      Text(
                        'Efek Suara (SFX)',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF334155),
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ],
                  ),
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
                child: Text(
                  'MANAJEMEN PROGRESS DATA:',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4F46E5),
                    decoration: TextDecoration.none,
                  ),
                ),
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
                        side: const BorderSide(
                          color: Color(0xFFEF4444),
                          width: 1.5,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Reset Data',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.none,
                        ),
                      ),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Unlock All',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Divider(color: Color(0xFFE2E8F0)),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.pop(context);
                    vm.requestSignOut();
                  },
                  icon: const Icon(
                    Icons.logout,
                    size: 16,
                    color: Color(0xFF64748B),
                  ),
                  label: const Text(
                    'Keluar Akun',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF64748B),
                      decoration: TextDecoration.none,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFCBD5E1)),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'SELESAI',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTrophy(BuildContext context, int totalStars) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFFFFFAF0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🏆 ', style: TextStyle(fontSize: 24)),
            Text(
              'Piala Kejuaraan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFFB45309),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🌟 RAJA MEMORI PINTAR 🌟',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF78350F),
                fontSize: 16,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Raih bintang terbanyak di semua level untuk menyempurnakan koleksi piala pahlawan memorimu!\n\nKamu sudah meraih $totalStars bintang dari total 90 bintang!',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF475569),
                height: 1.4,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFD54F),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'OK!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF78350F),
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showStatistik(BuildContext context, int totalStars, int solvedStages) {
    final accuracy = solvedStages > 0
        ? ((totalStars / (solvedStages * 3)) * 100).toInt()
        : 0;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('📊 ', style: TextStyle(fontSize: 22)),
            Text(
              'Statistik Bermain',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A8A),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _StatRow(
              'Bintang Terkumpul:',
              '$totalStars / 90 ⭐',
              const Color(0xFFE67E22),
            ),
            const SizedBox(height: 10),
            _StatRow(
              'Soal Terpecahkan:',
              '$solvedStages / 30 Soal',
              const Color(0xFF2ECC71),
            ),
            const SizedBox(height: 10),
            _StatRow(
              'Predikat Akurasi:',
              '$accuracy %',
              const Color(0xFF3498DB),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4CAF50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'MANTAP!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showToko(BuildContext context, int totalStars) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Text('🧸 ', style: TextStyle(fontSize: 24)),
            Text(
              'Toko Mainan',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF4A148C),
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '🚀 SKIN & MAINAN UNLOCKER 🚀',
              style: TextStyle(
                fontWeight: FontWeight.w900,
                color: Color(0xFF4A148C),
                fontSize: 14,
                decoration: TextDecoration.none,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Kumpulkan minimal 20 Bintang ⭐ untuk membuka Mainan Alien Hijau Lucu 👽!\n\nKumpulkan minimal 45 Bintang ⭐ untuk membuka Skin Kostum Astronot Super 🧑‍🚀!\n\nProgress saat ini: $totalStars Bintang.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF475569),
                height: 1.4,
                fontSize: 13,
                decoration: TextDecoration.none,
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF9B59B6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'MULAILAH KUMPULKAN!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
              ),
            ),
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
        Text(
          prefix,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: prefixColor,
            decoration: TextDecoration.none,
          ),
        ),
        Expanded(
          child: Text(
            body,
            style: const TextStyle(
              color: Color(0xFF334155),
              decoration: TextDecoration.none,
            ),
          ),
        ),
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
        Text(
          label,
          style: const TextStyle(
            color: Color(0xFF475569),
            decoration: TextDecoration.none,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontWeight: FontWeight.w900,
            color: valueColor,
            decoration: TextDecoration.none,
          ),
        ),
      ],
    );
  }
}
