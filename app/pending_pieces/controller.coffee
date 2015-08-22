_ = require 'lodash'

module.exports = ngInject (User, UserPiece) ->
  @user = User.getLoggedInUser()
  @userPieces = UserPiece.query({status: 'pending'})

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
