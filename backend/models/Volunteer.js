const mongoose = require('mongoose');

const volunteerSchema = new mongoose.Schema({
  username: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },

  firstName: { type: String },
  lastName: { type: String },
  phone: { type: String },
  profilePicture: { type: String },

  skills: [String],
  experience: { type: String },
  certifications: [String],
  education: { type: String }
}, { timestamps: true });

module.exports = mongoose.model('Volunteer', volunteerSchema);
