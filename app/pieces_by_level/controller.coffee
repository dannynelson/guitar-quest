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
    @currentLevel = Number($stateParams.level)

  @levelPoints =
    piece: @levelHelper.getPointsPerPiece(@currentLevel)
    completed: @levelHelper.calculatePointsIntoLevel(@user.points, @currentLevel)
    total: @levelHelper.getTotalLevelPoints(@currentLevel)

  @getStatus = (userPiece) ->
    return unless userPiece?
    userPieceHelers.getStatus()

  setPieces = =>
    @isLoadingPieces = true
    @userCanLearnPieces = @currentLevel is 1 or roles.can(@user.roles, 'learnAdvancedPieces')
    Piece.query({level: @currentLevel}).$promise
    .then (pieces) =>
      @pieces = pieces
      UserPiece.query
        userId: @user._id
        pieceId: _.map(@pieces, '_id')
      .$promise
    .then (userPieces) =>
      @userPieceByPieceId = _.indexBy(userPieces, 'pieceId')
    .finally =>
      @isLoadingPieces = false
  setPieces()

  @goToNextLevel = =>
    $state.go $state.current.name, {level: @currentLevel + 1}

  @goToPreviousLevel = =>
    $state.go $state.current.name, {level: @currentLevel - 1}

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
