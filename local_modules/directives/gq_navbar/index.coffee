_ = require 'lodash'
levelHelper = require 'local_modules/level'

module.exports = __filename
angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
  require 'local_modules/directives/gq_notifications'
]

.directive 'gqNavbar', ->
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject ($state, User, Notification, $rootScope) ->
    @levelHelper = levelHelper
    @isLoggedIn = -> !!User.getLoggedInUser()
    @hasRole = (role) ->
      user = User.getLoggedInUser()
      user.roles ?= []
      role in user.roles
    @getUser = -> User.getLoggedInUser()
    @updateNotificationCount = =>
      user = User.getLoggedInUser()
      if user?
        Notification.query({userId: user._id, acknowledged: false}).$promise.then (notifications) =>
          @notificationCount = {}
          for notification in notifications
            @notificationCount[notification.category] ?= 0
            @notificationCount[notification.category]++
    @updateNotificationCount()

    @logout = ->
      User.logout().then -> $state.go 'guitarQuest.landing'
    @stateIncludes = (state) ->
      $state.includes(state)

    $rootScope.$on '$stateChangeSuccess', =>
      @updateNotificationCount()

    $rootScope.$on 'notificationsUpdated', =>
      @updateNotificationCount()

    @navbarVisible = false

    return @
