module.exports = __filename

angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/resources/user'
]

.factory 'changePasswordModal', ngInject ($modal, $q) ->

  ###
  @param lot being edited
  ###
  open: ->
    modalInstance = $modal.open
      size: 'sm'
      template: require './template'
      controller: require './controller'

    return modalInstance.result


