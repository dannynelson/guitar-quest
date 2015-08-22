module.exports = __filename
angular.module __filename, ['ngResource']

.factory 'Quest', ngInject ($resource) ->
  Quest = $resource '/quests/:_id', {_id: '@_id'},
    query:
      method: 'GET'
      isArray: true

  Quest


