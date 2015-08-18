module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'Piece', ngInject ($resource) ->
  Piece = $resource '/pieces/:_id', {_id: '@_id'},
    query:
      method: 'GET'
      isArray: true
    get:
      method: 'GET'

  Piece


