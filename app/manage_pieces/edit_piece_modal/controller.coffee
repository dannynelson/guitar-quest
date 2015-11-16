module.exports = ngInject (piece, Piece, $modalInstance) ->
  if piece?
    @piece = angular.copy piece
  else
    @piece = new Piece()

  @updatePiece = =>
    method = if @piece._id then '$update' else '$save'
    @piece[method]()
    $modalInstance.close()

  return @
