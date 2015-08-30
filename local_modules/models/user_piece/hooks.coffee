Promise = require 'bluebird'

module.exports = (schema) ->

  # if piece finished, add experience and notification for
  schema.pre 'save', (next) ->
    User = require 'local_modules/models/user'
    Notification = require 'local_modules/models/notification'
    Piece = require 'local_modules/models/piece'

    return next() unless @isModified('status') and @status is 'finished'

    Promise.all([
      User.findById(@userId)
      Piece.findById(@pieceId)
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

  # progress quests
  schema.pre 'save', (next) ->
    Quest = require 'local_modules/models/quest'
    Piece = require 'local_modules/models/piece'

    Piece.findById(@pieceId).then (piece) =>
      Quest.checkForProgress @userId,
        userPiece: @
        piece: piece
    .then =>
      next()
    .then null, (err) ->
      next()


  # notify if piece was rejected
  schema.pre 'save', (next) ->
    Notification = require 'local_modules/models/notification'

    if @isModified('status') and @status is 'retry'
      Piece.findById(@pieceId).then (piece) =>
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
