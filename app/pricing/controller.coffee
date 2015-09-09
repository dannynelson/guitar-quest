_ = require 'lodash'

module.exports = ngInject ($state, User) ->
  @form =
    email: null
    password: null

  @login = =>
    User.login(@form).then ->
      $state.go 'guitarQuest.pieces'


  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
