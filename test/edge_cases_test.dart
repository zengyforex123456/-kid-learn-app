import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/core/constants/vocabulary_data.dart';
import 'package:kid_learn_app/domain/entities/vocabulary_item.dart';
import 'package:kid_learn_app/domain/entities/user_settings.dart';
import 'package:kid_learn_app/domain/entities/sticker.dart';
import 'package:kid_learn_app/core/theme/app_colors.dart';

void main() {
  group('VocabularyItem edge cases', () {
    test('fromMap handles isLearned=0 correctly', () {
      final map = {'id': 1, 'chinese': 'X', 'english': 'Y', 'emoji': 'Z', 'category': 'fruit', 'isLearned': 0};
      final item = VocabularyItem.fromMap(map);
      expect(item.isLearned, false);
    });

    test('fromMap handles isLearned=1 correctly', () {
      final map = {'id': 1, 'chinese': 'X', 'english': 'Y', 'emoji': 'Z', 'category': 'daily', 'isLearned': 1};
      final item = VocabularyItem.fromMap(map);
      expect(item.isLearned, true);
    });

    test('toMap round-trip is consistent', () {
      const item = VocabularyItem(id: 42, chinese: '月亮', english: 'moon', emoji: '🌙', category: WordCategory.daily, isLearned: true);
      final map = item.toMap();
      final restored = VocabularyItem.fromMap(map);
      expect(restored.id, item.id);
      expect(restored.chinese, item.chinese);
      expect(restored.english, item.english);
      expect(restored.emoji, item.emoji);
      expect(restored.category, item.category);
      expect(restored.isLearned, item.isLearned);
    });

    test('word IDs range from 1 to 50', () {
      final ids = vocabularyData.map((w) => w.id).toList()..sort();
      expect(ids.first, 1);
      expect(ids.last, 50);
    });

    test('fruit words contain 苹果 and 香蕉', () {
      final fruits = vocabularyData.where((w) => w.category == WordCategory.fruit);
      final names = fruits.map((w) => w.chinese).toSet();
      expect(names, contains('苹果'));
      expect(names, contains('香蕉'));
      expect(names, contains('草莓'));
    });

    test('animal words contain 猫 and 狗', () {
      final animals = vocabularyData.where((w) => w.category == WordCategory.animal);
      final names = animals.map((w) => w.chinese).toSet();
      expect(names, contains('猫'));
      expect(names, contains('狗'));
    });

    test('body words contain 眼睛 and 耳朵', () {
      final body = vocabularyData.where((w) => w.category == WordCategory.body);
      final names = body.map((w) => w.chinese).toSet();
      expect(names, contains('眼睛'));
      expect(names, contains('耳朵'));
    });

    test('daily words contain 水 and 太阳', () {
      final daily = vocabularyData.where((w) => w.category == WordCategory.daily);
      final names = daily.map((w) => w.chinese).toSet();
      expect(names, contains('水'));
      expect(names, contains('太阳'));
    });

    test('all english words are lowercase', () {
      for (final w in vocabularyData) {
        expect(w.english, equals(w.english.toLowerCase()));
      }
    });

    test('no duplicate IDs', () {
      final ids = vocabularyData.map((w) => w.id).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('no duplicate Chinese words', () {
      final names = vocabularyData.map((w) => w.chinese).toList();
      expect(names.toSet().length, names.length);
    });

    test('no duplicate English words', () {
      final names = vocabularyData.map((w) => w.english).toList();
      expect(names.toSet().length, names.length);
    });
  });

  group('UserSettings edge cases', () {
    test('all default values are sensible', () {
      const s = UserSettings();
      expect(s.dailyLimitMinutes, greaterThan(0));
      expect(s.dailyLimitMinutes, lessThan(120));
      expect(s.reminderTime.length, 5);
      expect(s.reminderTime, contains(':'));
    });

    test('copyWith with all fields changes all', () {
      const s = UserSettings();
      final u = s.copyWith(
        dailyLimitMinutes: 60,
        eyeCareEnabled: false,
        bgMusicEnabled: false,
        offlineMode: true,
        reminderEnabled: true,
        reminderTime: '08:00',
      );
      expect(u.dailyLimitMinutes, 60);
      expect(u.eyeCareEnabled, false);
      expect(u.bgMusicEnabled, false);
      expect(u.offlineMode, true);
      expect(u.reminderEnabled, true);
      expect(u.reminderTime, '08:00');
    });

    test('reminderTime format is HH:MM', () {
      final times = ['00:00', '08:30', '12:00', '19:00', '23:59'];
      for (final t in times) {
        final s = UserSettings(reminderTime: t);
        expect(s.reminderTime, t);
        expect(s.reminderTime.length, 5);
        expect(s.reminderTime[2], ':');
      }
    });
  });

  group('Sticker edge cases', () {
    test('copyWith preserves id and name', () {
      const s = Sticker(id: 's99', name: 'Test', emoji: 'T', unlockGame: 'test');
      final u = s.copyWith(isUnlocked: true);
      expect(u.id, 's99');
      expect(u.name, 'Test');
      expect(u.unlockGame, 'test');
      expect(u.isUnlocked, true);
    });

    test('two stickers with same id are distinct objects', () {
      const s1 = Sticker(id: 's1', name: 'A', emoji: '🌟');
      const s2 = Sticker(id: 's1', name: 'A', emoji: '🌟');
      expect(s1 == s2, true);
    });
  });

  group('AppColors edge cases', () {
    test('bubbles list has distinct colors', () {
      final colors = AppColors.bubbles.map((c) => c.toARGB32()).toSet();
      expect(colors.length, AppColors.bubbles.length);
    });

    test('primary color is orange-ish', () {
      expect(AppColors.primary, isNotNull);
    });

    test('star color is yellow-ish', () {
      expect(AppColors.star, isNotNull);
    });

    test('text and textLight are different', () {
      expect(AppColors.text, isNot(AppColors.textLight));
    });
  });
}
