_ = require 'lodash'
questHelpers = require 'local_modules/models/quest/helpers'

module.exports = ngInject (User, Quest, tour) ->
  user = User.getLoggedInUser()
  @questHelpers = questHelpers
  @quests = Quest.query
    userId: user._id
    completed: false
  @quests.$promise.then ->
    tour.init()
    tour.start()

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
