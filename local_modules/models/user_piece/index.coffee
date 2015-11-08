###
Track user progress as they work on a piece
###

mongoose = require 'mongoose'
database = require 'local_modules/database'

historySchema = new mongoose.Schema
  waitingToBeGraded: {type: Boolean}
  submissionVideoURL: {type: String, required: true}
  grade: {type: Number}
  comment: {type: String}
  updatedBy: {type: mongoose.Schema.Types.ObjectId}
  updatedAt: {type: Date}
, {_id: false}

schema = new mongoose.Schema
  pieceId: {type: mongoose.Schema.Types.ObjectId, required: true}
  userId: {type: mongoose.Schema.Types.ObjectId, required: true}

  waitingToBeGraded: {type: Boolean} # note, we need this because if teacher submits same grade twice in a row, we would not now it was graded otherwise
  submissionVideoURL: {type: String, required: true}
  grade: {type: Number} # 1 - 10, teacher grade of the student piece
  comment: {type: String}
  updatedBy: {type: mongoose.Schema.Types.ObjectId}

  # everything that has happened with this piece
  history: [historySchema]

schema.plugin require('mongoose-timestamp')

require('./virtuals')(schema)
require('./hooks')(schema)
require('./methods')(schema)

model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model
