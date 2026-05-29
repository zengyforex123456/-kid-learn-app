import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _page = 0;

  final _pages = const [
    {'lottie': 'assets/lottie/onboarding_tap.json', 'title': '点一点', 'desc': '用手指轻轻点击屏幕上的卡片和图案'},
    {'lottie': 'assets/lottie/onboarding_swipe.json', 'title': '滑一滑', 'desc': '用手指滑动可以翻看更多有趣的内容'},
    {'lottie': 'assets/lottie/onboarding_collect.json', 'title': '收集贴纸', 'desc': '完成游戏可以获得漂亮的贴纸哦！'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Lottie.asset(_pages[_page]['lottie']!, repeat: true),
            ),
            const SizedBox(height: 32),
            Text(_pages[_page]['title']!, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: AppColors.text)),
            const SizedBox(height: 16),
            Text(_pages[_page]['desc']!, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, color: AppColors.textLight)),
            const SizedBox(height: 48),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: List.generate(3, (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  width: 10, height: 10,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: i == _page ? AppColors.primary : Colors.grey.shade300),
                ))),
            const SizedBox(height: 32),
            SizedBox(
              width: 200, height: 64,
              child: ElevatedButton(
                onPressed: () {
                  if (_page < 2) {
                    setState(() => _page++);
                  } else {
                    Navigator.pop(context, true);
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32))),
                child: Text(_page < 2 ? '下一页' : '开始玩！', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 16),
            if (_page < 2)
              GestureDetector(
                onTap: () => Navigator.pop(context, true),
                child: const Text('跳过', style: TextStyle(fontSize: 16, color: AppColors.textLight)),
              ),
          ]),
        ),
      ),
    );
  }
}
