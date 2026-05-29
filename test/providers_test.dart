import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kid_learn_app/presentation/providers/game_provider.dart';
import 'package:kid_learn_app/domain/entities/user_settings.dart';

void main() {
  group('Game Providers', () {
    test('learnedCountProvider default is 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(learnedCountProvider), 0);
    });

    test('englishLearnedCountProvider default is 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(englishLearnedCountProvider), 0);
    });

    test('playCountProvider default is 37', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(playCountProvider), 37);
    });

    test('totalStarsProvider default is 24', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(totalStarsProvider), 24);
    });

    test('selectedTabProvider default is 0', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      expect(container.read(selectedTabProvider), 0);
    });

    test('stickerListProvider returns 12 stickers', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final stickers = container.read(stickerListProvider);
      expect(stickers.length, 12);
    });

    test('unlockedStickersProvider default set has 3 items', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final unlocked = container.read(unlockedStickersProvider);
      expect(unlocked.length, 3);
      expect(unlocked, contains('s1'));
    });

    test('vocabularyProvider returns 50 words', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final words = container.read(vocabularyProvider);
      expect(words.length, 50);
    });

    test('learnedWordsProvider has default learned words', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final learned = container.read(learnedWordsProvider);
      expect(learned.isNotEmpty, true);
      expect(learned.length, 10);
    });
  });

  group('EyeCareState', () {
    test('default showRest is false', () {
      const state = EyeCareState();
      expect(state.showRest, false);
    });

    test('copyWith updates showRest', () {
      const state = EyeCareState();
      expect(state.copyWith(showRest: true).showRest, true);
    });

    test('copyWith updates lastActiveTime', () {
      final now = DateTime.now();
      expect(EyeCareState().copyWith(lastActiveTime: now).lastActiveTime, now);
    });
  });

  group('UserSettings', () {
    test('defaults', () {
      const s = UserSettings();
      expect(s.dailyLimitMinutes, 30);
      expect(s.eyeCareEnabled, true);
      expect(s.reminderEnabled, false);
      expect(s.reminderTime, '19:00');
    });

    test('copyWith changes single field', () {
      const s = UserSettings();
      final u = s.copyWith(reminderEnabled: true);
      expect(u.reminderEnabled, true);
      expect(u.eyeCareEnabled, true);
    });
  });
}
