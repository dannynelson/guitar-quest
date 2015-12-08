_ = require 'lodash'
geomoment = require 'geomoment'
levelHelper = require 'local_modules/level'
userPieceHelers = require 'local_modules/models/user_piece/helpers'

module.exports = __filename

angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
]

.directive 'gqPieceHistory', ->
  scope:
    userPiece: '='
    level: '='
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject (User) ->
    @levelHelper = levelHelper
    userIds = _(@userPiece.history).pluck('updatedBy').uniq().value()
    User.query({_id: userIds, $select: ['email', '_id']}, {}).$promise.then (users) =>
      @usersById = _.indexBy users, '_id'

    @getTimeFromNow = (date) ->
      geomoment(date).from(new Date())

    return @
