import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/domain/entities/vocabulary_item.dart';
import 'package:kid_learn_app/domain/entities/user_settings.dart';
import 'package:kid_learn_app/domain/entities/sticker.dart';

void main() {
  group('VocabularyItem', () {
    test('constructor sets all fields correctly', () {
      const item = VocabularyItem(
        id: 1,
        chinese: '苹果',
        english: 'apple',
        emoji: '🍎',
        category: WordCategory.fruit,
      );
      expect(item.id, 1);
      expect(item.chinese, '苹果');
      expect(item.english, 'apple');
      expect(item.emoji, '🍎');
      expect(item.category, WordCategory.fruit);
      expect(item.isLearned, false);
    });

    test('copyWith toggles isLearned', () {
      const item = VocabularyItem(id: 1, chinese: '苹果', english: 'apple', emoji: '🍎', category: WordCategory.fruit);
      final learned = item.copyWith(isLearned: true);
      expect(learned.isLearned, true);
      expect(item.isLearned, false);
    });

    test('toMap produces correct map', () {
      const item = VocabularyItem(id: 5, chinese: '草莓', english: 'strawberry', emoji: '🍓', category: WordCategory.fruit);
      final map = item.toMap();
      expect(map['id'], 5);
      expect(map['chinese'], '草莓');
      expect(map['english'], 'strawberry');
      expect(map['category'], 'fruit');
      expect(map['isLearned'], 0);
    });

    test('fromMap creates correct instance', () {
      final map = {'id': 13, 'chinese': '猫', 'english': 'cat', 'emoji': '🐱', 'category': 'animal', 'isLearned': 1};
      final item = VocabularyItem.fromMap(map);
      expect(item.id, 13);
      expect(item.chinese, '猫');
      expect(item.english, 'cat');
      expect(item.category, WordCategory.animal);
      expect(item.isLearned, true);
    });

    test('fromMap throws for invalid category', () {
      final map = {'id': 1, 'chinese': 'X', 'english': 'X', 'emoji': 'X', 'category': 'invalid', 'isLearned': 0};
      expect(() => VocabularyItem.fromMap(map), throwsA(isA<StateError>()));
    });
  });

  group('UserSettings', () {
    test('default values', () {
      const s = UserSettings();
      expect(s.dailyLimitMinutes, 30);
      expect(s.eyeCareEnabled, true);
      expect(s.bgMusicEnabled, true);
      expect(s.offlineMode, false);
      expect(s.reminderEnabled, false);
      expect(s.reminderTime, '19:00');
    });

    test('copyWith updates single field', () {
      const s = UserSettings();
      final updated = s.copyWith(dailyLimitMinutes: 45);
      expect(updated.dailyLimitMinutes, 45);
      expect(updated.eyeCareEnabled, true);
    });

    test('copyWith updates multiple fields', () {
      const s = UserSettings();
      final updated = s.copyWith(reminderEnabled: true, reminderTime: '08:30');
      expect(updated.reminderEnabled, true);
      expect(updated.reminderTime, '08:30');
    });

    test('copyWith preserves unchanged fields', () {
      const s = UserSettings(reminderEnabled: true, reminderTime: '20:00');
      final updated = s.copyWith(eyeCareEnabled: false);
      expect(updated.reminderEnabled, true);
      expect(updated.reminderTime, '20:00');
      expect(updated.eyeCareEnabled, false);
    });
  });

  group('Sticker', () {
    test('constructor sets fields correctly', () {
      const s = Sticker(id: 's1', name: '探险家', emoji: '🌟');
      expect(s.id, 's1');
      expect(s.name, '探险家');
      expect(s.emoji, '🌟');
      expect(s.isUnlocked, false);
    });

    test('copyWith toggles unlock state', () {
      const s = Sticker(id: 's1', name: '探险家', emoji: '🌟');
      final unlocked = s.copyWith(isUnlocked: true);
      expect(unlocked.isUnlocked, true);
      expect(s.isUnlocked, false);
    });

    test('unlockGame is nullable', () {
      const s = Sticker(id: 's1', name: 'X', emoji: 'X');
      expect(s.unlockGame, isNull);
      const s2 = Sticker(id: 's2', name: 'Y', emoji: 'Y', unlockGame: 'treasure');
      expect(s2.unlockGame, 'treasure');
    });
  });
}
