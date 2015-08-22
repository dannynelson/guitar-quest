initialQuests = require 'local_modules/models/quest/initial_quests'
UserQuest = require 'local_modules/models/quest'
Promise = require 'bluebird'

module.exports = (schema) ->

  schema.pre 'save', (next) ->
    Promise.try =>
      UserQuest.createInitialQuests(@_id) if @isNew
    .then =>
      UserQuest.createLevelQuests(user) if @isModified('level') and @level isnt 1
    .then =>
      next()
    .then null, next
