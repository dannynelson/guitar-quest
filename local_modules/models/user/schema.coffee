
module.exports =
  type: 'object'
  required: ['_id', 'email', 'level', 'credits']
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
      description: 'users current level'
      type: 'integer'
      default: 1

    points:
      description: 'total number of points user has accumulated'
      type: 'integer'
      default: 0

    credits:
      type: 'integer'
      default: 0
