module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'User', ngInject ($http, $resource) ->
  loggedInUser = null

  User = $resource '/users/:_id', {_id: '@_id'},
    query:
      method: 'GET'
      isArray: true

  User.register = ({email, password}) ->
    $http.post('/users/register', {email, password}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.login = ({email, password}) ->
    $http.post('/users/login', {email, password}).then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.logout = ->
    $http.post('/users/logout').then (response) ->
      loggedInUser = null
      return null

  User.assertLoggedIn = ->
    $http.post('/users/assert_logged_in').then (response) ->
      loggedInUser = new User response.data
      return loggedInUser

  User.getLoggedInUser = -> loggedInUser

  User


