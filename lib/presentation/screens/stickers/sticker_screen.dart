import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../providers/game_provider.dart';
import '../../../core/constants/vocabulary_data.dart' show stickerData;

class StickerScreen extends ConsumerWidget {
  const StickerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(unlockedStickersProvider);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            const SizedBox(height: 12),
            Row(children: [
              GestureDetector(child: const Text('←', style: TextStyle(fontSize: 28)), onTap: () => Navigator.pop(context)),
              const SizedBox(width: 12),
              const Text('🏆 贴纸背包', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.text)),
            ]),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 1.0,
                children: stickerData.map((s) {
                  final earned = unlocked.contains(s['id']);
                  return Container(
                    decoration: BoxDecoration(
                      color: earned ? const Color(0xFFFFF9C4) : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(AppColors.radiusSm),
                      border: Border.all(color: earned ? AppColors.star : Colors.grey.shade300, width: 2),
                    ),
                    alignment: Alignment.center,
                    child: Opacity(
                      opacity: earned ? 1.0 : 0.4,
                      child: Column(mainAxisSize: MainAxisSize.min, children: [
                        Text(s['emoji']!, style: const TextStyle(fontSize: 48)),
                        const SizedBox(height: 4),
                        Text(earned ? '已收集' : '🔒', style: TextStyle(fontSize: 12, color: earned ? AppColors.accent : Colors.grey)),
                      ]),
                    ),
                  );
                }).toList(),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text('完成更多游戏收集贴纸！', style: TextStyle(fontSize: 18, color: AppColors.textLight)),
            ),
          ]),
        ),
      ),
    );
  }
}
