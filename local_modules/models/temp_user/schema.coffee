module.exports =
  type: 'object'
  description: 'temporary holding object until the user confirms their email'
  required: ['firstName', 'lastName', 'email']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    email:
      description: 'note, email is not unique so that user can have multiple login attempts'
      type: 'string'

    firstName:
      type: 'string'

    lastName:
      type: 'string'
