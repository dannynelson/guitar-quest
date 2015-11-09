Promise = require 'bluebird'
_ = require 'lodash'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
# questFixtures = require './quest_fixtures'

selectRandomQuestLevel = (level) ->
  Math.ceil(Math.random() * level)

module.exports = (schema) ->
  schema.static 'generateInitialQuests', (userId) ->
    Quest = @
    Quest.create
      userId: userId
      name: 'Submit a video for a guitar piece'
      quantityToComplete: 1
      completed: false
      conditions:
        userPiece:
          'submissionVideoURL': {ne: null}
      reward:
        credit: 10

  schema.static 'generateMusicalEraQuest', (user) ->
    Quest = @
    questLevel = selectRandomQuestLevel(user.level)
    Quest.create
      userId: user._id
      name: "Complete 2 level #{questLevel}, #{era} era pieces with at least an 80% grade"
      quantityToComplete: 2
      conditions:
        userPiece:
          'grade': {gte: 0.8}
        piece:
          'level': questLevel
          'era': era
      reward:
        credit: 5 + (questLevel * 5)

  schema.static 'generateAnyPieceQuest', (user) ->
    Quest = @
    questLevel = selectRandomQuestLevel(user.level)
    Quest.create
      userId: user._id
      name: "Complete 3 level #{questLevel} pieces with at least an 80% grade"
      quantityToComplete: 3
      conditions:
        userPiece:
          'grade': {gte: 0.8}
        piece:
          'level': questLevel
      reward:
        credit: 5 + (questLevel * 5)

  schema.static 'generatePerfectGradeQuest', (user) ->
    Quest = @
    questLevel = selectRandomQuestLevel(user.level)
    Quest.create
      userId: user._id
      name: "Complete 2 level #{questLevel} pieces with a 100% grade"
      quantityCompleted: 0
      quantityToComplete: 3
      conditions:
        userPiece:
          'grade': 1
        piece:
          'level': questLevel
      reward:
        credit: 5 + (questLevel * 5)

  schema.static 'generateRandomQuest', (user) ->
    Quest = @
    questTypes = ['generateMusicalEraQuest', 'generateAnyPieceQuest', 'generatePerfectGradeQuest']
    questType = questTypes[Math.floor(Math.random()*questTypes.length)]
    Quest[questType](user)

  schema.static 'progressMatchingQuests', (userId, {userPiece}) ->
    Piece = require 'local_modules/models/piece'
    piece = null

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
      isMatch

    Quest = @
    Promise.all([
      Quest.find {userId: userId, completed: {$ne: true}}
      Piece.findById(userPiece.pieceId)
    ]).then ([quests, _piece]) ->
      piece = _piece
      Promise.each quests, (quest) =>
        return unless meetsConditions(quest)
        quest.quantityCompleted ?= 0
        quest.quantityCompleted++
        quest.save()
