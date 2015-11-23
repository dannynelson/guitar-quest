_ = require 'lodash'

module.exports = __filename
angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
]

.directive 'gqSignUpForm', ->
  scope:
    submit: '='
    successState: '@'
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject (User, $rootScope, $state) ->
    console.log 'loading'
    @form =
      firstName: null
      lastName: null
      email: null
      password: null

    # overwrite the ctrl.submit method passed in
    @submit = =>
      ctrl = @
      User.register(@form)
      .then =>
        $state.go @successState
      .catch (rejection) =>
        @error = "#{rejection.data?.message or rejection.data}"

    return @
