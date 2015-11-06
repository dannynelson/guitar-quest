module.exports =
  getStatus: (userPiece) ->
    if userPiece.waitingToBeGraded
      'submitted'
    else if userPiece.grade?
      'graded'
