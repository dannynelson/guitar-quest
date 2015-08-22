# helper for ngAnnotate
window.ngInject = (f) -> f

window.angular = require 'angular'

require 'angular-resource'
require 'angular-bootstrap'
require 'ngToast'

angular.module 'app', [
  'ui.bootstrap'
  require 'local_modules/services/require_auth'
  require 'local_modules/directives/gq_navbar'
  require 'local_modules/ui_router'
  require './quests'
  require './pieces'
  require './piece'
  require './tutorials'
  require './landing'
  require './login'
  require './create_account'
  require './initial_assessment'
]

.constant 'settings', window.settings

.config ($stateProvider, $sceDelegateProvider) ->
  $sceDelegateProvider.resourceUrlWhitelist([
    'self'
    'https://embed.spotify.com/**'
  ])

  $stateProvider.state 'guitarQuest',
    url: ''
    abstract: true
    controller: require './controller'
    template: require './template'


