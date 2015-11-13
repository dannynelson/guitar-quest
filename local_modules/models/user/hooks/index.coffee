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
          Quest.createInitialQuests({user: @})
          Quest.createQuest('level', {user: @})
        ]
    .then =>
      next()
    .then null, next

  # Add initial notifications for new user
  schema.pre 'save', (next) ->
    Notification = require 'local_modules/models/notification'

    # if @isNew
    #   Notification.create([
    #     {
    #       userId: @_id
    #       category: 'piece'
    #       type: 'info'
    #       text: 'Welcome to GuitarQuest! In this section, you will find a collection of all the guitar pieces you can learn.  you will learn pieces to earn experience points and progress to higher levels. With each new level, you will unlock new, more challenging pieces. Click on a piece below to get started.'
    #       acknowledged: false
    #     }
    #     {
    #       userId: @_id
    #       category: 'quest'
    #       type: 'info'
    #       text: 'Complete quests to earn lesson credits and other rewards.'
    #       acknowledged: false
    #     }
    #   ]).then =>
    #     next()
    #   .then null, next
    # else
    #   next()
