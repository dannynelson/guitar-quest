module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
]

.config ($stateProvider) ->
  $stateProvider.state 'subscribeCheckout.signUp',
    url: '/sign_up'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


