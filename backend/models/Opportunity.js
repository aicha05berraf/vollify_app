const mongoose = require('mongoose');

const opportunitySchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: { type: String },
  location: { type: String },
  date: { type: Date, required: true },
  organization: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Organization',
    required: true
  },
  requiredSkills: [String],
  category: { type: String },
  isOnline: { type: Boolean, default: false }
}, { timestamps: true });

module.exports = mongoose.model('Opportunity', opportunitySchema);
