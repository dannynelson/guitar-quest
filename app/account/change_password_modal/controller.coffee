_ = require 'lodash'

module.exports = ngInject ($scope, $modalInstance, User) ->
  $scope.form =
    oldPassword: null
    newPassword: null

  $scope.submit = ->
    User.changePassword($scope.form).then =>
      $modalInstance.close()

  $scope.cancel = ->
    $modalInstance.dismiss('cancel')
