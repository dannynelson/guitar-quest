mongoose = require 'mongoose'
database = require 'local_modules/database'

schema = new mongoose.Schema
  userId: {type: String, required: true}
  submissionVideoLink: {type: String, required: true}
  status: {type: String, enum: ['notSubmitted', 'waitingForFeedback', 'finished', 'retry'], default: 'notSubmitted'}
  teacherFeedback: [
    text: {type: String}
    timestamp: {type: Date}
  ]

schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'PieceSubmission', schema

module.exports = model
