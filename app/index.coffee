# helper for ngAnnotate
window.ngInject = (f) -> f

window.jQuery = require 'jquery'
window.angular = require 'angular'

require 'angular-resource'
require 'angular-bootstrap'

angular.module 'app', [
  'ui.bootstrap'
  require 'local_modules/services/require_auth'
  require 'local_modules/directives/gq_navbar'
  require 'local_modules/directives/gq_piece_status'
  require 'local_modules/ui_router'
  require 'local_modules/directives/gq_piece_history'
  require './challenges'
  require './pieces'
  require './piece'
  require './landing'
  require './login'
  require './create_account'
  require './submitted_pieces'
  require './account'
  require './how_it_works'
  require './review_submitted_piece'
  require './pricing'
  # require './private_lessons'
  require './lesson_checkout'
  require './manage_pieces'
  require './confirm_email'
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


