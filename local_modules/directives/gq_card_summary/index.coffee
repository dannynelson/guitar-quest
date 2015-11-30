module.exports = __filename
angular.module __filename, []

.directive 'gqCardSummary', ->
  scope:
    card: '='
  controllerAs: 'ctrl'
  bindToController: true
  template: require './template'
  controller: ngInject ->
    return @
