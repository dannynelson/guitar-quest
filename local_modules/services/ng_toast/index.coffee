require 'ngToast'
require 'angular-sanitize'
require 'angular-animate'

module.exports = __filename
angular.module __filename, [
  'ngAnimate'
  'ngSanitize'
  'ngToast'
]

.config (ngToastProvider) ->
  ngToastProvider.configure
    timeout: 5000
    verticalPosition: 'bottom'
    dismissButton: true
