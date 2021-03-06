# helper for ngAnnotate
window.ngInject = (f) -> f

window.jQuery = require 'jquery'
window.angular = require 'angular'

require 'angular-resource'
require 'angular-bootstrap-npm'

angular.module 'app', [
  'ui.bootstrap'
  require 'local_modules/services/require_auth'
  require 'local_modules/services/require_permission'
  require 'local_modules/directives/gq_navbar'
  require 'local_modules/directives/gq_piece_status'
  require 'local_modules/ui_router'
  require 'local_modules/directives/gq_piece_history'
  require 'local_modules/directives/gq_card_summary'
  require 'local_modules/services/error_helper'
  require './challenges'
  require './pieces_by_level'
  require './piece'
  require './landing'
  require './log_in'
  require './sign_up'
  require './submitted_pieces'
  require './account'
  require './account_change_password'
  require './review_submitted_piece'
  require './lessons'
  require './lesson_checkout'
  require './subscribe_checkout'
  require './manage_pieces'
  require './confirm_email'
  require './password_reset'
  require './password_reset_confirm'
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


