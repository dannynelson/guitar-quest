geomoment = require 'geomoment'

module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'UserPiece', ngInject ($resource, User, $http) ->
  UserPiece = $resource '/user_pieces/:_id', {_id: '@_id'},
    get:
      method: 'GET'

    update:
      method: 'PUT'

  UserPiece::$grade = (requestBodyParams) ->
    userPiece = @
    $http.post("/user_pieces/#{userPiece._id}/grade", requestBodyParams).then (response) ->
      angular.copy(response.data, userPiece)
      return userPiece

  UserPiece
