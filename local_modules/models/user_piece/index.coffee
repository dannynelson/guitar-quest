###
Track user progress as they work on a piece
###

mongoose = require 'mongoose'
database = require 'local_modules/database'

commentSchema = new mongoose.Schema
  userId: {type: mongoose.Schema.Types.ObjectId}
  text: {type: String}
  createdAt: {type: Date}

schema = new mongoose.Schema
  pieceId: {type: mongoose.Schema.Types.ObjectId, required: true}
  userId: {type: mongoose.Schema.Types.ObjectId, required: true}
  submissionVideoURL: {type: String, required: true}
  grade: {type: Number} # 1 - 10, teacher rating of the student piece
  waitingToBeGraded: {type: Boolean}
  comments: [commentSchema] # TODO, should this save record of every submitted piece?

schema.plugin require('mongoose-timestamp')

require('./hooks')(schema)

model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model
