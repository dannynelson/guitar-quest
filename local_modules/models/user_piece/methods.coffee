Promise = require 'bluebird'
_ = require 'lodash'

module.exports = (schema) ->
  schema.method 'gradePiece', ({grade, updatedBy}) ->
    userPiece = @
    userPiece.updatedBy = updatedBy
    userPiece.grade = grade
    userPiece.waitingToBeGraded = false
    userPiece.save()

  return schema
