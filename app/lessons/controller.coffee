geomoment = require 'geomoment'
_ = require 'lodash'

module.exports = ngInject ->
  @number = null
  @cvc = null
  @expMonth = null
  @expYear = null

  @submitPayment = (status, response) ->
    if response.error
      # // there was an error. Fix it.
    else
      # // got stripe token, now charge it or smt
      token = response.id

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
