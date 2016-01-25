_ = require 'lodash'

module.exports = ngInject ($state, User) ->
  @form =
    email: null

  @login = (forgotPasswordForm) =>
    return if not forgotPasswordForm.$valid
    @isLoading = true
    User.requestPasswordReset({email: @form.email}).then =>
      @requestSent = true
    .catch (rejection) =>
      if rejection.status is 401
        @error = 'User with this email address does not exist.'
      else
        @error = 'Something went wrong. Please try again later.'
    .finally =>
      @isLoading = false

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
