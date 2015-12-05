###
Helpers for working with notifications
###

_ = require 'lodash'
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
        <strong>Danny Nelson</strong> graded your video submission for <em>#{notification.params.pieceName}</em>
        <strong>#{notification.params.grade * 100}%</strong> and left a comment.
      "
    link: ({notification, serverUrl}) ->
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
          credits = challenge.reward.credits
          " and earned <strong>$#{credits} lesson credits</strong>"
        else
          ''
      return "
        Completed <strong>#{challenge.quantityCompleted}/#{challenge.quantityToComplete}</strong>
        of challenge <strong>#{challengeHelpers.getTitle(challenge)}</strong>#{rewardText}
      "
    link: ({notification, serverUrl}) ->
      "#{serverUrl}/#/challenges"
    notification: ({challenge}={}) ->
      buildNotification
        userId: challenge.userId.toString()
        type: 'challengeProgressed'
        params:
          challenge: challenge

module.exports = notificationHelpers =
  getTitle: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.title({notification})

  getDescription: (notification) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.description({notification})

  getLink: ({notification, serverUrl}) ->
    joi.assert notification, joi.object().required(), 'notification'
    notificationDefinitions[notification.type]?.link({notification, serverUrl})

  generateNotification: (type, params) ->
    joi.assert type, joi.string().valid(notificationEnums.notificationTypes).required(), 'type'
    joi.assert params, joi.object().required(), 'params'
    notificationDefinitions[type].notification(params)
