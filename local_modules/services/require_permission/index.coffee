roles = require 'local_modules/roles'

angular.module __filename, [
  'ui.router'
]

.run ngInject ($rootScope, $state, User) ->
  $rootScope.$on '$stateChangeStart', (e, toState) ->
    # pendingLogin set by requireAuth event from goodeggs-ops-tokens;
    # let it finish resolving auth first.
    return if e.pendingLogin
    return if toState.name is 'accessDenied'

    user = User.getLoggedInUser()

    if toState.requirePermission?
      if not user?
        $state.go 'guitarQuest.logIn'
      else
        roles = user.roles
        if not roles? or not roles.can(roles, toState.requirePermission)
          e.preventDefault()
          # $state.go 'accessDenied', {}, {location: false}

module.exports = __filename
