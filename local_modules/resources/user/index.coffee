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
    $http.post("/users/confirm_email/#{tempUserId}").then (response) ->
      return response.data # {email, password}

  User.login = ({email, password}) ->
    $http.post('/users/login', {email, password}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.logout = ->
    $http.post('/users/logout').then (response) ->
      loggedInUser = null
      return null

  User.changePassword = ({oldPassword, newPassword}) ->
    $http.post('/users/change_password', {oldPassword, newPassword}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.assertLoggedIn = ->
    $http.post('/users/assert_logged_in').then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.getLoggedInUser = -> loggedInUser

  User


