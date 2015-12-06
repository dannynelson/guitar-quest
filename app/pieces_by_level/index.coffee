module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
  require 'local_modules/directives/gq_notifications'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.piecesByLevel',
    requireAuth: true
    url: '/pieces_by_level/:level'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'
