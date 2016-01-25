module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'User', ngInject ($http, $resource) ->
  loggedInUser = null

  User = $resource '/users/:_id', {_id: '@_id'},
    query:
      url: '/users'
      method: 'GET'
      isArray: true

    update:
      method: 'PUT'

  User.register = (userData) ->
    $http.post('/users/register', userData).then (response) ->
      return response.data

  User::$reload = ->
    user = @
    $http.get("/users/#{user._id}").then (response) ->
      updatedUser = new User response.data
      angular.copy updatedUser, user

  User.confirmEmail = ({tempUserId}) ->
    $http.post("/users/confirm/#{tempUserId}").then (response) ->
      return response.data # {email, password}

  User.login = ({email, password}) ->
    $http.post('/users/login', {email, password}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.loginOnce = ({loginRequestId}) ->
    $http.post('/users/login_once', {loginRequestId}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.requestPasswordReset = ({email}) ->
    $http.post('/users/request_password_reset', {email})

  User.logout = ->
    $http.post('/users/logout').then (response) ->
      loggedInUser = null
      return null

  User.changePassword = (requestBody) ->
    $http.post('/users/change_password', requestBody).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.changePasswordWithResetRequest = ({oldPassword, newPassword}) ->
    $http.post('/users/change_password_with_reset_request', {passwordResetRequestId, newPassword}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.assertLoggedIn = ->
    $http.post('/users/assert_logged_in').then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.subscribe = ->
    $http.post('/users/subscribe').then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.saveCard = ({stripeToken}) ->
    $http.post('/users/save_card', {stripeToken}).then (response) ->
      return response.data # stripe card resource

  User.getCard = ->
    $http.get('/users/card').then (response) ->
      return response.data

  User.markAllNotificationsRead = ->
    $http.post('/users/mark_all_notifications_read').then (response) ->
      return response.data

  User.getLoggedInUser = -> loggedInUser

  User
