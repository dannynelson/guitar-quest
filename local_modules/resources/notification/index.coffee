module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'Notification', ngInject ($resource) ->
  Notification = $resource '/notifications/:_id', {_id: '@_id'},
    query:
      method: 'GET'
      isArray: true

  Notification


