module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'Challenge', ngInject ($resource) ->
  Challenge = $resource '/challenges/:_id', {_id: '@_id'},
    query:
      method: 'GET'
      isArray: true

  Challenge


