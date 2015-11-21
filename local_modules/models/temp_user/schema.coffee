module.exports =
  type: 'object'
  description: 'temporary holding object until the user confirms their email'
  required: ['firstName', 'lastName', 'email', 'password']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    email:
      type: 'string'

    firstName:
      type: 'string'

    lastName:
      type: 'string'

    password:
      type: 'string'
