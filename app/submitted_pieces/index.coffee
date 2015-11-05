module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/user_piece'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.submittedPieces',
    requireAuth: true
    url: '/submitted_pieces'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'
