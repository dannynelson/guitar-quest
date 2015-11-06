_ = require 'lodash'
level = require 'local_modules/level'

module.exports = ngInject (User, Piece) ->
  @level = level
  @user = User.getLoggedInUser()
  @selectedLevel = @user.level
  @levelHelper = level

  setPieces = (level) =>
    @pieces = Piece.query({level})
    @levelPoints =
      piece: @levelHelper.getPointsPerPiece(@user.level)
      completed: if @selectedLevel is @user.level then @user.pointsIntoCurrentLevel else @levelHelper.getTotalLevelExp(@selectedLevel)
      total: @levelHelper.getTotalLevelExp(@selectedLevel)

  setPieces(@selectedLevel)

  @goToNextLevel = =>
    @selectedLevel++
    setPieces(@selectedLevel)

  @goToPreviousLevel = =>
    @selectedLevel--
    setPieces(@selectedLevel)

  @getExpToNextLevel = =>
    level.getExpToNextLevel(@user.exp, @user.level)

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
