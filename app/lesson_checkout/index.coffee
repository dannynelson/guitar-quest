module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require './lesson'
  require './payment'
  require './review'
]

.config ($stateProvider) ->
  $stateProvider.state 'lessonCheckout',
    url: '/lesson_checkout'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


