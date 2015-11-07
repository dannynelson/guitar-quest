# helper for ngAnnotate
window.ngInject = (f) -> f

window.angular = require 'angular'

require 'angular-resource'
require 'angular-bootstrap'

angular.module 'app', [
  'ui.bootstrap'
  require 'local_modules/services/require_auth'
  # require 'local_modules/services/ng_toast'
  require 'local_modules/directives/gq_navbar'
  require 'local_modules/directives/gq_piece_status'
  require 'local_modules/ui_router'
  require './quests'
  require './pieces'
  require './piece'
  require './tutorials'
  require './landing'
  require './login'
  require './create_account'
  require './submitted_pieces'
  require './account'
  require './review_submitted_piece'
  require './pricing'
]

.constant 'settings', window.settings

.config ($stateProvider, $sceDelegateProvider) ->
  $sceDelegateProvider.resourceUrlWhitelist([
    'self'
    'https://embed.spotify.com/**'
    'https://s3-us-west-2.amazonaws.com/**'
  ])

  $stateProvider.state 'guitarQuest',
    url: ''
    abstract: true
    controller: require './controller'
    template: require './template'


