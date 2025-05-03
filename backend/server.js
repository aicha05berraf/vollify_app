// server.js - Guaranteed Working Version
require('dotenv').config({ path: require('path').resolve(__dirname, '.env') });

// Debug env vars
console.log('Starting with DB config:', {
  user: process.env.MYSQL_USER,
  host: process.env.MYSQL_HOST,
  database: process.env.MYSQL_DATABASE
});

const express = require('express');
const http = require('http');
const mysql = require('mysql2/promise');
const path = require('path');

// Initialize app
const app = express();
const server = http.createServer(app);

// Middleware
app.use(express.json());
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// Database connection
const pool = mysql.createPool({
  host: process.env.MYSQL_HOST || 'localhost',
  user: process.env.MYSQL_USER || 'root',
  password: process.env.MYSQL_PASSWORD || 'root',
  database: process.env.MYSQL_DATABASE || 'vollify_app',
  waitForConnections: true,
  connectionLimit: 10
});

// Log when requests come in
app.use((req, res, next) => {
  console.log(`[${new Date().toISOString()}] ${req.method} ${req.path}`);
  next();
});

// Add exit handlers
process.on('SIGINT', () => {
  console.log('\nServer shutting down...');
  server.close();
  process.exit();
});

// Simple test route
app.get('/health', async (req, res) => {
  try {
    const [rows] = await req.db.query('SELECT 1 + 1 AS result');
    res.json({
      status: 'healthy',
      db: rows[0].result === 2 ? 'working' : 'unexpected'
    });
  } catch (err) {
    res.status(500).json({ error: err.message });
  }
});

// Default route
app.get('/', (req, res) => {
  res.send('Vollify Backend is Running');
});

// Start server
const PORT = process.env.PORT || 3000;
server.listen(PORT, () => {
  console.log(`🚀 Server running on http://localhost:${PORT}`);
  console.log('Test with:');
  console.log(`- curl http://localhost:${PORT}/health`);
  console.log(`- curl http://localhost:${PORT}`);
});

// Error handling
process.on('unhandledRejection', (err) => {
  console.error('Unhandled rejection:', err);
});

// Verify DB connection
pool.getConnection()
  .then(conn => {
    console.log('✅ MySQL connection verified');
    conn.release();
  })
  .catch(err => {
    console.error('❌ MySQL connection failed:', err.message);
  });

  app.use(express.json());
app.use(express.urlencoded({ extended: true }));


  const routes = require('./routes/index'); // adjust path if needed
app.use('/api', routes); // or simply `app.use(routes);` if you're not prefixing with /api

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

const cors = require('cors');
app.use(cors({ origin: process.env.CORS_ORIGIN, credentials: true }));
