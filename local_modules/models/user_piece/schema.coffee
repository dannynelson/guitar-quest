_ = require 'lodash'

schema =
  type: 'object'
  description: 'tracks user progress for a given piece'
  required: ['pieceId', 'userId', 'waitingToBeGraded', 'submissionVideoURL', 'createdAt', 'updatedAt']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    pieceId:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    waitingToBeGraded:
      description: 'note, we need this because if teacher submits same grade twice in a row, we would not now it was graded otherwise'
      type: 'boolean'

    submissionVideoURL:
      type: 'string'

    grade:
      type: 'number'
      enum: [0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1]

    comment:
      type: 'string'

    updatedBy:
      type: 'string'
      format: 'objectid'

    createdAt:
      type: 'string'
      format: 'date'

    updatedAt:
      type: 'string'
      format: 'date'

schema.properties.history =
  type: 'array'
  description: 'a record of all the changes to the user piece'
  items:
    type: 'object'
    properties: _.omit(schema.properties, ['pieceId', 'userId', 'createdAt'])

module.exports = schema
