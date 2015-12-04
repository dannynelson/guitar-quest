_ = require 'lodash'
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
  controller: ngInject (User, Notification, $rootScope, $state) ->
    @setNotifications = =>
      user = User.getLoggedInUser()
      return unless user?
      @notifications = Notification.query({userId: user._id})
    @setNotifications()

    @getDescription = (notification) ->
      debugger
      notificationHelpers.getDescription(notification)
    @getLink = (notification) ->
      notificationHelpers.getLink({notification, serverUrl: window.settings.server.url})

    @acknowledge = (notification) =>
      notification.$acknowledge().then =>
        $rootScope.$broadcast 'notificationsUpdated'

    $rootScope.$on '$stateChangeSuccess', =>
      @setNotifications()

    $rootScope.$on 'notificationsUpdated', =>
      @setNotifications()

    return @
