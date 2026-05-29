import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/presentation/screens/treasure_hunt/treasure_hunt_screen.dart';
import 'package:kid_learn_app/presentation/screens/bubble_game/bubble_game_screen.dart';
import 'package:kid_learn_app/presentation/screens/match_game/match_game_screen.dart';

Widget _wrap(Widget child) => ProviderScope(child: MaterialApp(home: child));

void main() {
  group('TreasureHuntScreen (R2)', () {
    testWidgets('shows forest scene with cards', (tester) async {
      await tester.pumpWidget(_wrap(const TreasureHuntScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('在森林里找找藏起来的卡片吧'), findsOneWidget);
      expect(find.textContaining('已找到: 0/5'), findsOneWidget);
    });

    testWidgets('has back button', (tester) async {
      await tester.pumpWidget(_wrap(const TreasureHuntScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('←'), findsOneWidget);
    });

    testWidgets('shows score display', (tester) async {
      await tester.pumpWidget(_wrap(const TreasureHuntScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('⭐'), findsWidgets);
    });
  });

  group('BubbleGameScreen (R3)', () {
    testWidgets('shows target word hint', (tester) async {
      await tester.pumpWidget(_wrap(const BubbleGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('请找到'), findsOneWidget);
    });

    testWidgets('has back button', (tester) async {
      await tester.pumpWidget(_wrap(const BubbleGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('←'), findsOneWidget);
    });

    testWidgets('shows score display', (tester) async {
      await tester.pumpWidget(_wrap(const BubbleGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('⭐'), findsWidgets);
    });
  });

  group('MatchGameScreen (R4)', () {
    testWidgets('shows level indicator', (tester) async {
      await tester.pumpWidget(_wrap(const MatchGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('第'), findsOneWidget);
      expect(find.textContaining('关'), findsOneWidget);
    });

    testWidgets('shows instruction', (tester) async {
      await tester.pumpWidget(_wrap(const MatchGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.textContaining('请配对这些卡片'), findsOneWidget);
    });

    testWidgets('has back button', (tester) async {
      await tester.pumpWidget(_wrap(const MatchGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('←'), findsOneWidget);
    });

    testWidgets('shows matching cards grid', (tester) async {
      await tester.pumpWidget(_wrap(const MatchGameScreen()));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.byType(GestureDetector), findsWidgets);
    });
  });
}
