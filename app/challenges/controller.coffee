_ = require 'lodash'
challengeHelpers = require 'local_modules/models/challenge/helpers'

module.exports = ngInject (User, Challenge) ->
  user = User.getLoggedInUser()
  @challengeHelpers = challengeHelpers

  @isLoadingChallenges = true
  Challenge.query
    userId: user._id
    completed: false
  .$promise.then (challenges) =>
    @challenges = challenges
  .finally =>
    @isLoadingChallenges = false

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
