_ = require 'lodash'

module.exports = ngInject ($state, lessonCheckoutData) ->
  @lesson = lessonCheckoutData.lesson

  @days = [
    'monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'
  ]
  @timesOfDay = [
    'morning', 'afternoon', 'evening'
  ]

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
