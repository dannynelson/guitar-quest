require 'ng-file-upload'
module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  'ngFileUpload'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.piece',
    # requireAuth: true
    url: '/piece'
    controllerAs: 'pieceCtrl'
    template: require './template'
    controller: require './controller'


