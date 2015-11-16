Promise = require 'bluebird'

module.exports = (schema) ->

  # Level-up if experience points cross threshold
  # Note, this should come before challenges
  schema.pre 'save', (next) ->
    levelHelper = require 'local_modules/level'

    return next() unless @isModified('pointsIntoCurrentLevel')
    totalLevelPoints = levelHelper.getTotalLevelPoints(@level)
    if @pointsIntoCurrentLevel > totalLevelPoints
      @level++
      @pointsIntoCurrentLevel -= totalLevelPoints # keep remainder for next level
    next()

  # Add challenges when user first created or begins a new level.
  schema.pre 'save', (next) ->
    Challenge = require 'local_modules/models/challenge'

    Promise.try =>
      if @isNew
        Promise.all [
          # Challenge.createInitialChallenges({user: @})
          Challenge.createChallenge('level', {user: @})
        ]
    .then =>
      next()
    .then null, next
