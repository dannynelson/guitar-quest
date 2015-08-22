require 'ng-file-upload'
module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  require 'local_modules/ui_router'
  'ngFileUpload'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.initialAssessment',
    requireAuth: true
    url: '/initial_assessment'
    controllerAs: 'initialAssessmentCtrl'
    template: require './template'
    controller: require './controller'


