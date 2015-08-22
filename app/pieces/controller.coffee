_ = require 'lodash'
level = require 'local_modules/level'

module.exports = ngInject (User, Piece) ->
  @user = User.getLoggedInUser()
  @selectedLevel = @user.level
  @levelHelper = level

  setPieces = (level) =>
    @pieces = Piece.query({level})
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
