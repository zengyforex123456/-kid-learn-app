import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/presentation/screens/home/home_screen.dart';

Widget _wrap(Widget child) => ProviderScope(child: MaterialApp(home: child));

void main() {
  group('HomeScreen (R1)', () {
    testWidgets('shows app title', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('探险乐园'), findsOneWidget);
    });

    testWidgets('shows subtitle hint', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('选一个游戏开始吧'), findsOneWidget);
    });

    testWidgets('shows star count', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('⭐'), findsWidgets);
    });

    testWidgets('shows all 4 game cards', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('森林寻宝'), findsOneWidget);
      expect(find.text('泡泡大作战'), findsOneWidget);
      expect(find.text('配对大闯关'), findsOneWidget);
      expect(find.text('更多游戏'), findsOneWidget);
    });

    testWidgets('shows sticker bar', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.textContaining('贴纸背包'), findsOneWidget);
    });

    testWidgets('shows bottom navigation', (tester) async {
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('主页'), findsOneWidget);
      expect(find.text('贴纸'), findsOneWidget);
    });

    testWidgets('more games card disabled', (tester) async {
      tester.view.physicalSize = const Size(800, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());
      await tester.pumpWidget(_wrap(const HomeScreen()));
      await tester.pumpAndSettle();
      expect(find.text('即将推出'), findsOneWidget);
    });

  });
}
