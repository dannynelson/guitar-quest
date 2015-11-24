module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/directives/gq_sign_up_form'
  require 'local_modules/directives/gq_log_in_form'
]

.config ($stateProvider) ->
  $stateProvider.state 'subscribeCheckout.signUp',
    url: '/sign_up'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'
