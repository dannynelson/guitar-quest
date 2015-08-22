_ = require 'lodash'
geomoment = require 'geomoment'

module.exports = ngInject ($scope, $modalInstance, expectedQuantity, actualQuantity) ->
  $scope.expectedQuantity = expectedQuantity
  $scope.actualQuantity = actualQuantity

  $scope.yes = ->
    $modalInstance.close()

  $scope.no = ->
    $modalInstance.dismiss('cancel')
