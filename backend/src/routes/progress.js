export async function progressRoutes(app) {
  // Get learning progress summary
  app.get('/', { onRequest: [app.authenticate] }, async (req) => {
    const progress = req.db.prepare(`
      SELECT w.id, w.chinese, w.english, w.emoji, w.category,
             lp.game_type, lp.score, lp.completed_at
      FROM learning_progress lp
      JOIN words w ON w.id = lp.word_id
      WHERE lp.user_id = ?
      ORDER BY lp.completed_at DESC
      LIMIT 100
    `).all(req.userId);

    const summary = req.db.prepare(`
      SELECT w.category, COUNT(DISTINCT w.id) as learned
      FROM learning_progress lp
      JOIN words w ON w.id = lp.word_id
      WHERE lp.user_id = ?
      GROUP BY w.category
    `).all(req.userId);

    return { progress, summary };
  });

  // Get today's stats
  app.get('/today', { onRequest: [app.authenticate] }, async (req) => {
    const today = new Date().toISOString().split('T')[0];
    const stats = req.db.prepare(`
      SELECT COUNT(DISTINCT word_id) as words_learned,
             COUNT(DISTINCT game_type) as games_played,
             SUM(CASE WHEN game_type = 'treasure' THEN 1 ELSE 0 END) as treasure_rounds,
             SUM(CASE WHEN game_type = 'bubble' THEN 1 ELSE 0 END) as bubble_rounds,
             SUM(CASE WHEN game_type = 'match' THEN 1 ELSE 0 END) as match_rounds
      FROM learning_progress
      WHERE user_id = ? AND date(completed_at) = ?
    `).get(req.userId, today);

    return { today: stats || { words_learned: 0, games_played: 0, treasure_rounds: 0, bubble_rounds: 0, match_rounds: 0 } };
  });
}
