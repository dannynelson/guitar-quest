_ = require 'lodash'

module.exports = ngInject (Upload, User, ngToast, $log, $state) ->
  @user = User.getLoggedInUser()

  @editing = {}
  @form =
    name: null
    email: null

  @edit = (field) =>
    @editing[field] = true

  @save = (field) =>
    @user[field] = @form[field]
    @user.$update()
    .catch (err) =>
      $log.error err
      ngToast.danger "Could not update #{field}, please try again later."
    .finally =>
      @editing[field] = false

  @cancelEdit = (field) =>
    @form[field] = null
    @editing[field] = false

  @changePassword = ->
    $state.go 'guitarQuest.accountChangePassword'

  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
