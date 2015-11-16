_ = require 'lodash'
level = require 'local_modules/level'
userPieceHelers = require 'local_modules/models/user_piece/helpers'

module.exports = ngInject (User, UserPiece, Piece) ->
  @level = level
  @user = User.getLoggedInUser()
  @user.$reload() # reload whenever we come back to this page for latest level/points/credits
  @selectedLevel = @user.level
  @levelHelper = level

  @getStatus = (userPiece) ->
    return unless userPiece?
    userPieceHelers.getStatus()

  UserPiece.query({userId: @user._id}).$promise.then (userPieces) =>
    @userPieceByPieceId = _.indexBy(userPieces, 'pieceId')

  setPieces = (level) =>
    @pieces = Piece.query({level})
    @levelPoints =
      piece: @levelHelper.getPointsPerPiece(@selectedLevel)
      completed: @levelHelper.calculatePointsIntoLevel(@user.points, @selectedLevel)
      total: @levelHelper.getTotalLevelPoints(@selectedLevel)

  setPieces(@selectedLevel)

  @goToNextLevel = =>
    @selectedLevel++
    setPieces(@selectedLevel)

  @goToPreviousLevel = =>
    @selectedLevel--
    setPieces(@selectedLevel)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
