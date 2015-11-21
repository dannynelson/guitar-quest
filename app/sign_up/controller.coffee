_ = require 'lodash'

module.exports = ngInject (User, $state) ->
  @form =
    firstName: null
    lastName: null
    email: null
    password: null

  @register = =>
    ctrl = @
    debugger
    User.register(@form)
    .then =>
      $state.go 'guitarQuest.confirmEmail'
    .catch (rejection) =>
      @error = "#{rejection.data?.message or rejection.data}"

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
