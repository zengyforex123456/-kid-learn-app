-- 幼儿双语识字 APP 数据库 schema
-- MVP: 50 词, 3 游戏, 贴纸系统, 家长管控

CREATE TABLE IF NOT EXISTS words (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  chinese TEXT NOT NULL,
  english TEXT NOT NULL,
  emoji TEXT NOT NULL DEFAULT '',
  category TEXT NOT NULL CHECK(category IN ('fruit','animal','body','daily','color','number','family','weather','transport','food')),
  age_group TEXT NOT NULL CHECK(age_group IN ('3-4','4-5','5-6')),
  audio_cn TEXT,
  audio_en TEXT,
  image_url TEXT,
  difficulty INTEGER DEFAULT 1,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  username TEXT UNIQUE NOT NULL,
  password_hash TEXT NOT NULL,
  role TEXT DEFAULT 'parent' CHECK(role IN ('parent','child')),
  child_name TEXT,
  age_group TEXT DEFAULT '3-4',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS learning_progress (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  word_id INTEGER NOT NULL REFERENCES words(id),
  game_type TEXT NOT NULL CHECK(game_type IN ('treasure','bubble','match')),
  score INTEGER DEFAULT 0,
  completed_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, word_id, game_type)
);

CREATE TABLE IF NOT EXISTS stickers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  emoji TEXT NOT NULL,
  unlock_condition TEXT NOT NULL,
  unlock_value INTEGER DEFAULT 1
);

CREATE TABLE IF NOT EXISTS user_stickers (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  sticker_id INTEGER NOT NULL REFERENCES stickers(id),
  earned_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  UNIQUE(user_id, sticker_id)
);

CREATE TABLE IF NOT EXISTS settings (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER UNIQUE NOT NULL REFERENCES users(id),
  daily_limit_minutes INTEGER DEFAULT 30,
  eye_protection BOOLEAN DEFAULT 1,
  bgm_enabled BOOLEAN DEFAULT 1,
  difficulty_level TEXT DEFAULT '3-4' CHECK(difficulty_level IN ('3-4','4-5','5-6')),
  rest_interval_minutes INTEGER DEFAULT 15,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS game_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL REFERENCES users(id),
  game_type TEXT NOT NULL,
  words_played INTEGER DEFAULT 0,
  correct_count INTEGER DEFAULT 0,
  duration_seconds INTEGER DEFAULT 0,
  played_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Indexes
CREATE INDEX IF NOT EXISTS idx_words_category ON words(category);
CREATE INDEX IF NOT EXISTS idx_words_age ON words(age_group);
CREATE INDEX IF NOT EXISTS idx_progress_user ON learning_progress(user_id);
CREATE INDEX IF NOT EXISTS idx_sessions_user ON game_sessions(user_id);
