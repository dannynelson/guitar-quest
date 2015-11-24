_ = require 'lodash'

module.exports = __filename
angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
]

.directive 'gqLogInForm', ->
  scope:
    submit: '='
    successState: '@'
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject (User, $rootScope, $state) ->
    @form =
      email: null
      password: null

    @submit = =>
      @loading = true
      User.login(@form).then =>
        $state.go @successState
      .catch (rejection) =>
        if rejection.status is 401
          @error = 'Invalid username or password.'

    return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected

