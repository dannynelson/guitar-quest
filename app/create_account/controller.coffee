_ = require 'lodash'

module.exports = ngInject (User, $state) ->
  @form =
    email: null
    password: null

  @register = =>
    User.register(@form).then =>
      User.login(@form)
    .then =>
      $state.go 'guitarQuest.pieces'

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
