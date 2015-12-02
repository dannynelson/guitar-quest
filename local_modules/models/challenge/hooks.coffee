Promise = require 'bluebird'
logger = require 'local_modules/logger'
challengeHelpers = require './helpers'

module.exports = (schema) ->

  schema.pre 'save', (next) ->
    if @isModified('quantityCompleted')
      logger.warn 'Do not set quantityCompleted. It is automatically set as the sum of completed pieces.'
    @piecesCompleted ?= []
    @quantityCompleted = @piecesCompleted.length
    next()

  # Notify if progress made on challenge, and if a challenge is completed, give the user credit
  schema.pre 'save', (next) ->
    Notification = require 'local_modules/models/notification'
    User = require 'local_modules/models/user'

    if @isModified('quantityCompleted')
      Promise.try =>
        if @quantityCompleted is @quantityToComplete
          return User.findById(@userId).then (user) =>
            @completed = true
            if @reward.credits?
              user.credits += @reward.credits
            if @reward.points?
              user.points += @reward.points if @reward.points?
            user.save()
      .then =>
        next()
      .then null, (err) =>
        next()
    else
      next()

  schema.post 'save', (next) ->
    # This should always come after notificaiton is fully updated
    Notification.createNew 'challengeProgressed', {notification: @}
    .then =>
      next()
    .then null, (err) =>
      next()
