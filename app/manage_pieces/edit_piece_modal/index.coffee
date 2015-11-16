module.exports = __filename

angular.module __filename, [
  'ui.bootstrap'
]

.factory 'editPieceModal', ngInject ($modal) ->
  open: (piece) ->
    modalInstance = $modal.open
      template: require './template'
      controller: require './controller'
      controllerAs: 'ctrl'
      resolve:
        piece: -> piece

    modalInstance.result


