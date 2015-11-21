# (choose a teacher)
# choose a lesson length / price
# (choose a time)
# (weekly or one time)
# enter payment information
# show summary (lesson price minus credits)
# submit

require 'angular-payments'
module.exports = __filename
angular.module __filename, [
  'ui.bootstrap'
  'angularPayments'
  require 'local_modules/ui_router'
  require 'local_modules/resources/piece'
  require 'local_modules/resources/user'
  require 'local_modules/resources/user_piece'
]

.config ($stateProvider) ->
  $stateProvider.state 'guitarQuest.lessons',
    url: '/lessons'
    controllerAs: 'ctrl'
    template: require './template'
    controller: require './controller'


