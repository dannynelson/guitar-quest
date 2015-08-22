mongoose = require 'mongoose'
database = require 'local_modules/database'

###
Track user progress as they work on a piece
###
schema = new mongoose.Schema
  # _id the same as the piece that it comes from
  userId: {type: mongoose.Schema.ObjectId, required: true}
  submissionVideoURL: {type: String, required: true}
  status: {type: String, enum: ['unfinished', 'pending', 'finished', 'retry'], default: 'unfinished'}
  teacherComments: [
    text: {type: String}
    timestamp: {type: Date}
  ]

schema.plugin require('mongoose-timestamp')

require('./hooks')(schema)

model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model
