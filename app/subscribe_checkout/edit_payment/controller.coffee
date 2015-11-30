_ = require 'lodash'
subscribeCheckoutData = require '../subscribe_checkout_data'

module.exports = ngInject ($state, $scope, lessonCheckoutData, User) ->
  cacheCardAndContinue = (card) =>
    subscribeCheckoutData.card = card
    $state.go 'subscribeCheckout.review'

  @gettingCard = true
  User.getCard().then (card) =>
    cacheCardAndContinue(card)
  .finally =>
    @gettingCard = false

  @savingCard = true
  $scope.handleStripe = (status, response) =>
    if response.error
      @error = 'Could not connect to our payment processor. Please try again later.'
      @savingCard = false
    else
      User.saveCreditCard({stripeToken: response.id}).then (card) ->
        cacheCardAndContinue(card)
      .finally ->
        @savingCard = false

  return @

