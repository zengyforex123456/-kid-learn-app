import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/constants/vocabulary_data.dart';
import '../../../core/services/audio_service.dart';

class MatchGameScreen extends StatefulWidget {
  const MatchGameScreen({super.key});

  @override
  State<MatchGameScreen> createState() => _MatchGameScreenState();
}

class _MatchGameScreenState extends State<MatchGameScreen> {
  final _rng = Random();
  final _audio = AudioService();
  late List<_MatchItem> _items;
  int? _selectedIndex;
  final _matched = <int>{};
  int _level = 0;

  @override
  void initState() {
    super.initState();
    _audio.init();
    _generateLevel();
  }

  void _generateLevel() {
    final pool = (vocabularyData.toList()..shuffle()).take(3 + _level).toList();
    _items = [];
    for (final w in pool) {
      if (_level == 0) {
        _items.add(_MatchItem(word: w, display: w.emoji, pairKey: '${w.id}'));
        _items.add(_MatchItem(word: w, display: w.chinese, pairKey: '${w.id}'));
      } else if (_level == 1) {
        _items.add(_MatchItem(word: w, display: w.emoji, pairKey: '${w.id}'));
        _items.add(_MatchItem(word: w, display: w.english, pairKey: '${w.id}'));
      } else {
        _items.add(_MatchItem(word: w, display: w.chinese, pairKey: '${w.id}'));
        _items.add(_MatchItem(word: w, display: w.english, pairKey: '${w.id}'));
      }
    }
    _items.shuffle(_rng);
    _selectedIndex = null;
    _matched.clear();
  }

  void _onTap(int index) {
    if (_matched.contains(index)) return;
    if (_selectedIndex == null) {
      setState(() => _selectedIndex = index);
      return;
    }
    if (_selectedIndex == index) return;

    final a = _items[_selectedIndex!];
    final b = _items[index];
    if (a.pairKey == b.pairKey && a.display != b.display) {
      _audio.playCorrect();
      _audio.speakWord(a.word.chinese, a.word.english);
      setState(() {
        _matched.addAll([_selectedIndex!, index]);
        _selectedIndex = null;
      });
      if (_matched.length == _items.length) {
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) setState(() { _level = (_level + 1) % 3; _generateLevel(); });
        });
      }
    } else {
      setState(() {
        _selectedIndex = null;
        Future.delayed(const Duration(milliseconds: 400), () {
          if (mounted) setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Row(children: [
            IconButton(icon: const Text('←', style: TextStyle(fontSize: 28)), onPressed: () => Navigator.pop(context)),
            const Spacer(),
            Text('第${_level + 1}关', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.text)),
            const SizedBox(width: 16),
          ]),
          const Padding(padding: EdgeInsets.all(8), child: Text('🔊 请配对这些卡片!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.text))),
          Expanded(
            child: GridView.count(
              crossAxisCount: _level == 2 ? 3 : 2,
              padding: const EdgeInsets.all(16),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: List.generate(_items.length, (i) {
                final item = _items[i];
                final isSelected = _selectedIndex == i;
                final isMatched = _matched.contains(i);

                return GestureDetector(
                  onTap: () => _onTap(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    decoration: BoxDecoration(
                      color: isMatched ? AppColors.accent.withValues(alpha: 0.6) : isSelected ? AppColors.star : AppColors.card,
                      borderRadius: BorderRadius.circular(AppColors.radius),
                      boxShadow: [BoxShadow(color: isSelected ? AppColors.star.withValues(alpha: 0.5) : AppColors.shadow, blurRadius: isSelected ? 20 : 8, spreadRadius: isSelected ? 4 : 0)],
                    ),
                    alignment: Alignment.center,
                    child: AnimatedScale(
                      scale: isSelected ? 1.08 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      child: Text(item.display, style: TextStyle(fontSize: _level == 2 ? 28 : 42, fontWeight: FontWeight.w700), textAlign: TextAlign.center),
                    ),
                  ),
                );
              }),
            ),
          ),
        ]),
      ),
    );
  }
}

class _MatchItem {
  final dynamic word;
  final String display;
  final String pairKey;

  _MatchItem({required this.word, required this.display, required this.pairKey});
}
