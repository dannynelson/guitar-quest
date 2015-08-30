_ = require 'lodash'
ResourceSchema = require 'resource-schema'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'

module.exports = new ResourceSchema Piece, {
  '_id'
  'name'
  'composer'
  'level'
  'era'
  'points'
  'sheetMusicURL'
  'spotifyURI'
  'description'
  'status':
    resolve:
      'userPiecesByPieceId': ({models}, done) ->
        UserPiece.find
          pieceId: {$in: models.map (model) -> model._id.toString()}
        .then (userPieces) ->
          userPiecesByPieceId = _.indexBy(userPieces, 'pieceId')
          done(null, userPiecesByPieceId)
        .then null, ->
          done(null, {})
    get: (pieceModel, {userPiecesByPieceId}) ->
      userPiecesByPieceId[pieceModel._id.toString()]?.status
}
