logger = require 'local_modules/logger'
levelHelper = require 'local_modules/level'
Promise = require 'bluebird'

module.exports = (schema) ->

  # Add challenges when user first created or begins a new level.
  schema.pre 'save', (next) ->
    Challenge = require 'local_modules/models/challenge'

    Promise.try =>
      if @isNew
        Promise.all [
          Challenge.createInitialChallenges({user: @})
          Challenge.createChallenge('level', {user: @})
        ]
    .then =>
      next()
    .then null, next
