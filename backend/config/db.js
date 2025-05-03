// db.js - Optimized for performance and reliability
const mysql = require('mysql2/promise'); // Using promise wrapper for async/await
require('dotenv').config();

// Create a connection pool (recommended for production)
const pool = mysql.createPool({
  host: process.env.DB_HOST || 'localhost',
  user: process.env.DB_USER || 'root',
  password: process.env.DB_PASSWORD || 'root',
  database: process.env.DB_NAME || 'vollify_app',
  port: process.env.DB_PORT || 3306, // Explicit port
  waitForConnections: true,
  connectionLimit: 10, // Adjust based on your expected load
  queueLimit: 0, // Unlimited queuing
  enableKeepAlive: true, // Prevent dropped connections
  keepAliveInitialDelay: 10000, // 10s
});

// Test the connection on startup
// Test connection
pool.getConnection()
  .then(connection => {
    console.log('✅ Connected to MySQL as user:', connection.config.user);
    connection.release();
  })
  .catch(err => {
    console.error('❌ Connection failed for user:', process.env.DB_USER);
    console.error('Error:', err.message);
    process.exit(1);
  });

// Utility function for queries
const query = async (sql, params) => {
  let conn;
  try {
    conn = await pool.getConnection();
    const [rows] = await conn.query(sql, params);
    return rows;
  } catch (error) {
    console.error('Query failed:', error.message, '\nSQL:', sql);
    throw error; // Re-throw for route handlers
  } finally {
    if (conn) conn.release(); // Always release connection
  }
};


module.exports = {
  pool, // For transactions
  query // For simple queries
};

process.on('SIGINT', async () => {
  console.log('\n🔌 Gracefully shutting down MySQL pool...');
  await pool.end();
  process.exit(0);
});
