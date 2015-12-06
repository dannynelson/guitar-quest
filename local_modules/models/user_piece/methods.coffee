Promise = require 'bluebird'
_ = require 'lodash'
joi = require 'joi'
Notification = require 'local_modules/models/notification'
Piece = require 'local_modules/models/piece'
sendgrid = require 'local_modules/sendgrid'
settings = require 'local_modules/settings'
levelHelper = require 'local_modules/level'

module.exports = (schema) ->
  schema.method 'gradePiece', ({grade, comment, updatedBy}) ->
    Notification = require 'local_modules/models/notification'
    User = require 'local_modules/models/userPiece'

    userPiece = @
    userPiece.updatedBy = updatedBy
    previousGrade = userPiece.grade
    userPiece.grade = grade
    userPiece.comment = comment
    userPiece.waitingToBeGraded = false

    Promise.props
      user: User.findById(userPiece.userId)
      piece: Piece.findById(userPiece.pieceId)
    .then ({user, piece}) ->
      pointsEarned = calculatePointsEarned
        previousGrade: previousGrade
        newGrade: userPiece.grade
        pieceLevel: piece.level
      Promise.all [
        user.addPoints(pointsEarned)
        Notification.createNew('pieceGraded', {piece, userPiece}, {sendEmail: true})
      ]
    .then ->
      userPiece.save()

  return schema

calculatePointsEarned = ({previousGrade, newGrade, pieceLevel}={}) ->
  joi.assert previousGrade, joi.number().required(), 'previousGrade'
  joi.assert newGrade, joi.number().required(), 'newGrade'
  joi.assert pieceLevel, joi.number().required(), 'pieceLevel'
  piecePoints = levelHelper.getPointsPerPiece(pieceLevel)
  # important that we multiply to be an integer first so that we do not get JS math issues
  pointsEarned = (newGrade * piecePoints) - (previousGrade * piecePoints)
