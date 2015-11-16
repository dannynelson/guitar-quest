module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/resources/user'
  require 'local_modules/ui_router'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.confirmEmail',
    url: '/confirm_email?id'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


