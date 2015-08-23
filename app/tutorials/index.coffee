module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/directives/gq_notifications'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.tutorials',
    requireAuth: true
    url: '/tutorials'
    controllerAs: 'tutorialsCtrl'
    template: require './template'
    controller: require './controller'


