Promise = require 'bluebird'
UserQuest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
Piece = require 'local_modules/models/piece'

module.exports = (schema) ->

  # if piece finished, add experience points to user
  schema.pre 'save', (next) ->
    return next() unless @isModified('status') and @status is 'finished'

    Promise.all([
      User.findById(@userId)
      Piece.findById(@_id)
    ]).then ([user, piece]) ->
      user.pointsIntoCurrentLevel += piece.points
      user.save()
    .then ->
      next()
    .then null, next

  # notify if piece completed or rejected
  schema.pre 'save', (next) ->
    if @isModified('status') and (@status is 'finished' or @status is 'retry')
      @notify = true
    next()
