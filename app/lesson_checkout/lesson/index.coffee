module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require '../lesson_checkout_data'
]

.config ($stateProvider) ->
  $stateProvider.state 'lessonCheckout.lesson',
    url: '/lesson'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


