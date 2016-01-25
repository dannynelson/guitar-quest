module.exports =
  type: 'object'
  description: 'Create a single-use login for a given email address. E.g. for password reset.'
  required: ['emailId']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    emailId:
      type: 'string'
      format: 'email'
