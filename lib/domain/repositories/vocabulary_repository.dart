import '../../domain/entities/vocabulary_item.dart';

abstract class VocabularyRepository {
  Future<List<VocabularyItem>> getAllWords();
  Future<List<VocabularyItem>> getWordsByCategory(WordCategory category);
  Future<void> markLearned(int wordId);
  Future<int> getLearnedCount();
  List<VocabularyItem> getWordsSync();
}
