_ = require 'lodash'

module.exports = ngInject ($state, User) ->
  @form =
    email: null
    password: null

  @login = =>
    User.login(@form).then ->
      $state.go 'guitarQuest.piecesByLevel', {level: 'default'}


  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
