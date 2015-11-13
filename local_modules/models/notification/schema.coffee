module.exports =
  type: 'object'
  required: ['userId', 'category', 'type', 'text', 'acknowledged']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    category:
      type: 'string'
      enum: ['piece', 'quest']

    type:
      type: 'string'
      enum: ['info', 'danger', 'success']

    text:
      type: 'string'

    # did the user dismiss this notification already?
    acknowledged:
      type: 'boolean'
      default: false
