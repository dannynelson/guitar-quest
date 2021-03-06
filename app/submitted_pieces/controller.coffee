_ = require 'lodash'
geomoment = require 'geomoment'

module.exports = ngInject (User, UserPiece, Piece) ->
  @user = User.getLoggedInUser()
  @userPieces = UserPiece.query
    waitingToBeGraded: true
    $add: ['user', 'piece']

  @getTimeFromNow = (date) ->
    geomoment(date).from(new Date())

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
