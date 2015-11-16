Promise = require 'bluebird'

module.exports = (schema) ->

  # Level-up if experience points cross threshold
  # Note, this should come before quests
  schema.pre 'save', (next) ->
    levelHelper = require 'local_modules/level'

    return next() unless @isModified('pointsIntoCurrentLevel')
    totalLevelPoints = levelHelper.getTotalLevelPoints(@level)
    if @pointsIntoCurrentLevel > totalLevelPoints
      @level++
      @pointsIntoCurrentLevel -= totalLevelPoints # keep remainder for next level
    next()

  # Add quests when user first created or begins a new level.
  schema.pre 'save', (next) ->
    Quest = require 'local_modules/models/quest'

    Promise.try =>
      if @isNew
        Promise.all [
          # Quest.createInitialQuests({user: @})
          Quest.createQuest('level', {user: @})
        ]
    .then =>
      next()
    .then null, next
