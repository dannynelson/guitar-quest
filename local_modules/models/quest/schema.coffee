questEnums = require './enums'

module.exports =
  type: 'object'
  required: ['userId', 'quantityCompleted', 'quantityToComplete', 'piecesCompleted']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    type:
      type: 'string'
      enum: questEnums.questTypes

    # quantity of pieces with matching conditions that need to be completed
    # to finish this quest
    quantityCompleted:
      type: 'integer'
      default: 0

    quantityToComplete:
      type: 'integer'

    completed:
      type: 'boolean' # automatically set if user completes it
      default: false

    params:
      description: 'generic object that can hold any parameters necessary for a quest'
      type: 'object'

    reward:
      type: 'object'
      properties:
        credits:
          description: 'credits to use for buying lessons'
          type: 'integer'
        # points:
        #   description: 'points to help user get to the next level faster'
        #   type: 'integer'

    piecesCompleted:
      description: 'Pieces that have already been counted toward this quest'
      type: 'array'
      items:
        type: 'string'
        format: 'objectid'
