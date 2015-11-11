Promise = require 'bluebird'
_ = require 'lodash'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
pieceEnums = require 'local_modules/models/piece/enums'

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

  # if not already present
  schema.static 'generateMusicalEraQuest', (user) ->
    Quest = @
    questLevel = selectRandomQuestLevel(user.level)
    musicalEra = pieceEnums.musicalEras[Math.floor(Math.random() * pieceEnums.musicalEras.length)]
    quest =
      userId: user.id
      name: "Complete 2 level #{questLevel}, #{musicalEra} era pieces with at least an 80% grade."
      quantityToComplete: 2
      conditions:
        userPiece:
          'grade': {gte: 0.8}
        piece:
          'level': questLevel
          'era': musicalEra
      reward:
        credit: 5 + (questLevel * 5)

    Quest.count(quest).then (count) ->
      throw new Error 'already exists' if count >= 1
      Quest.create quest

  schema.static 'generateAnyPieceQuest', (user) ->
    Quest = @
    questLevel = selectRandomQuestLevel(user.level)
    console.log 'creating quest', {user}
    quest =
      userId: user.id
      name: "Complete any 3 level #{questLevel} pieces with at least an 80% grade"
      quantityToComplete: 3
      conditions:
        userPiece:
          'grade': {gte: 0.8}
        piece:
          'level': questLevel
      reward:
        credit: 5 + (questLevel * 5)
    Quest.count(quest).then (count) ->
      throw new Error 'already exists' if count >= 1
      Quest.create quest

  schema.static 'generatePerfectGradeQuest', (user) ->
    Quest = @
    questLevel = selectRandomQuestLevel(user.level)
    quest =
      userId: user.id
      name: "Complete any 2 level #{questLevel} pieces with a 100% grade"
      quantityCompleted: 0
      quantityToComplete: 2
      conditions:
        userPiece:
          'grade': 1
        piece:
          'level': questLevel
      reward:
        credit: 5 + (questLevel * 5)
    Quest.count(quest).then (count) ->
      throw new Error 'already exists' if count >= 1
      Quest.create quest

  schema.static 'generateRandomQuest', (user) ->
    Quest = @
    generateCount = 0
    generate = ->
      questTypes = ['generateMusicalEraQuest', 'generateAnyPieceQuest', 'generatePerfectGradeQuest']
      questType = questTypes[Math.floor(Math.random()*questTypes.length)]
      console.log {questType}
      Quest[questType](user).then null, (err) ->
        console.log {generateCount}
        throw new Error if generateCount++ >= 20
        generate()
    generate()

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
