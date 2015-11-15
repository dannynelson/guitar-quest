module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/user'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.howItWorks',
    url: '/how_it_works'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


