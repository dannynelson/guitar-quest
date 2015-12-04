_ = require 'lodash'
levelHelper = require 'local_modules/level'

module.exports = __filename
angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
  require 'local_modules/directives/gq_notifications'
]

.directive 'gqNavbar', ->
  controllerAs: 'myCtrl' # controller named differently so we dont conflict with ui.bootstrap
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
        Notification.query({isRead: false}).$promise.then (notifications) =>
          console.log 'test', @notificationCount, notifications.length
          @notificationCount = notifications.length
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
