User = require 'local_modules/models/user'
Promise = require 'bluebird'

module.exports = (schema) ->

  # When quest finished, give reward to user, complete the quest, and notifify user
  schema.pre 'save', (next) ->
    if @isModified('quantityCompleted') and @quantityCompleted is @quantityToComplete
      @completed = true
      User.findById(@userId).then (user) =>
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
      .then null, next
    else
      next()
