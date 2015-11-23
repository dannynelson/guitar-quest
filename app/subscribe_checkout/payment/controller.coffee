_ = require 'lodash'

module.exports = ngInject ($state, $scope, lessonCheckoutData) ->
  console.log 'loading', !!Stripe
  $scope.handleStripe = (status, response) =>
    debugger
    if response.error
      console.log 'err'
      # // there was an error. Fix it.
    else
      console.log 'success'
      # // got stripe token, now charge it or smt
      token = response.id

  return @

