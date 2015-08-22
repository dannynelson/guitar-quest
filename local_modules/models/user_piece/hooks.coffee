Promise = require 'bluebird'
UserQuest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
Piece = require 'local_modules/models/piece'

module.exports = (schema) ->

  # if piece finished, add experience points to user
  schema.pre 'save', (next) ->
    console.log 'PRE SAVE'
    return next() unless @isModified('status') and @status is 'finished'

    Promise.all([
      User.findById(@userId)
      Piece.findById(@_id)
    ]).then ([user, piece]) ->
      console.log 'PRE SAV2'
      user.pointsIntoCurrentLevel += piece.points
      user.save()
    .then ->
      console.log 'PRE SAV3'
      next()
    .then null, next
