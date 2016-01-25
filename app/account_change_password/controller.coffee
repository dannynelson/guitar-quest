_ = require 'lodash'

module.exports = ngInject (User, $state, $log) ->
  @form =
    newPassword: null

  @submit = (form) =>
    return if not form.$valid
    @isLoading = true
    User.changePassword(@form).then =>
      @isPasswordChanged = true
    .catch (rejection) ->
      if rejection.status is 401
        $state.go 'guitarQuest.logIn'
      else if rejection.status is -1
        @error = 'You are offline'
      else
        @error = 'Server error.'
    .finally =>
       @isLoading = true

  @cancel = =>
    $state.go('guitarQuest.account')

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
