###
Helpers for working with notifications
###

_ = require 'lodash'
settings = require 'local_modules/settings'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
levelHelper = require 'local_modules/level'
pieceEnums = require 'local_modules/models/piece/enums'
userPieceEnums = require 'local_modules/models/user_piece/enums'
notificationEnums = require 'local_modules/models/notification/enums'

chooseRandom = (items) ->
  items[Math.floor(Math.random() * items.length)]

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

buildNotification = ({userId, type, params}={}) ->
  joi.assert userId, joi.objectId().required(), 'userId'
  joi.assert type, joi.string().valid(notificationEnums.notificationTypes).required(), 'type'
  joi.assert params, joi.object(), 'params'

  return {
    userId: userId
    type: type
    params: params
    isRead: false
  }


notificationDefinitions =
  'pieceGraded':
    title: ({notification}) ->
      "Video submission for #{notification.params.pieceName} graded"
    description: ({notification}) ->
      "Your video submission for #{notification.params.pieceName} was graded #{notification.params.grade * 100} and you received teacher feedback."
    link: ({notification}) ->
      "#{settings.server.url}/pieces/#{notification.params.pieceId}"
    notification: ({user, piece, userPiece}={}) ->
      buildNotification
        userId: user._id.toString()
        type: 'pieceGraded'
        params:
          pieceId: piece._id.toString()
          pieceName: piece.name
          grade: userPiece.grade
          comment: userPiece.comment

  'challengeProgressed':
    title: ({notification}) ->
      "You made a progress on a challenge"
    description: ({notification}) ->
      "Your video submission for #{notification.params.pieceName} was graded #{notification.params.grade * 100} and you received teacher feedback."
    link: ({notification}) ->
    notification: ({user, piece, userPiece}={}) ->
      buildNotification
        userId: user._id.toString()
        type: 'pieceGraded'
        params:
          pieceName: piece.name
          grade: userPiece.grade
          comment: userPiece.comment

module.exports = notificationHelpers =
  getTitle: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.title({notification})

  getDescription: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.description({notification})

  getEmail: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.description({notification})

  generateChallenge: (type, {user}) ->
    joi.assert user, joi.object().required(), 'user'
    notificationDefinitions[type].notification({user})

  generateInitialChallenges: ({user}) ->
    joi.assert user, joi.object().required(), 'user'
    notificationEnums.initialChallengeTypes.map (notificationType) ->
      notificationHelpers.generateChallenge(notificationType, {user})

  generateRandomChallenge: ({user, excludeChallengeTypes}={}) ->
    excludeChallengeTypes ?= []
    joi.assert user, joi.object().required(), 'user'
    joi.assert excludeChallengeTypes, joi.array().items(joi.string().valid(notificationEnums.notificationTypes)), 'excludeChallengeTypes'
    availableChallengeTypes = _.difference(notificationEnums.genericChallengeTypes, excludeChallengeTypes)
    notificationType = chooseRandom(availableChallengeTypes)
    notificationHelpers.generateChallenge(notificationType, {user})

  matchesConditions: (notification, {piece, userPiece, user}) ->
    joi.assert notification, joi.object().required(), 'notification'
    joi.assert piece, joi.object().required(), 'piece'
    joi.assert userPiece, joi.object().required(), 'userPiece'
    joi.assert user, joi.object().required(), 'user'
    notificationDefinitions[notification.type].conditions({notification, piece, userPiece, user})
