import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  static Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'kidlearn.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  static Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE vocabulary (
        id INTEGER PRIMARY KEY,
        chinese TEXT NOT NULL,
        english TEXT NOT NULL,
        emoji TEXT NOT NULL,
        category TEXT NOT NULL,
        isLearned INTEGER DEFAULT 0
      )
    ''');
    await db.execute('''
      CREATE TABLE stickers (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        emoji TEXT NOT NULL,
        isUnlocked INTEGER DEFAULT 0,
        unlockGame TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE game_progress (
        gameId TEXT PRIMARY KEY,
        playCount INTEGER DEFAULT 0,
        bestScore INTEGER DEFAULT 0,
        totalStars INTEGER DEFAULT 0
      )
    ''');
  }
}
