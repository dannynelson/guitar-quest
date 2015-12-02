###
Helpers for working with notifications
###

_ = require 'lodash'
# serverUrl = require('local_modules/settings').server.url
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
notificationEnums = require 'local_modules/models/notification/enums'
challengeHelpers = require 'local_modules/models/challenge/helpers'

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
      "Video submission for #{notification.params.pieceName} graded #{notification.params.grade * 100}%"
    description: ({notification}) ->
      "
        Your video submission for #{notification.params.pieceName} was graded
        #{notification.params.grade * 100}% and you received a teacher comment.
      "
    link: ({notification}) ->
      "#{serverUrl}/#/pieces/#{notification.params.pieceId}"
    notification: ({piece, userPiece}={}) ->
      buildNotification
        userId: userPiece.userId.toString()
        type: 'pieceGraded'
        params:
          pieceId: piece._id.toString()
          pieceName: piece.name
          grade: userPiece.grade
          comment: userPiece.comment

  'challengeProgressed':
    title: ({notification}) ->
      challenge = notification.params.challenge
      "
        Completed #{challenge.quantityCompleted}/#{challenge.quantityToComplete}
        of challenge \"#{challengeHelpers.getTitle(challenge)}\"
      "
    description: ({notification}) ->
      challenge = notification.params.challenge
      rewardText =
        if challenge.quantityCompleted is challenge.quantityToComplete
          credits = challenge.rewards.credits
          " and you earned $#{credits} lesson credits"
        else
          ''
      return "
        Completed #{challenge.quantityCompleted}/#{challenge.quantityToComplete}
        of challenge \"#{challengeHelpers.getTitle(challenge)}\"#{rewardText}
      "
    link: ({notification}) ->
      "#{serverUrl}/#/challenges"
    notification: ({challenge}={}) ->
      buildNotification
        userId: challenge.userId.toString()
        type: 'pieceGraded'
        params:
          challenge: challenge

module.exports = notificationHelpers =
  getTitle: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.title({notification})

  getDescription: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.description({notification})

  getLink: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.link({notification})

  generateNotification: (type, params) ->
    joi.assert user, joi.object().required(), 'user'
    notificationDefinitions[type].notification(params)
