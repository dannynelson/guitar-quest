module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/resources/user'
  require 'local_modules/ui_router'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.createAccount',
    url: '/create_account'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


