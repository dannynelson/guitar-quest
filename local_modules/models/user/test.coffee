require 'local_modules/test_helpers/server'
_ = require 'lodash'
objectIdString = require 'objectid'
database = require 'local_modules/database'
User = require 'local_modules/models/user'
Notification = require 'local_modules/models/notification'
userFactory = require 'local_modules/models/user/factory'

describe 'User', ->
  beforeEach database.reset

  it 'normalizes email to emailId when email saved', ->
    User.create userFactory.create
      email: 'Julian.Bream+promotions@Gmail.com'
    .then (user) ->
      expect(user).to.have.property 'email', 'Julian.Bream+promotions@Gmail.com'
      expect(user).to.have.property 'emailId', 'julianbream@gmail.com'

  describe '.addPoints()', ->
    it 'validates', ->
      User.create userFactory.create
        level: 0
        points: 250
      .then (user) ->
        Promise.all [
          expect(user.addPoints()).to.eventually.be.rejectedWith 'points'
          expect(user.addPoints(10.000001)).to.eventually.be.rejectedWith 'points'
        ]

    it 'adds points to user', ->
      User.create userFactory.create
        level: 0
        points: 250
      .then (user) ->
        user.addPoints(30)
      .then (user) ->
        User.findById(user._id)
      .then (user) ->
        expect(user).to.have.property 'points', 280
        expect(user).to.have.property 'level', 0

    it 'levels up, and notifies if user has sufficient points', ->
      userId = objectIdString()
      User.create userFactory.create
        _id: userId
        level: 0
        points: 250
      .then (user) ->
        Notification.count().then (notificationCount) ->
          expect(notificationCount).to.equal 0
          user.addPoints(2000)
      .then (user) ->
        User.findById(user._id)
      .then (user) ->
        expect(user).to.have.property 'level', 1
        Notification.find()
      .then (notifications) ->
        expect(notifications).to.have.length 1
        expect(_.first(notifications)).to.have.property 'type', 'levelUp'
        expect(_.first(notifications)).to.have.deep.property 'params.level', 1

