###
Database of available user challenges
- piece = short term goal (1 day - 1 week)
- challenges = medium term goal (1 week - 1 month)
- level-up = long-term goal (1 month - 6 months)

# Challenges
small, easily achievable goals, based on the user's current level
- encourage
option to decline quest, so that they can get rid of more difficult ones?
- higher credit awarded with each level, since higher level pieces usually take longer to learn
reward - lesson credit
- why not experience?
  - b/c realistically, experience only comes from learning pieces
  - other argument is challenges make them a more well-rounded guitarist, so should give them experience.
  - this would be my next alternative of what I would try
- why not pieces? - b/c workflow is confusing (how do they see which piece they unlocked? what if the piece was an earlier level? And if they don't like the piece, it is not really an award. Easiest if pieces are only unlocked by leveling up).
  - advantage is that it would make each level less overwhelming (but a little confusing)
  - could be pieces that are not in the book?
- why not tutorials? - b/c realistically, experience only comes from learning pieces
- why not arbitrary money that they can use to buy subscriptions? - b/c I want to upsell lessons
- why not tips/tutorials? - b/c not that interesting
- why not badges? - b/c they do not help you learn guitar

user can have up to three challenges.
- randomly assigned a new challenge every day based on their current level
- can abandon up to one challenge per day.
- the reward is a base reward multiplied by the difficulty of the level
- always check to make sure challenges are completable before assigning them

Perfect Grade
level 3
Complete any 2 level 3 pieces with at least an 80% grade.
[10 credits]
0 / 2 Complete

Examples
- Submit First Video - submit a video for any guitar piece
x Sight Reading - encourages sloppier videos, which discourages
- Level {X} Practice - complete (80% or higher) any 3 level x pieces - for practicing pieces from earlier levels
- Perfect Grade - get a perfect grade (100%) on any 3 level x pieces
- {Era} Era Practice - complete (score 80% or higher) 3 level x pieces from the x era
- {Technique} Practice - complete 2 pieces with the 3 technique
- {Composer} Practice - complete 2 pieces with the 3 technique

In the future (probably dont' want to do this, just reward pieces)
- First Lesson - schedule a lesson with a teacher
- First Tutorial - schedule a lesson with a teacher

Questions
- how to prevent duplicate challenges
  - assign a type, and query to see if any match type and level before creating
- how to prevent assigning challenges that are not completable
- is it worth having them be level specific? for some yes, for some no

strategy
- keep trying until something doesn't fail
  - each type of challenge fails if it already existins
- try to gather all data and intelligently create a challenge we know wont fail
  - Find all existing, active, non complete challenges for user, and use that to deduce which type of challenge the user does not have
  - Find all matching pieces for user level and below. Group all pieces and userPieces, and run each potential
    challenge to make sure they have a set of matches
  - from the remaining options, choose a random one
- allow cancelling a challenge and let them select another one if they can't complete it

###

mongoose = require 'mongoose'
database = require 'local_modules/database'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
schema = JSONSchemaConverter.toMongooseSchema(JSONSchema, mongoose)

schema.plugin require('mongoose-timestamp')

require('./methods')(schema)
require('./hooks')(schema)

model = database.mongooseConnection.model 'Challenge', schema

module.exports = model
