module.exports = __filename
angular.module __filename, [
  'ui.router'
  require 'local_modules/resources/user'
]

.run ngInject ($rootScope, $state, User) ->
  $rootScope.$on '$stateChangeStart', (e, toState, toStateParams) ->
    # debugger
    return unless toState.requireAuth and !User.getLoggedInUser()
    e.preventDefault()
    # so that permissions knows not to authenticate...
    User.assertLoggedIn().then ->
      $state.go(toState.name, toStateParams)
    .catch (err) ->
      $state.go 'guitarQuest.login'
