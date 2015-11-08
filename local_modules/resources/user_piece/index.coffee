geomoment = require 'geomoment'

module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'UserPiece', ngInject ($resource, User) ->
  UserPiece = $resource '/user_pieces/:_id', {_id: '@_id'},
    get:
      method: 'GET'

    update:
      method: 'PUT'

    grade:
      url: '/user_pieces/:_id/grade'
      method: 'POST'

  UserPiece
