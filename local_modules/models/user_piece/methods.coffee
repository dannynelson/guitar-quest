Promise = require 'bluebird'
_ = require 'lodash'
Notification = require 'local_modules/models/notification'
Piece = require 'local_modules/models/piece'
sendgrid = require 'local_modules/sendgrid'
settings = require 'local_modules/settings'

module.exports = (schema) ->
  schema.method 'gradePiece', ({grade, comment, updatedBy}) ->
    Notification = require 'local_modules/models/notification'

    userPiece = @
    userPiece.updatedBy = updatedBy
    userPiece.grade = grade
    userPiece.comment = comment
    userPiece.waitingToBeGraded = false
    Piece.findById(userPiece.pieceId).then (piece) ->
      Notification.createNew('pieceGraded', {piece, userPiece}, {sendEmail: true})
    .then ->
      userPiece.save()

  return schema
