Promise = require 'bluebird'
_ = require 'lodash'
Promise = require 'bluebird'
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
    userPiece.save()

  return schema
