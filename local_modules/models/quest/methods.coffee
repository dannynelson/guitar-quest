Promise = require 'bluebird'
_ = require 'lodash'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
intialQuestFixtures = require './initial_quest_fixtures'
questFixtures = require './quest_fixtures'

module.exports = (schema) ->
  schema.static 'createInitialQuests', (userId) ->
    Quest = @
    Quest.create intialQuestFixtures.generate(userId)

  schema.static 'createRandomQuest', (user) ->
    Quest = @
    newQuests = questFixtures.generate(user)
    notification = new Notification
      userId: @userId
      category: 'quest'
      type: 'info'
      text: "You have #{newQuests.length} new quests."
      acknowledged: false
    Quest.create newQuests

  schema.static 'checkForProgress', (userId, {piece, userPiece}) ->
    meetsConditions = (quest) ->
      models = {piece, userPiece}
      cleanedModels = JSON.parse JSON.stringify models
      conditions = JSON.parse JSON.stringify quest.conditions
      isMatch = _.isMatch models, conditions, (value, other) ->
        # {ne: null}
        if other?.ne is null
          return true if value?
        # {gte: Number}
        else if other?.gte?
          return value >= other.gte
      console.log {isMatch}

    Quest = @
    Quest.find
      userId: userId
      completed: {$ne: true}
    .then (quests) ->
      Promise.each quests, (quest) =>
        return unless meetsConditions(quest)
        quest.quantityCompleted ?= 0
        quest.quantityCompleted++
        quest.save()
