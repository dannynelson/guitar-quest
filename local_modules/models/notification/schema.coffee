###
Why not just build notifications from auditLogs of every entity?
-  many of this history items are not relevant here (e.g. uploading a video).
- notification has extra data - isRead. Would we save that to history? Does not seem right
  if so, history should be changed to be called notifications, and history should be modifiable'
- query - fetch every userPiece, every challenge, calculate all diffs, sort all diffs by timestamp, return limited set to client
  - very computationally expensive for something that we need to execute every time
- we would need to load every piece into client to get key information like piece name
- however data will be (more) complete if we want to add something later

Multiple notification models?
- stricter mongoose validation, but makes querying more difficult

Single notification model
- works well for common use case of querying first 50 sorted by timestamp
- still possible to migrate past data if we are missing something
###

notificationEnums = require './enums'

module.exports =
  type: 'object'
  required: ['userId', 'type', 'isRead']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    type:
      type: 'string'
      enum: notificationEnums.notificationTypes

    params:
      description: 'generic object that can hold any parameters necessary for a notification'
      type: 'object'

    isRead:
      type: 'boolean'
      default: false
