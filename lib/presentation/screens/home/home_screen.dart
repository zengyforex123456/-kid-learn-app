import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/game_provider.dart';
import '../../widgets/game_card.dart';
import '../treasure_hunt/treasure_hunt_screen.dart';
import '../bubble_game/bubble_game_screen.dart';
import '../match_game/match_game_screen.dart';
import '../stickers/sticker_screen.dart';
import '../parent/parent_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stars = ref.watch(totalStarsProvider);
    final unlocked = ref.watch(unlockedStickersProvider);
    final tab = ref.watch(selectedTabProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 12),
            _TopBar(stars: stars),
            const SizedBox(height: 8),
            const Align(alignment: Alignment.centerLeft, child: Text('🌳 探险乐园', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.text))),
            const SizedBox(height: 4),
            const Align(alignment: Alignment.centerLeft, child: Text('选一个游戏开始吧！', style: TextStyle(fontSize: 16, color: AppColors.textLight))),
            const SizedBox(height: 16),
            _StickerBar(unlocked: unlocked),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
                children: [
                  GameCard(emoji: '🏕️', label: '森林寻宝', stars: '⭐⭐⭐', borderColor: const Color(0xFFFFCC80), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const TreasureHuntScreen()))),
                  GameCard(emoji: '🫧', label: '泡泡大作战', stars: '⭐⭐⭐', borderColor: const Color(0xFF90CAF9), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const BubbleGameScreen()))),
                  GameCard(emoji: '🧩', label: '配对大闯关', stars: '⭐⭐', borderColor: const Color(0xFFA5D6A7), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MatchGameScreen()))),
                  GameCard(emoji: '🔜', label: '更多游戏', stars: '即将推出', borderColor: Colors.grey.shade300, onTap: () {}, disabled: true),
                ],
              ),
            ),
          ]),
        ),
      ),
      bottomNavigationBar: _BottomNav(current: tab, onTap: (i) {
        ref.read(selectedTabProvider.notifier).state = i;
        if (i == 1) Navigator.push(context, MaterialPageRoute(builder: (_) => const StickerScreen()));
        if (i == 3) Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentGateScreen()));
      }),
    );
  }
}

class _TopBar extends StatelessWidget {
  final int stars;
  const _TopBar({required this.stars});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(width: 48, height: 48, decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle), alignment: Alignment.center, child: const Text('🐻', style: TextStyle(fontSize: 28))),
      Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]), child: Text('⭐ $stars', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700))),
      GestureDetector(onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ParentGateScreen())), child: Container(width: 48, height: 48, decoration: BoxDecoration(color: AppColors.card, shape: BoxShape.circle, boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]), alignment: Alignment.center, child: const Text('🔒', style: TextStyle(fontSize: 24)))),
    ]);
  }
}

class _StickerBar extends StatelessWidget {
  final Set<String> unlocked;
  const _StickerBar({required this.unlocked});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StickerScreen())),
      child: Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), decoration: BoxDecoration(color: AppColors.card, borderRadius: BorderRadius.circular(AppColors.radius), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)]), child: Row(children: [
        const Text('🏆 贴纸背包', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(width: 12),
        ...unlocked.take(3).map((s) => Padding(padding: const EdgeInsets.only(right: 4), child: _StickerDot(earned: true))),
        ...List.generate(3 - unlocked.length.clamp(0, 3), (_) => const Padding(padding: EdgeInsets.only(right: 4), child: _StickerDot(earned: false))),
        const Spacer(),
        Text('${unlocked.length}/12 →', style: const TextStyle(color: AppColors.textLight)),
      ])),
    );
  }
}

class _StickerDot extends StatelessWidget {
  final bool earned;
  const _StickerDot({required this.earned});

  @override
  Widget build(BuildContext context) {
    return Container(width: 40, height: 40, decoration: BoxDecoration(color: earned ? AppColors.star : Colors.grey.shade300, shape: BoxShape.circle, border: Border.all(color: earned ? AppColors.star : Colors.grey.shade400, width: 2)), alignment: Alignment.center, child: const Icon(Icons.star, size: 20, color: Colors.white));
  }
}

class _BottomNav extends StatelessWidget {
  final int current;
  final void Function(int) onTap;
  const _BottomNav({required this.current, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [('🏠', '主页'), ('⭐', '贴纸'), ('🎵', '儿歌'), ('⚙️', '设置')];
    return Container(
      decoration: BoxDecoration(color: AppColors.card, borderRadius: const BorderRadius.vertical(top: Radius.circular(AppColors.radius)), boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 12, offset: const Offset(0, -2))]),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: List.generate(4, (i) {
        return GestureDetector(
          onTap: () => onTap(i),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Text(items[i].$1, style: TextStyle(fontSize: 28, color: i == current ? AppColors.primary : null)),
            Text(items[i].$2, style: TextStyle(fontSize: 12, color: i == current ? AppColors.primary : AppColors.textLight)),
          ]),
        );
      })),
    );
  }
}
