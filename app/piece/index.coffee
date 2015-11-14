require 'ng-file-upload'
module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
  require 'local_modules/resources/user'
  require 'local_modules/resources/user_piece'
  require 'local_modules/services/tour'
  'ngFileUpload'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.piece',
    requireAuth: true
    url: '/pieces/:pieceId'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


