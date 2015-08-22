module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'UserPiece', ngInject ($resource) ->
  UserPiece = $resource '/user_pieces/:_id', {_id: '@_id'},
    get:
      method: 'GET'

    update:
      method: 'PUT'

  UserPiece
