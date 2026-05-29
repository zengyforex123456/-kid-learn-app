import 'package:flutter_test/flutter_test.dart';
import 'package:kid_learn_app/core/constants/vocabulary_data.dart';
import 'package:kid_learn_app/domain/entities/vocabulary_item.dart';

void main() {
  group('Vocabulary data', () {
    test('has 50 words', () {
      expect(vocabularyData.length, 50);
    });

    test('all words have unique IDs', () {
      final ids = vocabularyData.map((w) => w.id).toSet();
      expect(ids.length, vocabularyData.length);
    });

    test('all words have non-empty chinese', () {
      for (final w in vocabularyData) {
        expect(w.chinese.isNotEmpty, true, reason: 'Word ${w.id} has empty chinese');
      }
    });

    test('all words have non-empty english', () {
      for (final w in vocabularyData) {
        expect(w.english.isNotEmpty, true, reason: 'Word ${w.id} has empty english');
      }
    });

    test('all words have non-empty emoji', () {
      for (final w in vocabularyData) {
        expect(w.emoji.isNotEmpty, true, reason: 'Word ${w.id} has empty emoji');
      }
    });

    test('categories are distributed', () {
      final categories = vocabularyData.map((w) => w.category).toSet();
      expect(categories.length, 4);
      expect(categories, containsAll([WordCategory.fruit, WordCategory.animal, WordCategory.body, WordCategory.daily]));
    });

    test('fruit category has at least 10 words', () {
      final fruits = vocabularyData.where((w) => w.category == WordCategory.fruit);
      expect(fruits.length, greaterThanOrEqualTo(10));
    });

    test('animal category has at least 10 words', () {
      final animals = vocabularyData.where((w) => w.category == WordCategory.animal);
      expect(animals.length, greaterThanOrEqualTo(10));
    });

    test('body category has at least 8 words', () {
      final body = vocabularyData.where((w) => w.category == WordCategory.body);
      expect(body.length, greaterThanOrEqualTo(8));
    });

    test('daily category has at least 10 words', () {
      final daily = vocabularyData.where((w) => w.category == WordCategory.daily);
      expect(daily.length, greaterThanOrEqualTo(10));
    });

    test('no word has empty chinese or english', () {
      for (final w in vocabularyData) {
        expect(w.chinese.trim().isEmpty, false);
        expect(w.english.trim().isEmpty, false);
      }
    });
  });

  group('Sticker data', () {
    test('has 12 stickers', () {
      expect(stickerData.length, 12);
    });

    test('all stickers have required fields', () {
      for (final s in stickerData) {
        expect(s.containsKey('id'), true);
        expect(s.containsKey('name'), true);
        expect(s.containsKey('emoji'), true);
        expect(s.containsKey('unlock'), true);
        expect(s['id']!.isNotEmpty, true);
        expect(s['name']!.isNotEmpty, true);
        expect(s['emoji']!.isNotEmpty, true);
        expect(s['unlock']!.isNotEmpty, true);
      }
    });

    test('all stickers have unique IDs', () {
      final ids = stickerData.map((s) => s['id']).toSet();
      expect(ids.length, stickerData.length);
    });

    test('unlock values are valid game names', () {
      final validGames = {'treasure', 'bubble', 'match'};
      for (final s in stickerData) {
        expect(validGames.contains(s['unlock']), true, reason: '${s['id']} has invalid unlock game');
      }
    });
  });
}
