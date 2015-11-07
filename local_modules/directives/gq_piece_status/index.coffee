_ = require 'lodash'
userPieceHelers = require 'local_modules/models/user_piece/helpers'

module.exports = __filename

###
display all non-acknowledged alerts (notifications) for a given category
###
angular.module __filename, [
  require 'local_modules/resources/user'
  require 'local_modules/resources/notification'
]

.directive 'gqPieceStatus', ->
  scope:
    userPiece: '='
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject (User, Notification, $rootScope, $state) ->
    return @ unless @userPiece
    @status = userPieceHelers.getStatus(@userPiece)
    return @
