module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  require 'local_modules/resources/quest'
  require 'local_modules/directives/gq_notifications'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.quests',
    requireAuth: true
    url: '/quests'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'
