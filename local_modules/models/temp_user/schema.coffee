module.exports =
  type: 'object'
  description: 'temporary holding object until the user confirms their email'
  required: ['email', 'level', 'credits']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    email:
      type: 'string'

    password:
      type: 'string'
