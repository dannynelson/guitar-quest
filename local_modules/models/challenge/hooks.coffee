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
        if 0 < @quantityCompleted < @quantityToComplete
          return Notification.send
            userId: @userId
            category: 'challenge'
            type: 'info'
            title: 'GuitarQuest challenge progress'
            text: "You completed #{@quantityCompleted}/#{@quantityToComplete} of the challenge \"#{challengeHelpers.getTitle(@type)}\""

        else if @quantityCompleted is @quantityToComplete
          User.findById(@userId).then (user) =>
            @completed = true

            if @reward.credits?
              user.credits += @reward.credits
              return Notification.send
                userId: @userId
                category: 'challenge'
                type: 'success'
                title: 'GuitarQuest challenge progress'
                text: "Congratulations! You completed the challenge \"#{challengeHelpers.getTitle(@type)}\" and earned #{@reward.credits} credits."

            if @reward.points?
              user.points += @reward.points if @reward.points?
              return Notification.send
                userId: @userId
                category: 'challenge'
                type: 'success'
                title: 'GuitarQuest challenge progress'
                text: "Congratulations! You completed the challenge \"#{challengeHelpers.getTitle(@type)}\" and earned #{@reward.points} points."

      .then =>
        user.save()
      .then =>
        next()
      .then null, (err) =>
        next()
    else
      next()
