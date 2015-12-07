_ = require 'lodash'
subscribeCheckoutData = require '../subscribe_checkout_data'

module.exports = ngInject ($state, $scope, lessonCheckoutData, User) ->
  cacheCardIfExistsAndContinue = (card) =>
    if card?
      subscribeCheckoutData.card = card
      $state.go 'subscribeCheckout.review'

  # If card already cached, assume they user wants to edit the existing card
  if subscribeCheckoutData.card?
    @savedCard = subscribeCheckoutData.card
  # Otherwise, check to see if user has existing payment info
  else
    @gettingCard = true
    User.getCard().then (card) =>
      cacheCardIfExistsAndContinue(card)
    .finally =>
      @gettingCard = false

  @savingCard = true
  $scope.handleStripe = (status, response) =>
    if response.error
      @error = 'Could not connect to our payment processor. Please try again later.'
      @savingCard = false
    else
      User.saveCard
        stripeToken: response.id
      .then (card) ->
        cacheCardIfExistsAndContinue(card)
      .finally ->
        @savingCard = false

  return @

