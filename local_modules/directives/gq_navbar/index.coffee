_ = require 'lodash'
wasJustCountedByLotPieceId = {}

module.exports = __filename
angular.module __filename, [
  require 'local_modules/resources/user'
]

.directive 'gqNavbar', ->
  scope:
    lot: '='
    lotPiece: '='
  controllerAs: 'navbarCtrl'
  bindToController: true
  template: require './template'
  controller: ngInject ($state, User) ->
    @isLoggedIn = -> !!User.getLoggedInUser()
    @user = User.getLoggedInUser()
    @logout = ->
      debugger
      User.logout().then -> $state.go 'guitarQuest.landing'
    @stateIncludes = (state) ->
      $state.includes(state)

    @navbarVisible = false
