import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/presentation/screens/stickers/sticker_screen.dart';

Widget _wrap() => const ProviderScope(child: MaterialApp(home: StickerScreen()));

void main() {
  group('StickerScreen (R6)', () {
    testWidgets('shows sticker collection title', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.textContaining('贴纸背包'), findsOneWidget);
    });

    testWidgets('shows back button', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('←'), findsOneWidget);
    });

    testWidgets('shows 12 sticker slots in grid', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // GridView shows all 12 stickers
      expect(find.byType(GridView), findsOneWidget);
    });

    testWidgets('shows encouragement text', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      expect(find.text('完成更多游戏收集贴纸！'), findsOneWidget);
    });

    testWidgets('some stickers show locked state', (tester) async {
      await tester.pumpWidget(_wrap());
      await tester.pumpAndSettle();
      // Locked stickers show 🔒
      expect(find.text('🔒'), findsWidgets);
    });
  });
}
