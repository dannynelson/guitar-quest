module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
  require 'local_modules/directives/gq_notifications'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.pieces',
    requireAuth: true
    url: '/pieces'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'
