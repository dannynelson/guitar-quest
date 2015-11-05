require 'ng-file-upload'
module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
  require 'local_modules/resources/user'
  require 'local_modules/resources/user_piece'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.reviewSubmittedPiece',
    requireAuth: true
    url: '/review_submitted_piece/:userPieceId'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


