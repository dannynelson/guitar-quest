_ = require 'lodash'

module.exports = ngInject (User, $state) ->
  @form =
    firstName: null
    lastName: null
    email: null
    password: null

  @register = (form) =>
    return unless form.$valid
    @isLoading = true
    User.register(@form)
    .then =>
      $state.go 'guitarQuest.confirmEmail'
    .catch (rejection) =>
      @error = "#{rejection.data?.message or rejection.data}"
    .finally =>
      @isLoading = false

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
