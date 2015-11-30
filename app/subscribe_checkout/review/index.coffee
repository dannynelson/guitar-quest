module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
]

.config ($stateProvider) ->
  $stateProvider.state 'subscribeCheckout.review',
    requireAuth: true
    url: '/review'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


