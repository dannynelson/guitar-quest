User = require 'local_modules/models/user'
Promise = require 'bluebird'

module.exports = (schema) ->

  # Whenever quantity changes on quest, notify user
  schema.pre 'save', (next) ->
    if @isModified('quantityCompleted')
      @notify = true
    next()


  # When quest finished, give reward to user, and complete the quest
  schema.pre 'save', (next) ->
    if @isModified('quantityCompleted') and @quantityCompleted is @quantityToComplete
      @completed = true
      User.findById(@userId).then (user) =>
        user.credit += @reward.credit
        user.save()
      .then =>
        next()
      .then null, next
    else
      next()
