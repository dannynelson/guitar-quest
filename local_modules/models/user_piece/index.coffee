###
Track user progress as they work on a piece
###

mongoose = require 'mongoose'
Promise = require 'bluebird'
_ = require 'lodash'
userPieceEnums = require './enums'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
database = require 'local_modules/database'
levelHelper = require 'local_modules/level'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'

JSONSchemaClone = do ->
  clone = _.cloneDeep(JSONSchema)
  delete clone.properties.createdAt
  delete clone.properties.updatedAt
  clone

schema = JSONSchemaConverter.toMongooseSchema(JSONSchemaClone, mongoose)

# named gradePiece b/c you cannot name method the same as a property
# https://github.com/Automattic/mongoose/issues/1383
schema.methods.gradePiece = Promise.method ({grade, comment, updatedBy}={}) ->
  joi.assert grade, joi.number().valid(userPieceEnums.grades).required(), 'grade'
  joi.assert comment, joi.string().required(), 'comment'
  joi.assert updatedBy, joi.objectId().required(), 'updatedBy'

  Notification = require 'local_modules/models/notification'
  User = require 'local_modules/models/user'
  Piece = require 'local_modules/models/piece'
  Challenge = require 'local_modules/models/challenge'

  @updatedBy = updatedBy
  previousGrade = @grade
  @grade = grade
  @comment = comment
  @waitingToBeGraded = false

  Promise.props
    user: User.findById(@userId)
    piece: Piece.findById(@pieceId)
  .then ({user, piece}) =>
    pointsEarned = calculatePointsEarned
      previousGrade: previousGrade
      newGrade: @grade
      pieceLevel: piece.level
    Promise.all [
      user.addPoints(pointsEarned)
      Notification.createNew('pieceGraded', {piece, userPiece: @}, {sendEmail: true})
      Challenge.progressMatchingChallenges @userId, {userPiece: @}
    ]
  .then =>
    @save()

schema.plugin require('mongoose-timestamp')
require('./hooks')(schema)
require('./virtuals')(schema)
model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model

calculatePointsEarned = ({previousGrade, newGrade, pieceLevel}={}) ->
  joi.assert previousGrade, joi.number().required(), 'previousGrade'
  joi.assert newGrade, joi.number().required(), 'newGrade'
  joi.assert pieceLevel, joi.number().required(), 'pieceLevel'
  piecePoints = levelHelper.getPointsPerPiece(pieceLevel)
  # important that we multiply to be an integer first so that we do not get JS math issues
  pointsEarned = (newGrade * piecePoints) - (previousGrade * piecePoints)
