wildcard = require 'wildcard'

module.exports = guitarQuestRoles = {}

roles =
  'teacher':
    title: 'Teacher'
    permissions: ['*']

  'professional':
    permissions: [
      'learnAdvancedPieces'
    ]

###
list of all available roles
###
guitarQuestRoles.roles = Object.keys(roles)

###
mapping of role: permissions.
###
guitarQuestRoles.permissions = guitarQuestRoles.roles.reduce(
  (permissions, role) ->
    permissions[role] = roles[role].permissions
    permissions
  {}
)

###
mapping of role: title.
###
guitarQuestRoles.titles = guitarQuestRoles.roles.reduce(
  (permissions, role) ->
    permissions[role] = roles[role].title
    permissions
  {}
)

###
usage:
@param userRoles (array). any role with permission grants.
@param action (string) to check if user has permission for.
  - `true` trumps `false`; any grant is accepted.
@return boolean.
to check if user has multiple permissions, call multiple times.
###
guitarQuestRoles.can = (userRoles, action) ->
  permissions = guitarQuestRoles.permissions

  for role in userRoles
    if permissions[role]?
      for permission in permissions[role]
        if wildcard(permission, action)   # (array of matches or false)
          return true

  return false
