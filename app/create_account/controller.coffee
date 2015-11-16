_ = require 'lodash'

module.exports = ngInject (User, $state) ->
  @form =
    email: null
    password: null

  @register = =>
    User.register(@form).then =>
      $state.go 'guitarQuest.confirmEmail'

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
