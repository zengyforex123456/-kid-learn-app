export async function stickerRoutes(app) {
  // Get all stickers with user's unlock status
  app.get('/', { onRequest: [app.authenticate] }, async (req) => {
    const stickers = req.db.prepare(`
      SELECT s.*, CASE WHEN us.id IS NOT NULL THEN 1 ELSE 0 END as earned
      FROM stickers s
      LEFT JOIN user_stickers us ON s.id = us.sticker_id AND us.user_id = ?
      ORDER BY s.id
    `).all(req.userId);
    return { stickers };
  });

  // Check and award new stickers
  app.post('/check', { onRequest: [app.authenticate] }, async (req) => {
    const userId = req.userId;
    const db = req.db;

    // Get user stats for auto-unlock checks
    const wordCount = db.prepare('SELECT COUNT(DISTINCT word_id) as c FROM learning_progress WHERE user_id = ?').get(userId).c;
    const gameCount = db.prepare('SELECT COUNT(*) as c FROM game_sessions WHERE user_id = ?').get(userId).c;
    const treasureCount = db.prepare("SELECT COUNT(*) as c FROM game_sessions WHERE user_id = ? AND game_type = 'treasure'").get(userId).c;
    const bubbleCount = db.prepare("SELECT COUNT(*) as c FROM game_sessions WHERE user_id = ? AND game_type = 'bubble'").get(userId).c;
    const matchCount = db.prepare("SELECT COUNT(*) as c FROM game_sessions WHERE user_id = ? AND game_type = 'match'").get(userId).c;
    const gameTypes = db.prepare("SELECT COUNT(DISTINCT game_type) as c FROM game_sessions WHERE user_id = ?").get(userId).c;

    const conditions = {
      learn_10_words: wordCount,
      learn_20_words: wordCount,
      learn_30_words: wordCount,
      complete_treasure_5: treasureCount,
      complete_bubble_10: bubbleCount,
      complete_match_5: matchCount,
      play_3_sessions: gameCount,
      all_games_played: gameTypes,
      first_login: 1,
      complete_1_game: gameCount,
      play_7_days: 0,
      streak_3_days: 0,
    };

    const allStickers = db.prepare('SELECT * FROM stickers').all();
    const earned = db.prepare('SELECT sticker_id FROM user_stickers WHERE user_id = ?').all(userId).map(r => r.sticker_id);
    const newStickers = [];

    for (const s of allStickers) {
      if (earned.includes(s.id)) continue;
      const current = conditions[s.unlock_condition] || 0;
      if (current >= s.unlock_value) {
        db.prepare('INSERT INTO user_stickers (user_id, sticker_id) VALUES (?, ?)').run(userId, s.id);
        newStickers.push(s);
      }
    }

    return { awarded: newStickers };
  });
}
