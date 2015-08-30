Promise = require 'bluebird'
_ = require 'lodash'
intialQuests = require './initial_quests'
levelQuests = require './level_quests'

module.exports = (schema) ->
  schema.static 'createInitialQuests', (userId) ->
    Quest = @
    Quest.create intialQuests.generate(userId)

  schema.static 'createLevelQuests', (user) ->
    Quest = @
    newQuests = levelQuests.generate(user)
    notification = new Notification
      userId: @userId
      category: 'quest'
      type: 'info'
      text: "You have #{newQuests.length} new quests."
      acknowledged: false
    Quest.create newQuests

  schema.static 'checkForProgress', (userId, models) ->
    meetsConditions = (obj, conditions) ->
      cleanedModels = JSON.parse JSON.stringify models
      conditions = JSON.parse JSON.stringify conditions
      _.isMatch(obj, conditions)

    Quest = @
    Quest.find
      userId: userId
      completed: {$ne: true}
    .then (quests) ->
      Promise.each quests, (quest) =>
        return Promise.resolve() unless meetsConditions(models, quest.conditions)
        quest.quantityCompleted ?= 0
        quest.quantityCompleted++
        Promise.resolve(quest.save())
