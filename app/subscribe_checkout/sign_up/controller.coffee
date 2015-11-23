_ = require 'lodash'

module.exports = ngInject ($state, lessonCheckoutData) ->
  @lesson = lessonCheckoutData.payment

  return @

