_ = require 'lodash'

module.exports = ngInject (User, Quest) ->
  user = User.getLoggedInUser()
  @quests = Quest.query({userId: user._id})

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected