const express = require('express');
const router = express.Router();
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const db = require('../config/db');
const crypto = require('crypto');
const nodemailer = require('nodemailer');
const fs = require('fs');
const path = require('path');
require('dotenv').config();

// ========================
// MIDDLEWARE
// ========================

const authenticate = (req, res, next) => {
  const token = req.header('Authorization')?.replace('Bearer ', '');
  if (!token) return res.status(401).json({ error: 'Access denied. Token required' });

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.user = decoded; // Attach user to request
    next();
  } catch (err) {
    res.status(401).json({ error: 'Invalid or expired token' });
  }
};

// ========================
// AUTHENTICATION ROUTES
// ========================

router.post('/volunteer/signup', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const { username, email, password } = req.body;

    if (!username?.trim() || !email?.trim() || !password?.trim()) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const existingUser = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const userResult = await db.query(
      'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
      [username, email, hashedPassword, 'volunteer']
    );

    await db.query('INSERT INTO volunteers (id) VALUES (?)', [userResult.insertId]);
    res.status(201).json({ message: 'Volunteer registered successfully' });
  } catch (err) {
    console.error('Signup error:', err);
    res.status(500).json({ error: 'Internal server error during signup' });
  }
});


router.post('/organization/signup', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const { name, email, password } = req.body;

    if (!name?.trim() || !email?.trim() || !password?.trim()) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const existingUser = await db.query('SELECT * FROM users WHERE email = ?', [email]);
    if (existingUser.length > 0) {
      return res.status(400).json({ error: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(password, 10);
    const userResult = await db.query(
      'INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)',
      [name, email, hashedPassword, 'organization']
    );

    await db.query('INSERT INTO organizations (id) VALUES (?)', [userResult.insertId]);
    res.status(201).json({ message: 'Organization registered successfully' });
  } catch (err) {
    console.error('Signup error:', err);
    res.status(500).json({ error: 'Internal server error during signup' });
  }
});


router.post('/login', async (req, res) => {
  try {
    const { email, password, role } = req.body;
    console.log('📥 Received data:', req.body);
    console.log('👤 Login attempt:', email, password, role);

    if (!email?.trim() || !password?.trim() || !role?.trim()) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const userRows = await db.query('SELECT * FROM users WHERE email = ? AND role = ? AND password = ?', [email, role, password]);
    if (userRows.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const user = userRows[0];
    console.log('🔍 Found user:', user);

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(401).json({ error: 'Invalid password' });
    }

    const token = jwt.sign({ id: user.id, role: user.role }, process.env.JWT_SECRET, { expiresIn: '1d' });
    res.json({ token, user });
  } catch (err) {
    console.error('Login error:', err);
    res.status(500).json({ error: 'Login failed' });
  }
});


// ========================
// PROFILE ROUTES
// ========================

router.get('/volunteers/:id', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const volunteerRows = await db.query(`
      SELECT users.id, users.name, users.email, users.role, 
             volunteers.phone, volunteers.skills, volunteers.experience,
             volunteers.certifications, volunteers.education, volunteers.total_hours
      FROM users
      JOIN volunteers ON users.id = volunteers.id
      WHERE users.id = ?
    `, [req.params.id]);

    if (volunteerRows.length === 0) {
      return res.status(404).json({ error: 'Volunteer not found' });
    }
    res.json(volunteerRows[0]);
  } catch (err) {
    console.error('Fetch volunteer error:', err);
    res.status(500).json({ error: 'Failed to fetch volunteer' });
  }
});


router.get('/organizations/:id', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const orgRows = await db.query(`
      SELECT users.id, users.name, users.email, users.role, 
             organizations.phone, organizations.address, 
             organizations.field, organizations.current_projects, organizations.rating
      FROM users
      JOIN organizations ON users.id = organizations.id
      WHERE users.id = ?
    `, [req.params.id]);

    if (orgRows.length === 0) {
      return res.status(404).json({ error: 'Organization not found' });
    }
    res.json(orgRows[0]);
  } catch (err) {
    console.error('Fetch org error:', err);
    res.status(500).json({ error: 'Failed to fetch organization' });
  }
});

// ========================
// OPPORTUNITY ROUTES
// ========================

router.post('/opportunities', authenticate, async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const { organization_id, title, description, date, location } = req.body;
    if (!organization_id || !title || !description) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const result = await db.query(`
      INSERT INTO opportunities (organization_id, title, description, date, location)
      VALUES (?, ?, ?, ?, ?)
    `, [organization_id, title, description, date || null, location || null]);

    res.status(201).json({ 
      id: result.insertId, 
      message: 'Opportunity created successfully' 
    });
  } catch (err) {
    console.error('Create opportunity error:', err);
    res.status(500).json({ error: 'Failed to create opportunity' });
  }
});


router.get('/opportunities', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const rows = await db.query('SELECT * FROM opportunities');
    res.json(rows);
  } catch (err) {
    console.error('Fetch opportunities error:', err);
    res.status(500).json({ error: 'Failed to fetch opportunities' });
  }
});

// ========================
// SAVED/APPLICATIONS ROUTES
// ========================

