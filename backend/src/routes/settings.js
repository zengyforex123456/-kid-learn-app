export async function settingsRoutes(app) {
  // Get user settings
  app.get('/', { onRequest: [app.authenticate] }, async (req) => {
    let settings = req.db.prepare('SELECT * FROM settings WHERE user_id = ?').get(req.userId);
    if (!settings) {
      req.db.prepare('INSERT INTO settings (user_id) VALUES (?)').run(req.userId);
      settings = req.db.prepare('SELECT * FROM settings WHERE user_id = ?').get(req.userId);
    }
    return { settings };
  });

  // Update settings
  app.put('/', { onRequest: [app.authenticate] }, async (req, reply) => {
    const { daily_limit_minutes, eye_protection, bgm_enabled, difficulty_level, rest_interval_minutes } = req.body || {};

    req.db.prepare(`
      UPDATE settings SET
        daily_limit_minutes = COALESCE(?, daily_limit_minutes),
        eye_protection = COALESCE(?, eye_protection),
        bgm_enabled = COALESCE(?, bgm_enabled),
        difficulty_level = COALESCE(?, difficulty_level),
        rest_interval_minutes = COALESCE(?, rest_interval_minutes),
        updated_at = CURRENT_TIMESTAMP
      WHERE user_id = ?
    `).run(
      daily_limit_minutes, eye_protection != null ? (eye_protection ? 1 : 0) : null,
      bgm_enabled != null ? (bgm_enabled ? 1 : 0) : null,
      difficulty_level, rest_interval_minutes, req.userId
    );

    const settings = req.db.prepare('SELECT * FROM settings WHERE user_id = ?').get(req.userId);
    return { settings };
  });
}
