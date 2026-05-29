import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/presentation/widgets/game_card.dart';

void main() {
  group('GameCard widget', () {
    testWidgets('renders emoji label and stars', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GameCard(
            emoji: '🏕️',
            label: '森林寻宝',
            stars: '⭐⭐⭐',
            borderColor: Colors.orange,
            onTap: () {},
          ),
        ),
      ));
      await tester.pumpAndSettle();
      expect(find.text('🏕️'), findsOneWidget);
      expect(find.text('森林寻宝'), findsOneWidget);
      expect(find.text('⭐⭐⭐'), findsOneWidget);
    });

    testWidgets('calls onTap when tapped', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GameCard(
            emoji: '🏕️',
            label: '森林寻宝',
            stars: '⭐⭐⭐',
            borderColor: Colors.orange,
            onTap: () => tapped = true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('森林寻宝'));
      await tester.pumpAndSettle();
      expect(tapped, true);
    });

    testWidgets('disabled card does not respond to tap', (tester) async {
      bool tapped = false;
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: GameCard(
            emoji: '🔜',
            label: '更多游戏',
            stars: '即将推出',
            borderColor: Colors.grey,
            onTap: () => tapped = true,
            disabled: true,
          ),
        ),
      ));
      await tester.pumpAndSettle();
      await tester.tap(find.text('更多游戏'));
      await tester.pumpAndSettle();
      expect(tapped, false);
    });
  });
}
