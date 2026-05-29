import Database from 'better-sqlite3';
import { readFileSync, existsSync, mkdirSync } from 'fs';
import { join, dirname } from 'path';
import { fileURLToPath } from 'url';
import bcrypt from 'bcrypt';

const __dirname = dirname(fileURLToPath(import.meta.url));
const DB_PATH = join(__dirname, '..', '..', 'data', 'app.db');

export function initDatabase() {
  const dir = dirname(DB_PATH);
  if (!existsSync(dir)) mkdirSync(dir, { recursive: true });

  const db = new Database(DB_PATH);
  db.pragma('journal_mode = WAL');
  db.pragma('foreign_keys = ON');

  const schema = readFileSync(join(__dirname, 'schema.sql'), 'utf-8');
  db.exec(schema);

  return db;
}

export function seedDatabase(db) {
  const wordCount = db.prepare('SELECT COUNT(*) as count FROM words').get();
  if (wordCount.count > 0) return;

  const words = [
    ['苹果', 'apple', '🍎', 'fruit', '3-4'],
    ['香蕉', 'banana', '🍌', 'fruit', '3-4'],
    ['橘子', 'orange', '🍊', 'fruit', '3-4'],
    ['葡萄', 'grape', '🍇', 'fruit', '3-4'],
    ['西瓜', 'watermelon', '🍉', 'fruit', '4-5'],
    ['猫', 'cat', '🐱', 'animal', '3-4'],
    ['狗', 'dog', '🐶', 'animal', '3-4'],
    ['大象', 'elephant', '🐘', 'animal', '3-4'],
    ['狮子', 'lion', '🦁', 'animal', '4-5'],
    ['兔子', 'rabbit', '🐰', 'animal', '3-4'],
    ['眼睛', 'eye', '👁️', 'body', '3-4'],
    ['鼻子', 'nose', '👃', 'body', '3-4'],
    ['嘴巴', 'mouth', '👄', 'body', '3-4'],
    ['耳朵', 'ear', '👂', 'body', '3-4'],
    ['手', 'hand', '✋', 'body', '3-4'],
    ['牛奶', 'milk', '🥛', 'daily', '3-4'],
    ['水', 'water', '💧', 'daily', '3-4'],
    ['杯子', 'cup', '🥤', 'daily', '3-4'],
    ['床', 'bed', '🛏️', 'daily', '4-5'],
    ['书', 'book', '📖', 'daily', '4-5'],
    ['红色', 'red', '🔴', 'color', '4-5'],
    ['蓝色', 'blue', '🔵', 'color', '4-5'],
    ['黄色', 'yellow', '🟡', 'color', '4-5'],
    ['绿色', 'green', '🟢', 'color', '4-5'],
    ['白色', 'white', '⚪', 'color', '4-5'],
    ['一', 'one', '1️⃣', 'number', '4-5'],
    ['二', 'two', '2️⃣', 'number', '4-5'],
    ['三', 'three', '3️⃣', 'number', '4-5'],
    ['四', 'four', '4️⃣', 'number', '4-5'],
    ['五', 'five', '5️⃣', 'number', '4-5'],
    ['妈妈', 'mom', '👩', 'family', '3-4'],
    ['爸爸', 'dad', '👨', 'family', '3-4'],
    ['哥哥', 'brother', '👦', 'family', '4-5'],
    ['姐姐', 'sister', '👧', 'family', '4-5'],
    ['宝宝', 'baby', '👶', 'family', '3-4'],
    ['太阳', 'sun', '☀️', 'weather', '4-5'],
    ['月亮', 'moon', '🌙', 'weather', '4-5'],
    ['星星', 'star', '⭐', 'weather', '4-5'],
    ['雨', 'rain', '🌧️', 'weather', '5-6'],
    ['雪', 'snow', '❄️', 'weather', '5-6'],
    ['汽车', 'car', '🚗', 'transport', '4-5'],
    ['飞机', 'airplane', '✈️', 'transport', '5-6'],
    ['火车', 'train', '🚂', 'transport', '5-6'],
    ['公共汽车', 'bus', '🚌', 'transport', '5-6'],
    ['船', 'boat', '⛵', 'transport', '5-6'],
    ['面包', 'bread', '🍞', 'food', '3-4'],
    ['鸡蛋', 'egg', '🥚', 'food', '3-4'],
    ['米饭', 'rice', '🍚', 'food', '4-5'],
    ['面条', 'noodle', '🍜', 'food', '4-5'],
    ['糖果', 'candy', '🍬', 'food', '3-4'],
  ];

  const insert = db.prepare(
    'INSERT INTO words (chinese, english, emoji, category, age_group) VALUES (?, ?, ?, ?, ?)'
  );
  const insertMany = db.transaction((items) => {
    for (const w of items) insert.run(...w);
  });
  insertMany(words);

  const stickers = [
    ['星星收集者', '🌟', 'complete_1_game', 1],
    ['森林探险家', '🦋', 'complete_treasure_5', 5],
    ['泡泡大师', '🫧', 'complete_bubble_10', 10],
    ['配对高手', '🧩', 'complete_match_5', 5],
    ['小小书法家', '✏️', 'learn_10_words', 10],
    ['英语小达人', '🌍', 'learn_20_words', 20],
    ['坚持不懈', '💪', 'play_7_days', 7],
    ['全能冠军', '🏆', 'all_games_played', 1],
    ['初来乍到', '🌸', 'first_login', 1],
    ['学习之星', '⭐', 'learn_30_words', 30],
    ['勤劳小蜜蜂', '🐝', 'play_3_sessions', 3],
    ['快乐宝贝', '🎈', 'streak_3_days', 3],
  ];

  const insertSticker = db.prepare(
    'INSERT INTO stickers (name, emoji, unlock_condition, unlock_value) VALUES (?, ?, ?, ?)'
  );
  const insertStickers = db.transaction((items) => {
    for (const s of items) insertSticker.run(...s);
  });
  insertStickers(stickers);

  // Default parent account: parent / 123456
  const hash = bcrypt.hashSync('123456', 10);
  db.prepare('INSERT OR IGNORE INTO users (username, password_hash, role) VALUES (?, ?, ?)').run('parent', hash, 'parent');
  const parent = db.prepare('SELECT id FROM users WHERE username = ?').get('parent');
  db.prepare('INSERT OR IGNORE INTO settings (user_id) VALUES (?)').run(parent.id);

  console.log(`Seeded ${words.length} words, ${stickers.length} stickers, 1 parent account`);
}
