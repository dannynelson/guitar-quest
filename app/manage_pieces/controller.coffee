_ = require 'lodash'
level = require 'local_modules/level'
userPieceHelers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (User, UserPiece, Piece, editPieceModal) ->
  @pieces = Piece.query()
  @editPiece = (piece) ->
    editPieceModal.open(piece).then ->
      @pieces = Piece.query()
  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
