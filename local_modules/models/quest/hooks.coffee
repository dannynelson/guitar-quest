Promise = require 'bluebird'

module.exports = (schema) ->

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
            user.credit += @reward.credit

            notification = new Notification
              userId: @userId
              category: 'quest'
              type: 'success'
              text: "Congratulations! You completed the quest \"#{@name}\" and earned $#{@reward.credit} lesson credit."
              acknowledged: false

            notification.save().then => user.save()
      .then =>
        next()
      .then null, (err) =>
        next()
    else
      next()
