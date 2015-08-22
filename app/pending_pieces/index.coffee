module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/user_piece'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.pendingPieces',
    requireAuth: true
    url: '/pending_pieces'
    controllerAs: 'pendingPiecesCtrl'
    template: require './template'
    controller: require './controller'
