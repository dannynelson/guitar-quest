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

    @markNotificationsRead = =>
      debugger
      user = User.getLoggedInUser()
      User.markAllNotificationsRead()
      .then =>
        @setNotifications()

    @setNotifications = =>
      user = User.getLoggedInUser()
      if user?
        @notifications = Notification.query
          userId: user._id
          $limit: 20
          $sort: '-createdAt'
        @notifications.$promise.then (notifications) =>
          @unreadNotificationCount = _.filter(notifications, {isRead: false}).length

    @setNotifications()

    @logout = ->
      User.logout().then -> $state.go 'guitarQuest.logIn'
    @stateIncludes = (possibleStates) ->
      possibleStates = [possibleStates] if not Array.isArray(possibleStates)
      for state in possibleStates
        return true if $state.includes(state)
      return false

    $rootScope.$on '$stateChangeSuccess', =>
      @setNotifications()

    $rootScope.$on 'notificationsUpdated', =>
      @setNotifications()

    @navbarVisible = false

    return @
