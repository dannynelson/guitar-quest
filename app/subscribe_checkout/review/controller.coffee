_ = require 'lodash'
subscribeCheckoutData = require '../subscribe_checkout_data'

module.exports = ngInject ($state, User, errorHelper) ->
  @settings = window.settings

  if not subscribeCheckoutData.card?
    $state.go 'subscribeCheckout.payment'
  else
    @card = subscribeCheckoutData.card

  @submit = =>
    @isLoading = true
    User.subscribe()
    .then =>
      $state.go('guitarQuest.piecesByLevel', {level: 'default'})
    .catch (rejection) =>
      @error = errorHelper.processError(rejection)
    .finally =>
      @isLoading = false

  return @

