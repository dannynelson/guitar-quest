module.exports = __filename
angular.module __filename, []

.factory 'errorHelper', ngInject ->
  errorHelper =
    processError: (errorOrRejection) ->
      return "#{errorOrRejection.data?.message or errorOrRejection.data or errorOrRejection.message}"

    UserInputError: class UserInputError extends Error
      constructor: (@message) ->
        super
        @name = 'UserInputError'
        Error.captureStackTrace @, errorHelper.UserInputError

