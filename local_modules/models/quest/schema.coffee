
module.exports =
  type: 'object'
  required: ['userId', 'quantityCompleted', 'quantityToComplete']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    userId:
      type: 'string'
      format: 'objectid'

    name:
      type: 'string'

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

    # conditions for which completed pieces will fulfill this quest. If no conditions, matches any of this type
    conditions:
      type: 'object'

    reward:
      type: 'object'
      properties:
        credit:
          type: 'integer'
