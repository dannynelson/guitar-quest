initialQuests = require 'local_modules/models/quest/initial_quests'
UserQuest = require 'local_modules/models/quest'
Notification = require 'local_modules/models/notification'
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

  # Add quests when user first created or begins a new level.
  schema.pre 'save', (next) ->
    Promise.try =>
      UserQuest.createInitialQuests(@_id) if @isNew
    .then =>
      UserQuest.createLevelQuests(@) if @isModified('level') and @level isnt 1
    .then =>
      next()
    .then null, next

  # Add initial notifications for new user
  schema.pre 'save', (next) ->
    if @isNew
      Notification.create([
        {
          userId: @_id
          category: 'piece'
          type: 'info'
          text: 'Welcome to GuitarQuest! In this section, you will learn pieces to earn experience points and progress to higher levels. With each new level, you will unlock new, more challenging pieces. If you have previous experience playing guitar, you can take the initial assessment to start at a higher level. Otherwise, click on a piece below to get started.'
          acknowledged: false
        }
        {
          userId: @_id
          category: 'quest'
          type: 'info'
          text: 'In this section, you can track the progress of all your active quests. Once you complete a quest, you will earn credits for buying private video lessons with a GuitarQuest teacher.'
          acknowledged: false
        }
        {
          userId: @_id
          category: 'tutorial'
          type: 'info'
          text: 'Use these tutorials as a resource to help you while learn new pieces.'
          acknowledged: false
        }
      ]).then =>
        next()
      .then null, next
    else
      next()
