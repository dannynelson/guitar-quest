_ = require 'lodash'

module.exports = ngInject ($state, $stateParams, User) ->
  User.loginOnce({loginRequestId: $stateParams.loginRequestId})
  .then ->
    $state.go 'guitarQuest.accountChangePassword'
  .catch (rejection) =>
    @error = rejection.data?.message or rejection.data
  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
