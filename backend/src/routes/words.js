export async function wordRoutes(app) {
  // Get words by age group and category
  app.get('/', async (req) => {
    const { age_group, category, limit, offset } = req.query;
    let sql = 'SELECT * FROM words WHERE 1=1';
    const params = [];

    if (age_group) { sql += ' AND age_group = ?'; params.push(age_group); }
    if (category) { sql += ' AND category = ?'; params.push(category); }

    sql += ' ORDER BY difficulty, id';
    if (limit) { sql += ' LIMIT ?'; params.push(parseInt(limit)); }
    if (offset) { sql += ' OFFSET ?'; params.push(parseInt(offset)); }

    const words = req.db.prepare(sql).all(...params);
    const total = req.db.prepare('SELECT COUNT(*) as count FROM words WHERE 1=1' +
      (age_group ? ' AND age_group = ?' : '') +
      (category ? ' AND category = ?' : '')
    ).get(...params.filter(Boolean));

    return { words, total: total.count };
  });

  // Get daily words (3-5 new words)
  app.get('/daily', async (req) => {
    const { user_id, age_group } = req.query;
    const learnedIds = user_id
      ? req.db.prepare('SELECT DISTINCT word_id FROM learning_progress WHERE user_id = ?').all(user_id).map(r => r.word_id)
      : [];

    const placeholders = learnedIds.length ? learnedIds.map(() => '?').join(',') : '0';
    const words = req.db.prepare(
      `SELECT * FROM words WHERE age_group = ? AND id NOT IN (${placeholders}) ORDER BY RANDOM() LIMIT 5`
    ).all(age_group || '3-4', ...learnedIds);

    return { words, daily_limit: 5 };
  });

  // Get word by ID
  app.get('/:id', async (req) => {
    const word = req.db.prepare('SELECT * FROM words WHERE id = ?').get(req.params.id);
    if (!word) return { error: 'Word not found' };
    return { word };
  });

  // Get categories
  app.get('/meta/categories', async (req) => {
    const categories = req.db.prepare('SELECT DISTINCT category FROM words ORDER BY category').all();
    return { categories: categories.map(c => c.category) };
  });

  // CMS: Add word (protected)
  app.post('/', { onRequest: [app.authenticate] }, async (req, reply) => {
    const { chinese, english, emoji, category, age_group, difficulty } = req.body || {};
    if (!chinese || !english || !category || !age_group) {
      return reply.status(400).send({ error: 'Missing required fields' });
    }
    const result = req.db.prepare(
      'INSERT INTO words (chinese, english, emoji, category, age_group, difficulty) VALUES (?, ?, ?, ?, ?, ?)'
    ).run(chinese, english, emoji || '', category, age_group, difficulty || 1);
    return { id: result.lastInsertRowid };
  });
}
