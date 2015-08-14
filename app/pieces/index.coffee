module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
]

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest.pieces',
    requireAuth: true
    url: '/pieces/:level'
    controllerAs: 'musicCtrl'
    params:
      level: '3'
    template: require './template'
    controller: require './controller'
