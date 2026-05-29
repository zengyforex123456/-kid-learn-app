import Fastify from 'fastify';
import cors from '@fastify/cors';
import multipart from '@fastify/multipart';
import { initDatabase, seedDatabase } from './db/init.js';
import { authRoutes } from './routes/auth.js';
import { wordRoutes } from './routes/words.js';
import { gameRoutes } from './routes/games.js';
import { stickerRoutes } from './routes/stickers.js';
import { settingsRoutes } from './routes/settings.js';
import { progressRoutes } from './routes/progress.js';

const PORT = process.env.PORT || 3000;

async function start() {
  const app = Fastify({ logger: true });

  await app.register(cors, { origin: true });
  await app.register(multipart, { limits: { fileSize: 10 * 1024 * 1024 } });

  const db = initDatabase();
  seedDatabase(db);

  app.decorate('db', db);
  app.decorateRequest('db', null);
  app.addHook('onRequest', (req, _reply, done) => {
    req.db = db;
    done();
  });

  // Auth middleware
  app.decorate('authenticate', async (req, reply) => {
    try {
      const token = req.headers.authorization?.replace('Bearer ', '');
      if (!token) throw new Error('No token');
      const jwt = await import('jsonwebtoken');
      const payload = jwt.default.verify(token, process.env.JWT_SECRET || 'kids-app-secret-2026');
      req.userId = payload.userId;
    } catch {
      reply.status(401).send({ error: 'Unauthorized' });
    }
  });

  // Routes
  await app.register(authRoutes, { prefix: '/api/auth' });
  await app.register(wordRoutes, { prefix: '/api/words' });
  await app.register(gameRoutes, { prefix: '/api/games' });
  await app.register(stickerRoutes, { prefix: '/api/stickers' });
  await app.register(settingsRoutes, { prefix: '/api/settings' });
  await app.register(progressRoutes, { prefix: '/api/progress' });

  // Health
  app.get('/api/health', () => ({ status: 'ok', time: new Date().toISOString() }));

  await app.listen({ port: PORT, host: '0.0.0.0' });
  console.log(`Backend running on http://localhost:${PORT}`);
}

start().catch((err) => { console.error(err); process.exit(1); });
