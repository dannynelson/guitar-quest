_ = require 'lodash'

module.exports = ngInject ($state, User) ->
  @form =
    email: null
    password: null

  @login = =>
    @loading = true
    User.login(@form).then =>
      $state.go 'guitarQuest.pieces'
    .catch (rejection) =>
      if rejection.status is 401
        @error = 'Invalid username or password.'

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
