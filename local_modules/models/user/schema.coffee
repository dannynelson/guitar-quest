
module.exports =
  type: 'object'
  required: ['email', 'level', 'credit']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    # note, email added by passportLocalMongoose
    email:
      type: 'string'

    name:
      type: 'string'

    level:
      type: 'integer'
      default: 1

    credit:
      type: 'integer'
      default: 0
