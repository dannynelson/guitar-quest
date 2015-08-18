module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.pieces',
    requireAuth: true
    url: '/pieces'
    controllerAs: 'piecesCtrl'
    template: require './template'
    controller: require './controller'
