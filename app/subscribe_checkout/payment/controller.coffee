_ = require 'lodash'

module.exports = ngInject ($state, $scope, lessonCheckoutData, User) ->
  $scope.handleStripe = (status, response) =>
    if response.error
      @error = 'Could not connect to our payment processor. Please try again later.'
    else
      User.saveCreditCard({stripeToken: response.id}).then ->
        $state.go 'subscribeCheckout.review'

  return @

