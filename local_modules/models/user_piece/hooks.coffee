Promise = require 'bluebird'
UserQuest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
Piece = require 'local_modules/models/piece'
Notification = require 'local_modules/models/notification'

module.exports = (schema) ->

  # if piece finished, add experience and notification for
  schema.pre 'save', (next) ->
    return next() unless @isModified('status') and @status is 'finished'

    Promise.all([
      User.findById(@userId)
      Piece.findById(@_id)
    ]).then ([user, piece]) =>
      user.pointsIntoCurrentLevel += piece.points

      notification = new Notification
        userId: @userId
        category: 'piece'
        type: 'success'
        text: "Congratulations! Your video submission for #{piece.name} was accepted and you earned #{piece.points} points."
        acknowledged: false

      # save notification before user so that level up notifications come afterwards
      notification.save().then => user.save()
    .then ->
      next()
    .then null, next

  # notify if piece was rejected
  schema.pre 'save', (next) ->
    if @isModified('status') and @status is 'retry'
      Piece.findById(@_id).then (piece) =>
        notification = new Notification
          userId: @userId
          category: 'piece'
          type: 'danger'
          text: "Your video submission for #{piece.name} was not accepted. Please review teacher feedback and submit another video."
          acknowledged: false
        notification.save()
      .then =>
        next()
      .then null, next
    else
      next()
