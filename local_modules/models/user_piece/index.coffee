mongoose = require 'mongoose'
database = require 'local_modules/database'

###
Track user progress as they work on a piece
###
schema = new mongoose.Schema
  userId: {type: mongoose.Schema.ObjectId, required: true}
  submissionVideoURL: {type: String, required: true}
  status: {type: String, enum: ['notSubmitted', 'waitingForFeedback', 'finished', 'retry'], default: 'notSubmitted'}
  teacherComments: [
    text: {type: String}
    timestamp: {type: Date}
  ]

schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model
