_ = require 'lodash'

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

    @acknowledge = (notification) =>
      notification.$acknowledge().then =>
        $rootScope.$broadcast 'notificationsUpdated'

    $rootScope.$on '$stateChangeSuccess', =>
      @setNotifications()

    $rootScope.$on 'notificationsUpdated', =>
      @setNotifications()

    return @
