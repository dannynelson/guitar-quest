_ = require 'lodash'
intialQuests = require './initial_quests'
levelQuests = require './level_quests'

module.exports = (schema) ->
  schema.static 'createInitialQuests', (userId) ->
    Quest = @
    Quest.create intialQuests.generate(userId)

  schema.static 'createLevelQuests', (user) ->
    Quest = @
    Quest.create levelQuests.generate(user)

