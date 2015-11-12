Promise = require 'bluebird'
logger = require 'local_modules/logger'

module.exports = (schema) ->

  schema.pre 'save', (next) ->
    if @isModified('quantityCompleted')
      logger.warn 'Do not set quantityCompleted. It is automatically set as the sum of completed pieces.'
    @piecesCompleted ?= []
    @quantityCompleted = @piecesCompleted.length
    next()

  # Notify if progress made on quest, and if a quest is completed, give the user credit
  schema.pre 'save', (next) ->
    Notification = require 'local_modules/models/notification'
    User = require 'local_modules/models/user'

    if @isModified('quantityCompleted')
      Promise.try =>
        if 0 < @quantityCompleted < @quantityToComplete
          notification = new Notification
            userId: @userId
            category: 'quest'
            type: 'info'
            text: "You completed #{@quantityCompleted}/#{@quantityToComplete} of the quest \"#{@name}\""
            acknowledged: false
          notification.save()

        else if @quantityCompleted is @quantityToComplete
          User.findById(@userId).then (user) =>
            @completed = true
            user.credits += @reward.credits

            notification = new Notification
              userId: @userId
              category: 'quest'
              type: 'success'
              text: "Congratulations! You completed the quest \"#{@name}\" and earned #{@reward.credits} credits."
              acknowledged: false

            notification.save().then => user.save()
      .then =>
        next()
      .then null, (err) =>
        next()
    else
      next()
