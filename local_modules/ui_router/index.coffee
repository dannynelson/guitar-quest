require 'angular-ui-router'

module.exports = __filename
angular.module __filename, ['ui.router']

.config ngInject ($urlMatcherFactoryProvider) ->
  # match trailing slashes in the url
  $urlMatcherFactoryProvider.strictMode false

.run ngInject ($rootScope, $log) ->
  # Log error if something breaks inside a "resolve"
  $rootScope.$on '$stateChangeError', (e, toState, toParams, fromState, fromParams, err) ->
    $log.error("Failed to transition from state '#{fromState.name}' to state '#{toState.name}'. See below error for details:")
    throw err

