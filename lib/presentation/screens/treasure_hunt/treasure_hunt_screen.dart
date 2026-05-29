import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/vocabulary_data.dart';
import '../../../core/services/audio_service.dart';

class TreasureHuntScreen extends StatefulWidget {
  const TreasureHuntScreen({super.key});

  @override
  State<TreasureHuntScreen> createState() => _TreasureHuntScreenState();
}

class _TreasureHuntScreenState extends State<TreasureHuntScreen> {
  final _rng = Random();
  final _audio = AudioService();
  late final List<_HiddenCard> _cards;
  final _found = <int>{};
  bool _showReward = false;

  @override
  void initState() {
    super.initState();
    _audio.init();
    final pool = (vocabularyData.toList()..shuffle()).take(5).toList();
    _cards = pool.map((w) => _HiddenCard(word: w, x: _rng.nextDouble() * 0.6 + 0.05, y: _rng.nextDouble() * 0.55 + 0.1)).toList();
  }

  void _onFind(int id) {
    if (_found.contains(id)) return;
    setState(() {
      _found.add(id);
      _showReward = true;
    });
    final card = _cards.firstWhere((c) => c.word.id == id);
    _audio.speakWord(card.word.chinese, card.word.english);
    _audio.playCelebration();
    Future.delayed(const Duration(seconds: 1), () { if (mounted) setState(() => _showReward = false); });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          _topBar(context),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(AppColors.radius), gradient: const LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Color(0xFFC8E6C9), Color(0xFFA5D6A7), Color(0xFF81C784), Color(0xFF66BB6A)])),
                  child: Stack(
                    children: [
                      const Positioned(top: 40, left: 30, child: Text('🌳', style: TextStyle(fontSize: 60))),
                      const Positioned(top: 20, right: 40, child: Text('🌲', style: TextStyle(fontSize: 55))),
                      const Positioned(bottom: 80, left: 30, child: Text('🌴', style: TextStyle(fontSize: 50))),
                      const Positioned(bottom: 40, right: 50, child: Text('🪨', style: TextStyle(fontSize: 40))),
                      const Positioned(top: 120, right: 80, child: Text('🌻', style: TextStyle(fontSize: 36))),
                      ..._cards.where((c) => !_found.contains(c.word.id)).map((c) => Positioned(
                            left: c.x * MediaQuery.of(context).size.width,
                            top: c.y * 400,
                            child: GestureDetector(
                              onTap: () => _onFind(c.word.id),
                              child: AnimatedContainer(
                                duration: const Duration(seconds: 1),
                                curve: Curves.elasticOut,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  decoration: BoxDecoration(color: AppColors.star, borderRadius: BorderRadius.circular(AppColors.radiusSm), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.26), blurRadius: 12)]),
                                  child: Text('${c.word.emoji}\n${c.word.chinese}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
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
            child: Text('👆 在森林里找找藏起来的卡片吧！已找到: ${_found.length}/${_cards.length}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.text)),
          ),
        ]),
      ),
    );
  }

  Widget _topBar(BuildContext context) {
    return Row(children: [
      IconButton(icon: const Text('←', style: TextStyle(fontSize: 28)), onPressed: () => Navigator.pop(context)),
      const Spacer(),
      const Text('⭐ 24', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
      const SizedBox(width: 16),
    ]);
  }
}

class _HiddenCard {
  final dynamic word;
  final double x;
  final double y;
  const _HiddenCard({required this.word, required this.x, required this.y});
}
