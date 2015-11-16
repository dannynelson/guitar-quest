_ = require 'lodash'

module.exports = ngInject (User, $stateParams, $state) ->
  if $stateParams.id
    @loading = true
    User.confirmEmail({tempUserId: $stateParams.id}).then ({email, password}) =>
      User.login({email, password})
    .then =>
      $state.go 'guitarQuest.pieces'
    .finally =>
      @loading = false

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
