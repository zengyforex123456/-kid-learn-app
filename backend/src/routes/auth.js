import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';

const JWT_SECRET = process.env.JWT_SECRET || 'kids-app-secret-2026';

export async function authRoutes(app) {
  app.post('/login', async (req, reply) => {
    const { username, password } = req.body || {};
    if (!username || !password) {
      return reply.status(400).send({ error: '用户名和密码不能为空' });
    }

    const user = req.db.prepare('SELECT * FROM users WHERE username = ?').get(username);
    if (!user || !bcrypt.compareSync(password, user.password_hash)) {
      return reply.status(401).send({ error: '用户名或密码错误' });
    }

    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });
    return { token, user: { id: user.id, username: user.username, role: user.role, childName: user.child_name, ageGroup: user.age_group } };
  });

  app.post('/register', async (req, reply) => {
    const { username, password, childName, ageGroup } = req.body || {};
    if (!username || !password) {
      return reply.status(400).send({ error: '用户名和密码不能为空' });
    }

    const existing = req.db.prepare('SELECT id FROM users WHERE username = ?').get(username);
    if (existing) return reply.status(409).send({ error: '用户名已存在' });

    const hash = bcrypt.hashSync(password, 10);
    const result = req.db.prepare(
      'INSERT INTO users (username, password_hash, role, child_name, age_group) VALUES (?, ?, ?, ?, ?)'
    ).run(username, hash, 'parent', childName || '宝宝', ageGroup || '3-4');

    const user = req.db.prepare('SELECT * FROM users WHERE id = ?').get(result.lastInsertRowid);
    req.db.prepare('INSERT INTO settings (user_id) VALUES (?)').run(user.id);

    const token = jwt.sign({ userId: user.id }, JWT_SECRET, { expiresIn: '30d' });
    return { token, user: { id: user.id, username: user.username, role: user.role, childName: user.child_name, ageGroup: user.age_group } };
  });
}
