_ = require 'lodash'

module.exports = ngInject ($state, User) ->
  @currentlySelected = 'signUp'

  if !!User.getLoggedInUser()
    $state.go 'subscribeCheckout.payment'

  return @

