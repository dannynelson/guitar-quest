_ = require 'lodash'

module.exports = ngInject ($state, lessonCheckoutData) ->
  debugger
  @set = (key, value) ->
    debugger
    lessonCheckoutData.contact[key] = value

  @get = (key) ->
    debugger
    lessonCheckoutData.contact[key]
  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
