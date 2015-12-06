_ = require 'lodash'

module.exports = ngInject ($state, User) ->
  @form =
    email: null
    password: null

  @login = (logInForm) =>
    return if not logInForm.$valid
    @isLoading = true
    User.login(@form).then =>
      $state.go 'guitarQuest.piecesByLevel', {level: 'default'}
    .catch (rejection) =>
      if rejection.status is 401
        @error = 'Invalid username or password'
      else
        @error = rejection.data?.message or rejection.data
    .finally =>
      @isLoading = false

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
