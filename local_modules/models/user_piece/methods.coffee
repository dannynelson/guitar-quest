Promise = require 'bluebird'
_ = require 'lodash'

module.exports = (schema) ->
  schema.method 'gradePiece', ({grade, comment, updatedBy}) ->
    userPiece = @
    userPiece.updatedBy = updatedBy
    userPiece.grade = grade
    userPiece.comment = comment
    userPiece.waitingToBeGraded = false
    userPiece.save()

  return schema
