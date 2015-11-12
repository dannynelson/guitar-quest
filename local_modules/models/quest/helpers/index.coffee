###
Helpers for working with quests
###

_ = require 'lodash'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
pieceEnums = require 'local_modules/models/piece/enums'
userPieceEnums = require 'local_modules/models/user_piece/enums'
questEnums = require 'local_modules/models/quest/enums'

chooseRandom = (items) ->
  items[Math.floor(Math.random() * items.length)]

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

buildQuest = ({userId, type, quantityToComplete, params, credits}={}) ->
  joi.assert userId, joi.objectId().required(), 'userId'
  joi.assert type, joi.string().valid(questEnums.questTypes).required(), 'type'
  joi.assert quantityToComplete, joi.number().integer().required(), 'quantityToComplete'
  joi.assert params, joi.object().required(), 'params'
  joi.assert credits, joi.number().integer().required(), 'credits'

  userId: userId
  type: type
  quantityToComplete: quantityToComplete
  completed: false
  params: params
  reward:
    credits: credits

questDefinitions =
  # ================== initial =========================
  'firstVideo':
    title: ({quest}) -> "Submit First Video"
    description: ({quest}) -> "Submit a video for any guitar piece."
    quest: ({user}) ->
      buildQuest
        userId: user._id.toString()
        type: 'firstVideo'
        quantityToComplete: 1
        params: {}
        credits: 10
    conditions: ({quest, piece, userPiece, user}) ->
      userPiece.submissionVideoURL?

  # ==================== generic ==========================
  'level':
    title: ({quest}) -> "Level #{quest.params.level} Practice"
    description: ({quest}) -> "Complete any 3 pieces from level #{quest.params.level} with at least an 80% grade."
    quest: ({user}) ->
      questLevel = _.random(1, user.level)
      buildQuest
        userId: user._id.toString()
        type: 'level'
        quantityToComplete: 3
        params:
          'level': questLevel
        credits: 8 + (2 * questLevel)
    conditions: ({quest, piece, userPiece, user}) ->
      userPiece.grade >= 0.8 and piece.level is quest.params.level

  'era':
    title: ({quest}) -> "#{capitalize(quest.params.era)} Era Practice"
    description: ({quest}) -> "Complete any 2 #{quest.params.era} era pieces from your current level with at least an 80% grade."
    quest: ({user}) ->
      userId: user._id.toString()
      type: 'era'
      quantityToComplete: 2
      params:
        'era': chooseRandom(pieceEnums.musicalEras)
      credits: chooseRandom([10, 15])
    conditions: ({quest, piece, userPiece, user}) ->
      isCurrentLevel = piece.level is user.level
      isCorrectEra = piece.era is quest.params.era
      isGoodGrade = userPiece.grade >= 0.8
      return isCurrentLevel and isGoodGrade and isCorrectEra

  'sightReading':
    title: ({quest}) -> "Sight Reading Practice"
    description: ({quest}) -> "Submit videos for any 6 pieces (grade does not matter)."
    quest: ({user}) ->
      buildQuest
        userId: user._id.toString()
        type: 'sightReading'
        quantityToComplete: 6
        params: {}
        credits: chooseRandom([10, 15])
    conditions: ({quest, piece, userPiece, user}) ->
      isSubmitted = userPiece.submissionVideoURL?
      return isSubmitted

  'perfectGrade':
    title: ({quest}) -> "Perfect Grade"
    description: ({quest}) -> "Complete any 2 pieces from your current level with a 100% grade."
    quest: ({user}) ->
      buildQuest
        userId: user._id.toString()
        type: 'perfectGrade'
        quantityToComplete: 2
        params: {}
        credits: chooseRandom([10, 15])
    conditions: ({quest, piece, userPiece, user}) ->
      isCurrentLevel = piece.level is user.level
      isPerfectGrade = userPiece.grade is 1
      return isCurrentLevel and isPerfectGrade

  # 'technique':

  # 'composer':

module.exports = questHelpers =
  getTitle: (quest) ->
    joi.assert quest, joi.object().required(), 'quest'
    questDefinitions[quest.type]?.title({quest})

  getDescription: (quest) ->
    joi.assert quest, joi.object().required(), 'quest'
    questDefinitions[quest.type]?.description({quest})

  generateQuest: (type, {user}) ->
    joi.assert user, joi.object().required(), 'user'
    questDefinitions[type].quest({user})

  generateInitialQuests: ({user}) ->
    joi.assert user, joi.object().required(), 'user'
    questEnums.initialQuestTypes.map (questType) ->
      questHelpers.generateQuest(questType, {user})

  generateRandomQuest: ({user}) ->
    joi.assert user, joi.object().required(), 'user'
    questType = chooseRandom(questEnums.genericQuestTypes)
    questHelpers.generateQuest(questType, {user})

  matchesConditions: (quest, {piece, userPiece, user}) ->
    joi.assert quest, joi.object().required(), 'quest'
    joi.assert piece, joi.object().required(), 'piece'
    joi.assert userPiece, joi.object().required(), 'userPiece'
    joi.assert user, joi.object().required(), 'user'
    questDefinitions[quest.type].conditions({quest, piece, userPiece, user})
