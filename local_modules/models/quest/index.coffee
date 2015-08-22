mongoose = require 'mongoose'
database = require 'local_modules/database'

###
Track user progress as they work on a quest
###
schema = new mongoose.Schema
  userId: {type: mongoose.Schema.ObjectId, required: true}
  name: {type: String, required: true}
  # quantity of pieces with matching conditions that need to be completed
  # to finish this quest
  quantityCompleted: {type: Number, required: true, default: 0}
  quantityToComplete: {type: Number, required: true}
  type: {type: String, enum: ['piece', 'tutorial', 'lesson']}
  # conditions for which completed pieces will fulfill this quest. If no conditions, matches any of this type
  conditions: {}
  reward:
    credit: {type: Number}

schema.plugin require('mongoose-timestamp')

require('./methods')(schema)

model = database.mongooseConnection.model 'Quest', schema

module.exports = model
