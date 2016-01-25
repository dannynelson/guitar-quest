require 'ng-file-upload'
module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  'ngFileUpload'
  require 'local_modules/services/ng_toast'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.account',
    requireAuth: true
    url: '/account'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


