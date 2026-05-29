import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/vocabulary_data.dart';
import '../../../core/services/audio_service.dart';

class BubbleGameScreen extends StatefulWidget {
  const BubbleGameScreen({super.key});

  @override
  State<BubbleGameScreen> createState() => _BubbleGameScreenState();
}

class _BubbleGameScreenState extends State<BubbleGameScreen> with TickerProviderStateMixin {
  final _rng = Random();
  final _audio = AudioService();
  late List<_Bubble> _bubbles;
  late Map<String, dynamic> _target;
  int _score = 0;
  int _misses = 0;
  bool _showReward = false;

  @override
  void initState() {
    super.initState();
    _audio.init();
    _spawnRound();
  }

  void _spawnRound() {
    final pool = (vocabularyData.toList()..shuffle()).take(6).toList();
    _bubbles = pool.map((w) => _Bubble(
          word: w,
          x: _rng.nextDouble() * 0.7 + 0.02,
          y: _rng.nextDouble() * 0.65 + 0.05,
          size: _rng.nextDouble() * 40 + 70,
          color: AppColors.bubbles[_rng.nextInt(4)],
          animCtrl: AnimationController(vsync: this, duration: Duration(seconds: _rng.nextInt(2) + 2))..repeat(reverse: true),
        )).toList();
    _target = {'chinese': pool[_rng.nextInt(6)].chinese, 'english': pool[_rng.nextInt(6)].english};
    _audio.speakChinese(_target['chinese'] as String);
  }

  void _onPop(_Bubble bubble) {
    if (bubble.popped) return;
    setState(() => bubble.popped = true);
    bubble.animCtrl.dispose();

    if (bubble.word.chinese == _target['chinese'] || bubble.word.english == _target['english']) {
      _score++;
      _showReward = true;
      _audio.playCelebration();
      _audio.speakWord(bubble.word.chinese, bubble.word.english);
      Future.delayed(const Duration(milliseconds: 600), () { if (mounted) setState(() => _showReward = false); });
      if (_score >= 3) {
        Future.delayed(const Duration(seconds: 1), () { if (mounted) _spawnRound(); });
      }
    } else {
      _misses++;
      _audio.playWrong();
      if (_misses >= 3 && _bubbles.every((b) => b.popped || (b.word.chinese != _target['chinese'] && b.word.english != _target['english']))) {
        Future.delayed(const Duration(seconds: 1), () => _spawnRound());
      }
    }
  }

  @override
  void dispose() {
    for (final b in _bubbles) { b.animCtrl.dispose(); }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(children: [
            IconButton(icon: const Text('←', style: TextStyle(fontSize: 28)), onPressed: () => Navigator.pop(context)),
            const Spacer(),
            Text('⭐ $_score', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(width: 16),
          ]),
          Expanded(
            child: Stack(
              children: [
                Container(margin: const EdgeInsets.symmetric(horizontal: 16), decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppColors.radius), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFE3F2FD), Color(0xFFBBDEFB), Color(0xFF90CAF9)]))),
                ..._bubbles.where((b) => !b.popped).map((b) => AnimatedBuilder(
                      animation: b.animCtrl,
                      builder: (_, child) => Positioned(
                        left: b.x * MediaQuery.of(context).size.width,
                        top: b.y * 450 + b.animCtrl.value * 10,
                        child: GestureDetector(
                          onTap: () => _onPop(b),
                          child: Container(
                            width: b.size, height: b.size,
                            decoration: BoxDecoration(color: b.color, shape: BoxShape.circle, boxShadow: [BoxShadow(blurRadius: 12, color: Colors.black.withValues(alpha: 0.15))]),
                            alignment: Alignment.center,
                            child: Text('${b.word.emoji}\n${b.word.chinese}', textAlign: TextAlign.center, style: TextStyle(fontSize: b.size * 0.22, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ),
                    )),
                if (_showReward)
                  Positioned.fill(
                    child: Center(
                      child: Lottie.asset('assets/lottie/celebration.json', width: 200, height: 200, repeat: false),
                    ),
                  ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.9), borderRadius: BorderRadius.circular(AppColors.radius)),
            child: Text('🔊 请找到: ${_target['chinese']} / ${_target['english']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
          ),
        ]),
      ),
    );
  }
}

class _Bubble {
  final dynamic word;
  final double x, y, size;
  final Color color;
  final AnimationController animCtrl;
  bool popped = false;

  _Bubble({required this.word, required this.x, required this.y, required this.size, required this.color, required this.animCtrl});
}
