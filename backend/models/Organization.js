const mongoose = require('mongoose');

const organizationSchema = new mongoose.Schema({
  name: { type: String, required: true },
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },

  phone: { type: String },
  location: { type: String },
  profilePicture: { type: String },
  socialMedia: {
    facebook: String,
    instagram: String,
    twitter: String,
    website: String
  },
  field: { type: String },
  currentProjects: [String],
  rating: {
    type: Number,
    default: 0
  }
}, { timestamps: true });

module.exports = mongoose.model('Organization', organizationSchema);
