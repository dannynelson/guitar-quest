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
  restrict: 'E'
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject (User, Notification, $rootScope, $state, $sce) ->
    @setNotifications = =>
      user = User.getLoggedInUser()
      return unless user?
      @notifications = Notification.query
        userId: user._id
        $limit: 20
        $sort: '-createdAt'
    @setNotifications()

    @getDescription = (notification) ->
      $sce.trustAsHtml notificationHelpers.getDescription(notification)
    @getLink = (notification) ->
      notificationHelpers.getLink({notification, serverUrl: window.settings.server.url})

    @acknowledge = (notification) =>
      notification.$acknowledge().then =>
        $rootScope.$broadcast 'notificationsUpdated'

    @getTimeFromNow = (date) ->
      geomoment(date).from(new Date())

    $rootScope.$on '$stateChangeSuccess', =>
      @setNotifications()

    $rootScope.$on 'notificationsUpdated', =>
      @setNotifications()

    return @
