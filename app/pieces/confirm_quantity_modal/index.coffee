module.exports = __filename

angular.module __filename, [
  'ui.bootstrap'
  require 'goodeggs-ops-inventory-api-client/lot/angular_resource'
  require 'goodeggs-ops-purchase-orders-api-client/catalog/angular_resource'
]

.factory 'confirmQuantityModal', ngInject ($modal, $q) ->

  ###
  @param lot being edited
  ###
  openIfNotWithin50Percent: (expectedQuantity, actualQuantity) ->
    throw new Error('expectedQuantity required') unless expectedQuantity?
    throw new Error('actualQuantity required') unless actualQuantity?

    isWithin50Percent = (expectedQuantity, actualQuantity) ->
      min = expectedQuantity * 0.5
      max = expectedQuantity * 1.5
      min < actualQuantity < max

    if not isWithin50Percent(expectedQuantity, actualQuantity)
      modalInstance = $modal.open
        template: require './template'
        controller: require './controller'
        resolve:
          actualQuantity: -> actualQuantity
          expectedQuantity: -> expectedQuantity

      return modalInstance.result
    else
      return $q.when() # immediately resolve


