# helper for ngAnnotate
window.ngInject = (f) -> f

window.angular = require 'angular'

require 'angular-resource'
require 'angular-bootstrap'

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
]

.constant 'settings', window.settings

.config ($stateProvider) ->

  $stateProvider.state 'guitarQuest',
    url: ''
    abstract: true
    controller: require './controller'
    template: require './template'


