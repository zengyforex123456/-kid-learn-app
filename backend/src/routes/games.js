export async function gameRoutes(app) {
  // Record game session result
  app.post('/session', { onRequest: [app.authenticate] }, async (req, reply) => {
    const { game_type, words_played, correct_count, duration_seconds } = req.body || {};
    if (!game_type) return reply.status(400).send({ error: 'game_type required' });

    const result = req.db.prepare(
      'INSERT INTO game_sessions (user_id, game_type, words_played, correct_count, duration_seconds) VALUES (?, ?, ?, ?, ?)'
    ).run(req.userId, game_type, words_played || 0, correct_count || 0, duration_seconds || 0);

    return { id: result.lastInsertRowid };
  });

  // Record word learning progress
  app.post('/progress', { onRequest: [app.authenticate] }, async (req, reply) => {
    const { word_id, game_type, score } = req.body || {};
    if (!word_id || !game_type) return reply.status(400).send({ error: 'word_id and game_type required' });

    req.db.prepare(
      'INSERT OR REPLACE INTO learning_progress (user_id, word_id, game_type, score, completed_at) VALUES (?, ?, ?, ?, CURRENT_TIMESTAMP)'
    ).run(req.userId, word_id, game_type, score || 1);

    return { success: true };
  });

  // Get game stats for a user
  app.get('/stats', { onRequest: [app.authenticate] }, async (req) => {
    const stats = req.db.prepare(`
      SELECT game_type, COUNT(*) as sessions, SUM(words_played) as total_words,
             SUM(correct_count) as total_correct, SUM(duration_seconds) as total_seconds
      FROM game_sessions WHERE user_id = ? GROUP BY game_type
    `).all(req.userId);

    const totalLearned = req.db.prepare(
      'SELECT COUNT(DISTINCT word_id) as count FROM learning_progress WHERE user_id = ?'
    ).get(req.userId);

    return { stats, totalWordsLearned: totalLearned.count };
  });
}
