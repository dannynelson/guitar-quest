###
Helpers for working with challenges
###

_ = require 'lodash'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
levelHelper = require 'local_modules/level'
pieceEnums = require 'local_modules/models/piece/enums'
userPieceEnums = require 'local_modules/models/user_piece/enums'
challengeEnums = require 'local_modules/models/challenge/enums'

chooseRandom = (items) ->
  items[Math.floor(Math.random() * items.length)]

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

buildChallenge = ({userId, type, quantityToComplete, params, credits, points}={}) ->
  joi.assert userId, joi.objectId().required(), 'userId'
  joi.assert type, joi.string().valid(challengeEnums.challengeTypes).required(), 'type'
  joi.assert quantityToComplete, joi.number().integer().required(), 'quantityToComplete'
  joi.assert params, joi.object().required(), 'params'
  joi.assert credits, joi.number().integer(), 'credits'
  joi.assert credits, joi.number().integer(), 'points'
  if not credits? and not points?
    throw new Error 'Must specify a reward'

  return {
    userId: userId
    type: type
    quantityToComplete: quantityToComplete
    completed: false
    params: params
    reward:
      credits: credits
  }


challengeDefinitions =
  # ================== initial =========================
  'firstVideo':
    title: ({challenge}) -> "Submit First Video"
    description: ({challenge}) -> "Submit a video for any guitar piece."
    challenge: ({user}) ->
      buildChallenge
        userId: user._id.toString()
        type: 'firstVideo'
        quantityToComplete: 1
        params: {}
        credits: 5
    conditions: ({challenge, piece, userPiece, user}) ->
      userPiece.submissionVideoURL?

  # ==================== generic ==========================
  'level':
    title: ({challenge}) -> "#{levelHelper.getLevelName(challenge.params.level)} Practice"
    description: ({challenge}) -> "Complete any 3 pieces from level #{challenge.params.level} with at least an 80% grade."
    challenge: ({user}) ->
      challengeLevel = _.random(0, user.level)
      buildChallenge
        userId: user._id.toString()
        type: 'level'
        quantityToComplete: 3
        params:
          'level': challengeLevel
        credits: 5
    conditions: ({challenge, piece, userPiece, user}) ->
      userPiece.grade >= 0.8 and piece.level is challenge.params.level

  'era':
    title: ({challenge}) -> "#{capitalize(challenge.params.era)} Era Practice"
    description: ({challenge}) -> "Complete any 2 #{challenge.params.era} era pieces from your current level with at least an 80% grade."
    challenge: ({user}) ->
      buildChallenge
        userId: user._id.toString()
        type: 'era'
        quantityToComplete: 2
        credits: 5
        params:
          'era': chooseRandom(pieceEnums.musicalEras)
    conditions: ({challenge, piece, userPiece, user}) ->
      isCurrentLevel = piece.level is user.level
      isCorrectEra = piece.era is challenge.params.era
      isGoodGrade = userPiece.grade >= 0.8
      return isCurrentLevel and isGoodGrade and isCorrectEra

  'sightReading':
    title: ({challenge}) -> "Sight Reading Practice"
    description: ({challenge}) -> "Submit videos for any 6 pieces (grade does not matter)."
    challenge: ({user}) ->
      buildChallenge
        userId: user._id.toString()
        type: 'sightReading'
        quantityToComplete: 6
        params: {}
        credits: 5
    conditions: ({challenge, piece, userPiece, user}) ->
      isSubmitted = userPiece.submissionVideoURL?
      return isSubmitted

  'perfectGrade':
    title: ({challenge}) -> "Perfect Grade"
    description: ({challenge}) -> "Complete any 2 pieces from your current level with a 100% grade."
    challenge: ({user}) ->
      buildChallenge
        userId: user._id.toString()
        type: 'perfectGrade'
        quantityToComplete: 2
        params: {}
        credits: 5
    conditions: ({challenge, piece, userPiece, user}) ->
      isCurrentLevel = piece.level is user.level
      isPerfectGrade = userPiece.grade is 1
      return isCurrentLevel and isPerfectGrade

  # 'technique':

  # 'composer':

module.exports = challengeHelpers =
  getTitle: (challenge) ->
    joi.assert challenge, joi.object().required(), 'challenge'
    challengeDefinitions[challenge.type]?.title({challenge})

  getDescription: (challenge) ->
    joi.assert challenge, joi.object().required(), 'challenge'
    challengeDefinitions[challenge.type]?.description({challenge})

  generateChallenge: (type, {user}) ->
    joi.assert user, joi.object().required(), 'user'
    challengeDefinitions[type].challenge({user})

  generateInitialChallenges: ({user}) ->
    joi.assert user, joi.object().required(), 'user'
    challengeEnums.initialChallengeTypes.map (challengeType) ->
      challengeHelpers.generateChallenge(challengeType, {user})

  generateRandomChallenge: ({user, excludeChallengeTypes}={}) ->
    excludeChallengeTypes ?= []
    joi.assert user, joi.object().required(), 'user'
    joi.assert excludeChallengeTypes, joi.array().items(joi.string().valid(challengeEnums.challengeTypes)), 'excludeChallengeTypes'
    availableChallengeTypes = _.difference(challengeEnums.genericChallengeTypes, excludeChallengeTypes)
    challengeType = chooseRandom(availableChallengeTypes)
    challengeHelpers.generateChallenge(challengeType, {user})

  matchesConditions: (challenge, {piece, userPiece, user}) ->
    joi.assert challenge, joi.object().required(), 'challenge'
    joi.assert piece, joi.object().required(), 'piece'
    joi.assert userPiece, joi.object().required(), 'userPiece'
    joi.assert user, joi.object().required(), 'user'
    challengeDefinitions[challenge.type].conditions({challenge, piece, userPiece, user})
