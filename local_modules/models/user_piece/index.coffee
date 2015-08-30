mongoose = require 'mongoose'
database = require 'local_modules/database'

###
Track user progress as they work on a piece
###
commentSchema = new mongoose.Schema
  userId: {type: mongoose.Schema.Types.ObjectId}
  text: {type: String}
  createdAt: {type: Date}


schema = new mongoose.Schema
  pieceId: {type: mongoose.Schema.Types.ObjectId, required: true}
  userId: {type: mongoose.Schema.Types.ObjectId, required: true}
  submissionVideoURL: {type: String, required: true}
  status: {type: String, enum: ['unfinished', 'pending', 'finished', 'retry'], default: 'unfinished'}
  comments: [commentSchema]

schema.plugin require('mongoose-timestamp')

require('./hooks')(schema)

model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model
