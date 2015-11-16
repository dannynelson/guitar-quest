module.exports =
  type: 'object'
  required: ['userId', 'category', 'type', 'text', 'title', 'acknowledged']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    category:
      type: 'string'
      enum: ['piece', 'challenge']

    type:
      type: 'string'
      enum: ['info', 'danger', 'success']

    title:
      description: 'Subject sent in email if an email is sent.'
      type: 'string'

    text:
      type: 'string'

    # did the user dismiss this notification already?
    acknowledged:
      type: 'boolean'
      default: false
