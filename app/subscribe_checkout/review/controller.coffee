_ = require 'lodash'
subscribeCheckoutData = require '../subscribe_checkout_data'

module.exports = ngInject ($state, User, errorHelper) ->
  if not subscribeCheckoutData.card?
    $state.go 'subscribeCheckout.payment'
  else
    @card = subscribeCheckoutData.card

  @submit = =>
    @loading = true
    User.subscribe()
    .then =>
      $state.go('guitarQuest.piecesByLevel')
    .catch (rejection) =>
      @error = errorHelper.processError(rejection)
    .finally =>
      @loading = false

  return @

