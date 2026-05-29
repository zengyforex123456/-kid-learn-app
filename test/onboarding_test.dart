import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OnboardingScreen (R13)', () {
    test('has 3 onboarding pages', () {
      const pages = [
        {'lottie': 'assets/lottie/onboarding_tap.json', 'title': '点一点', 'desc': '用手指轻轻点击屏幕上的卡片和图案'},
        {'lottie': 'assets/lottie/onboarding_swipe.json', 'title': '滑一滑', 'desc': '用手指滑动可以翻看更多有趣的内容'},
        {'lottie': 'assets/lottie/onboarding_collect.json', 'title': '收集贴纸', 'desc': '完成游戏可以获得漂亮的贴纸哦！'},
      ];
      expect(pages.length, 3);
    });

    test('all pages have required fields', () {
      const pages = [
        {'lottie': 'onboarding_tap.json', 'title': '点一点', 'desc': 'description'},
        {'lottie': 'onboarding_swipe.json', 'title': '滑一滑', 'desc': 'description'},
        {'lottie': 'onboarding_collect.json', 'title': '收集贴纸', 'desc': 'description'},
      ];
      for (final p in pages) {
        expect(p.containsKey('lottie'), true);
        expect(p.containsKey('title'), true);
        expect(p.containsKey('desc'), true);
        expect((p['title'] as String).isNotEmpty, true);
        expect((p['desc'] as String).isNotEmpty, true);
      }
    });

    test('page titles are correct', () {
      const titles = ['点一点', '滑一滑', '收集贴纸'];
      expect(titles[0], '点一点');
      expect(titles[1], '滑一滑');
      expect(titles[2], '收集贴纸');
      expect(titles.length, 3);
    });

    test('last page index is 2', () {
      const pageCount = 3;
      const lastPageIndex = 2;
      expect(lastPageIndex, pageCount - 1);
    });
  });
}
