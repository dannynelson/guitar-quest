
module.exports =
  type: 'object'
  required: ['firstName', 'lastName', 'email', 'level', 'credits']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    # note, email added by passportLocalMongoose
    email:
      type: 'string'

    firstName:
      type: 'string'

    lastName:
      type: 'string'

    roles:
      type: 'array'
      items:
        type: 'string'
        enum: ['teacher']

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

    stripeId:
      type: 'string'

    isSubscribed:
      description: 'Is user currently paying for a subscription?'
      type: 'boolean'
