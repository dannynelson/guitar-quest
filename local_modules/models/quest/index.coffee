###
Database of available user quests

user can have up to three quests.
- randomly assigned a new quest every day based on their current level
- can abandon up to one quest per day.
- the reward is a base reward multiplied by the difficulty of the level
- always check to make sure quests are completable before assigning them

Perfect Grade
level 3
Complete any 2 level 3 pieces with at least an 80% grade.
[10 credits]
0 / 2 Complete

Examples
- Submit First Video - submit a video for any guitar piece
- Submit Them All - submit any 6 videos from any level.1
- Level {X} Practice - complete (80% or higher) any 3 level x pieces
- Perfect Grade - get a perfect grade (100%) on any 3 level x pieces
- {Era} Era Practice - complete (score 80% or higher) 3 level x pieces from the x era
- {Technique} Practice - complete 2 pieces with the 3 technique
- {Composer} Practice - complete 2 pieces with the 3 technique

In the future (probably dont' want to do this, just reward pieces)
- First Lesson - schedule a lesson with a teacher
- First Tutorial - schedule a lesson with a teacher

Questions
- how to prevent duplicate quests
  - assign a type, and query to see if any match type and level before creating
- how to prevent assigning quests that are not completable
- is it worth having them be level specific? for some yes, for some no

strategy
- keep trying until something doesn't fail
  - each type of quest fails if it already existins
- try to gather all data and intelligently create a quest we know wont fail
  - Find all existing, active, non complete quests for user, and use that to deduce which type of quest the user does not have
  - Find all matching pieces for user level and below. Group all pieces and userPieces, and run each potential
    quest to make sure they have a set of matches
  - from the remaining options, choose a random one
- allow cancelling a quest and let them select another one if they can't complete it

###

mongoose = require 'mongoose'
database = require 'local_modules/database'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
schema = JSONSchemaConverter.toMongooseSchema(JSONSchema, mongoose)

# schema = new mongoose.Schema
#   userId: {type: mongoose.Schema.ObjectId, required: true}
#   name: {type: String, required: true}
#   # quantity of pieces with matching conditions that need to be completed
#   # to finish this quest
#   quantityCompleted: {type: Number, required: true, default: 0}
#   quantityToComplete: {type: Number, required: true}
#   completed: {type: Boolean} # automatically set if user completes it
#   # conditions for which completed pieces will fulfill this quest. If no conditions, matches any of this type
#   conditions:
#     piece: {}
#     userPiece: {}
#   reward:
#     credit: {type: Number}

schema.plugin require('mongoose-timestamp')

require('./methods')(schema)
require('./hooks')(schema)

model = database.mongooseConnection.model 'Quest', schema

module.exports = model