router.post('/saved', authenticate, async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const { volunteer_id, opportunity_id } = req.body;
    if (!volunteer_id || !opportunity_id) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    await db.query(`
      INSERT INTO saved_opportunities (volunteer_id, opportunity_id)
      VALUES (?, ?)
    `, [volunteer_id, opportunity_id]);

    res.status(201).json({ message: 'Opportunity saved successfully' });
  } catch (err) {
    console.error('Save opportunity error:', err);
    res.status(500).json({ error: 'Failed to save opportunity' });
  }
});

router.get('/saved/:volunteerId', authenticate, async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const rows = await db.query(`
      SELECT s.*, o.title, o.description, o.date, o.location
      FROM saved_opportunities s
      JOIN opportunities o ON s.opportunity_id = o.id
      WHERE s.volunteer_id = ?
    `, [req.params.volunteerId]);

    res.json(rows);
  } catch (err) {
    console.error('Fetch saved error:', err);
    res.status(500).json({ error: 'Failed to fetch saved opportunities' });
  }
});

// ... (Keep ALL your remaining routes - applications, notifications, reviews, etc.) ...

// ========================
// PASSWORD RESET ROUTES
// ========================

const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: process.env.EMAIL_USER,
    pass: process.env.EMAIL_PASS,
  },
});

router.post('/forgot-password', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    console.log('📥 Received data:', req.body);
    const transporter = require('../config/email');
    const { email, role } = req.body;

    if (!email?.trim() || !role?.trim()) {
      return res.status(400).json({ error: 'Missing required fields' });
    }

    const users = await db.query(
      'SELECT * FROM users WHERE email = ? AND role = ?',
      [email, role]
    );

    if (users.length === 0) {
      return res.status(404).json({ error: 'User not found' });
    }

    const token = crypto.randomBytes(32).toString('hex');
    const expiry = new Date(Date.now() + 3600000); // 1 hour

    await db.query(
      'UPDATE users SET reset_token = ?, reset_token_expiry = ? WHERE id = ?',
      [token, expiry, users[0].id]
    );

    // Send reset email
    await transporter.sendMail({
      from: `"Vollify Support" <${process.env.EMAIL_USER}>`,
      to: email,
      subject: 'Vollify Password Reset',
      html: `
        <p>Hi ${users[0].name},</p>
        <p>You requested a password reset. Click the link below to reset your password:</p>
        <a href="http://19.168.100.2:3000/reset-password/${token}">Reset Password</a>
        <p>This link will expire in 1 hour.</p>
      `
    });

    res.status(200).json({ message: 'Reset token sent to email successfully' });
  } catch (err) {
    console.error('Password reset error:', err);
    res.status(500).json({ error: 'Internal server error during password reset' });
  }
});

router.post('/reset-password/:token', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const { token } = req.params;
    const { newPassword } = req.body;

    if (!newPassword?.trim()) {
      return res.status(400).json({ error: 'New password is required' });
    }

    // Check if token exists and is not expired
    const users = await db.query(
      'SELECT * FROM users WHERE reset_token = ? AND reset_token_expiry > NOW()',
      [token]
    );

    if (users.length === 0) {
      return res.status(400).json({ error: 'Invalid or expired token' });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);

    // Update the password and clear the token
    await db.query(
      'UPDATE users SET password = ?, reset_token = NULL, reset_token_expiry = NULL WHERE id = ?',
      [hashedPassword, users[0].id]
    );

    res.status(200).json({ message: 'Password has been reset successfully' });

  } catch (err) {
    console.error('Reset password error:', err);
    res.status(500).json({ error: 'Internal server error during password reset' });
  }
});

// ========================
// IMAGE UPLOAD ROUTES
// ========================

router.put('/volunteers/update/:id', async (req, res) => {
  try { console.log('📥 Received data:', req.body);
    const { name, email, phone, skills, image } = req.body;
    const userId = req.params.id;

    if (skills && !Array.isArray(skills)) {
      return res.status(400).json({ error: 'Skills must be an array' });
    }

    let imageUrl;
    if (image) {
      const uploadDir = path.join(__dirname, '../uploads/volunteers');
      if (!fs.existsSync(uploadDir)) fs.mkdirSync(uploadDir, { recursive: true });

      const buffer = Buffer.from(image, 'base64');
      const filename = `volunteer_${userId}_${Date.now()}.png`;
      fs.writeFileSync(path.join(uploadDir, filename), buffer);
      imageUrl = `/uploads/volunteers/${filename}`;
    }

    await db.query(
      'UPDATE users SET name = ?, email = ? WHERE id = ?',
      [name, email, userId]
    );
    
    await db.query(
      `UPDATE volunteers SET 
       phone = ?, skills = ? ${image ? ', image_url = ?' : ''}
       WHERE id = ?`,
      [phone, JSON.stringify(skills), ...(image ? [imageUrl] : []), userId]
    );
    

    res.status(200).json({ message: 'Profile updated successfully' });
  } catch (err) {
    console.error('Update error:', err);
    res.status(500).json({ error: 'Failed to update profile' });
  }
});

// ... (Keep all other image upload routes like /organizations/update) ...

module.exports = router;