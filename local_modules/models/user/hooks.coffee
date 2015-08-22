initialQuests = require 'local_modules/models/quest/initial_quests'
UserQuest = require 'local_modules/models/quest'
levelHelper = require 'local_modules/level'
Promise = require 'bluebird'

module.exports = (schema) ->

  # Level-up if experience points cross threshold
  # Note, this should come before quests
  schema.pre 'save', (next) ->
    return next() unless @isModified('pointsIntoCurrentLevel')
    totalLevelPoints = levelHelper.getTotalLevelExp(@level)
    if @pointsIntoCurrentLevel > totalLevelPoints
      @level++
      @pointsIntoCurrentLevel -= totalLevelPoints # keep remainder for next level
    next()


  # Add new quests whenever user begins a new level
  schema.pre 'save', (next) ->
    Promise.try =>
      UserQuest.createInitialQuests(@_id) if @isNew
    .then =>
      UserQuest.createLevelQuests(user) if @isModified('level') and @level isnt 1
    .then =>
      next()
    .then null, next
