import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/presentation/providers/game_provider.dart';

void main() {
  group('EyeCareState (R8)', () {
    test('default showRest is false', () {
      const state = EyeCareState();
      expect(state.showRest, false);
    });

    test('default lastActiveTime is null', () {
      const state = EyeCareState();
      expect(state.lastActiveTime, isNull);
    });

    test('copyWith updates showRest', () {
      const state = EyeCareState();
      final updated = state.copyWith(showRest: true);
      expect(updated.showRest, true);
    });

    test('copyWith updates lastActiveTime', () {
      const state = EyeCareState();
      final now = DateTime.now();
      final updated = state.copyWith(lastActiveTime: now);
      expect(updated.lastActiveTime, now);
    });

    test('copyWith preserves other fields', () {
      final now = DateTime.now();
      const state = EyeCareState(showRest: false, lastActiveTime: null);
      final updated = state.copyWith(showRest: true);
      expect(updated.showRest, true);
      expect(updated.lastActiveTime, isNull);
    });
  });
}
