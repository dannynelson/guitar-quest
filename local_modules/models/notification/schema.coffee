module.exports =
  type: 'object'
  required: ['userId', 'type', 'acknowledged']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    type:
      type: 'string'

    params:
      description: 'generic object that can hold any parameters necessary for a notification'
      type: 'object'

    isRead:
      type: 'boolean'
      default: false
