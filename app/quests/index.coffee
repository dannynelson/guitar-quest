module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  # require './piece'
  # require './pieces'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.quests',
    requireAuth: true
    url: '/quests'
    controllerAs: 'questsCtrl'
    template: require './template'
    controller: require './controller'
