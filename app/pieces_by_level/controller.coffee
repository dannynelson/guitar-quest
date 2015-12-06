_ = require 'lodash'
levelHelper = require 'local_modules/level'
userPieceHelers = require 'local_modules/models/user_piece/helpers'
roles = require 'local_modules/roles'

module.exports = ngInject (User, UserPiece, Piece, $stateParams, $state) ->
  @user = User.getLoggedInUser()
  @user.$reload() # reload whenever we come back to this page for latest level/points/credits
  @levelHelper = levelHelper

  if $stateParams.level is 'default'
    $state.go $state.current.name, {level: @user.level}
  else
    @currentLevel = $stateParams.level

  @getStatus = (userPiece) ->
    return unless userPiece?
    userPieceHelers.getStatus()

  UserPiece.query({userId: @user._id}).$promise.then (userPieces) =>
    @userPieceByPieceId = _.indexBy(userPieces, 'pieceId')

  setPieces = =>
    @userCanLearnPieces = @currentLevel is 1 or roles.can(@user.roles, 'learnAdvancedPieces')
    @pieces = Piece.query({level: @currentLevel})
    @levelPoints =
      piece: @levelHelper.getPointsPerPiece(@currentLevel)
      completed: @levelHelper.calculatePointsIntoLevel(@user.points, @currentLevel)
      total: @levelHelper.getTotalLevelPoints(@currentLevel)

  setPieces()

  @goToNextLevel = =>
    $state.go $state.current.name, {level: @currentLevel + 1}

  @goToPreviousLevel = =>
    $state.go $state.current.name, {level: @currentLevel - 1}

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
