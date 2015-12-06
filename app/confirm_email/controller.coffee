_ = require 'lodash'

module.exports = ngInject (User, $stateParams, $state) ->
  if $stateParams.id
    @isLoading = true
    User.confirmEmail({tempUserId: $stateParams.id}).then ->
      $state.go 'guitarQuest.piecesByLevel', {level: 'default'}
    .finally =>
      @isLoading = false

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
