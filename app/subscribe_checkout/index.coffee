module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require './payment'
  require './review'
  require './sign_up'
]

.config ($stateProvider, $urlRouterProvider) ->
  $urlRouterProvider.when('/subscribe', '/subscribe/sign_up')
  $stateProvider.state 'subscribeCheckout',
    abstract: true
    url: '/subscribe'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


