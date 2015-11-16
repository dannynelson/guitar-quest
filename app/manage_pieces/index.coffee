module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
  require 'local_modules/directives/gq_notifications'
  require './edit_piece_modal'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.managePieces',
    requireAuth: true
    url: '/manage_pieces'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'
