_ = require 'lodash'
geomoment = require 'geomoment'
notificationHelpers = require 'local_modules/models/notification/helpers'
module.exports = __filename

###
display all non-acknowledged alerts (notifications) for a given category
###
angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
]

.directive 'gqNotifications', ->
  scope:
    notifications: '='
  restrict: 'E'
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject ($rootScope, $sce) ->
    @getDescription = (notification) ->
      $sce.trustAsHtml notificationHelpers.getDescription(notification)

    @getLink = (notification) ->
      notificationHelpers.getLink({notification, serverUrl: window.settings.server.url})

    @getTimeFromNow = (date) ->
      geomoment(date).from(new Date())

    return @
