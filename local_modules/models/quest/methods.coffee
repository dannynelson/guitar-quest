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

