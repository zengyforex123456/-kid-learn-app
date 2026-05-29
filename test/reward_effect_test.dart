import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/presentation/widgets/game_card.dart';

void main() {
  group('RewardEffect widget', () {
    testWidgets('renders child content', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RewardEffect(
              child: Text('reward!', style: TextStyle(fontSize: 24)),
            ),
          ),
        ),
      );
      await tester.pump();
      expect(find.text('reward!'), findsOneWidget);
    });

    testWidgets('animates from small scale', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RewardEffect(
              child: Text('test'),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 100));
      // Should have finished animation by now
      await tester.pump(const Duration(milliseconds: 600));
      expect(find.text('test'), findsOneWidget);
    });
  });
}
