module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/user'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.login',
    url: '/login'
    controllerAs: 'loginCtrl'
    template: require './template'
    controller: require './controller'

