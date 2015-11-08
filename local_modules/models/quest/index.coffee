###
Database of available user quests

user can have up to three quests.
- randomly assigned a new quest every day based on their current level
- can abandon up to one quest per day.
- the reward is a base reward multiplied by the difficulty of the level
- always check to make sure quests are completable before assigning them

Examples
- submit a video for any guitar piece
- complete (score 80% or higher) 2 level x pieces from the x era
- complete (80% or higher) any 3 level x pieces
- get a perfect score (100%) on any 2 level x pieces
- submit any 5 pieces in 5 days
- complete 2 pieces with the x technique
- complete 2 pieces by x composer
###

mongoose = require 'mongoose'
database = require 'local_modules/database'

schema = new mongoose.Schema
  userId: {type: mongoose.Schema.ObjectId, required: true}
  name: {type: String, required: true}
  # quantity of pieces with matching conditions that need to be completed
  # to finish this quest
  quantityCompleted: {type: Number, required: true, default: 0}
  quantityToComplete: {type: Number, required: true}
  completed: {type: Boolean} # automatically set if user completes it
  # conditions for which completed pieces will fulfill this quest. If no conditions, matches any of this type
  conditions:
    piece: {}
    userPiece: {}
  reward:
    credit: {type: Number}

schema.plugin require('mongoose-timestamp')

require('./methods')(schema)
require('./hooks')(schema)

model = database.mongooseConnection.model 'Quest', schema

module.exports = model
