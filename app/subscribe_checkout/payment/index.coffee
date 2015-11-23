require 'angular-payments'

module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  'angularPayments'
  require 'local_modules/ui_router'
]

.config ($stateProvider) ->
  $stateProvider.state 'subscribeCheckout.payment',
    url: '/payment'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


