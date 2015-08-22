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
          _id: {$in: models.map (model) -> model._id.toString()}
        .then (userPieces) ->
          userPiecesById = _.indexBy(userPieces, '_id')
          done(null, userPiecesById)
        .then null, ->
          done(null, {})
    get: (pieceModel, {userPiecesByPieceId}) ->
      userPiecesByPieceId[pieceModel._id.toString()]?.status
}
