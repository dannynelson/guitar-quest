mongoose = require 'mongoose'
database = require 'local_modules/database'

###
canonical information about piece shared between all users
###
schema = new mongoose.Schema
  userId: {type: mongoose.Schema.ObjectId, required: true}
  category: {type: String, enum: ['piece', 'quest', 'tutorial'], required: true}
  type: {type: String, enum: ['info', 'danger', 'success'], required: true}
  text: {type: String, required: true}
  # did the user dismiss this notification already?
  acknowledged: {type: Boolean, default: false, required: true}

schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'Notification', schema

module.exports = model
