module.exports = __filename
angular.module __filename, []

.factory 'errorHelper', ngInject ->
  processError: (errorOrRejection) ->
    return "#{errorOrRejection.data?.message or errorOrRejection.data or errorOrRejection.message}"
