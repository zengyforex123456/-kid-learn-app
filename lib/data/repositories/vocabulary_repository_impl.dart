import 'package:sqflite/sqflite.dart';
import '../../domain/entities/vocabulary_item.dart';
import '../../domain/repositories/vocabulary_repository.dart';
import '../datasources/local_database.dart';
import '../../core/constants/vocabulary_data.dart';

class VocabularyRepositoryImpl implements VocabularyRepository {
  final _words = List<VocabularyItem>.from(vocabularyData);

  @override
  List<VocabularyItem> getWordsSync() => List.unmodifiable(_words);

  @override
  Future<List<VocabularyItem>> getAllWords() async {
    final db = await LocalDatabase.database;
    final maps = await db.query('vocabulary');
    if (maps.isEmpty) {
      await _seed(db);
      return List.unmodifiable(_words);
    }
    return maps.map((m) => VocabularyItem.fromMap(m)).toList();
  }

  @override
  Future<List<VocabularyItem>> getWordsByCategory(WordCategory category) async {
    final all = await getAllWords();
    return all.where((w) => w.category == category).toList();
  }

  @override
  Future<void> markLearned(int wordId) async {
    final db = await LocalDatabase.database;
    await db.update('vocabulary', {'isLearned': 1}, where: 'id = ?', whereArgs: [wordId]);
    final idx = _words.indexWhere((w) => w.id == wordId);
    if (idx != -1) _words[idx] = _words[idx].copyWith(isLearned: true);
  }

  @override
  Future<int> getLearnedCount() async {
    final db = await LocalDatabase.database;
    final result = await db.rawQuery('SELECT COUNT(*) as cnt FROM vocabulary WHERE isLearned = 1');
    return (result.first['cnt'] as int?) ?? 0;
  }

  Future<void> _seed(Database db) async {
    final batch = db.batch();
    for (final w in vocabularyData) {
      batch.insert('vocabulary', w.toMap());
    }
    await batch.commit(noResult: true);
  }
}
