require 'local_modules/test_helpers/server'
settings = require 'local_modules/settings'
_ = require 'lodash'
Promise = require 'bluebird'
request = Promise.promisifyAll require('request'), {suffix: 'Promised'}
sinon = require 'sinon'
Promise = require 'bluebird'
objectIdString = require 'objectid'
database = require 'local_modules/database'
User = require 'local_modules/models/user'
TempUser = require 'local_modules/models/temp_user'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
Notification = require 'local_modules/models/notification'
Challenge = require 'local_modules/models/challenge'
userPieceFactory = require 'local_modules/models/user_piece/factory'
pieceFactory = require 'local_modules/models/piece/factory'
userFactory = require 'local_modules/models/user/factory'
guitarQuestUrl = settings.server.url

describe '/users', ->
  beforeEach database.reset
  before (done) -> @serverUp(done)
  after (done) -> @serverDown(done)

  describe 'POST /register', ->
    describe 'validation', ->
      it 'validates firstName', ->
        request.postPromised "#{guitarQuestUrl}/users/register",
          json:
            firstName: ''
            lastName: 'Bream'
            email: 'bream@guitarquest.com'
            password: '1234abcde!'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'invalid firstName'

      it 'validates lastName', ->
        request.postPromised "#{guitarQuestUrl}/users/register",
          json:
            firstName: 'Julian'
            lastName: ''
            email: 'bream@guitarquest.com'
            password: '1234abcde!'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'invalid lastName'

      it 'validates email', ->
        request.postPromised "#{guitarQuestUrl}/users/register",
          json:
            firstName: 'Julian'
            lastName: 'Bream'
            email: 'bream'
            password: '1234abcde!'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'invalid email'

      it 'validates password', ->
        request.postPromised "#{guitarQuestUrl}/users/register",
          json:
            firstName: 'Julian'
            lastName: 'Bream'
            email: 'bream@guitarquest.com'
            password: '1234'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'password must be at least 8 characters long'

    it 'creates a temporary user', ->
      request.postPromised "#{guitarQuestUrl}/users/register",
        json:
          firstName: 'Julian'
          lastName: 'Bream'
          email: 'bream@guitarquest.com'
          password: '1234abc!'
      .spread (response) ->
        expect(response).to.have.property 'statusCode', 201
        expect(response.body).to.deep.equal {}
        TempUser.find({email: 'bream@guitarquest.com'})
      .then (tempUsers) ->
        expect(tempUsers).to.have.length 1
        tempUser = _.first(tempUsers)
        expect(tempUser).to.have.property 'firstName', 'Julian'
        expect(tempUser).to.have.property 'lastName', 'Bream'
        expect(tempUser).to.have.property 'email', 'bream@guitarquest.com'

  describe 'POST /confirm/:tempUserId', ->
    it 'validates', ->
      request.postPromised "#{guitarQuestUrl}/users/confirm/bam", {json: true}
      .spread (response) ->
        expect(response).to.have.property 'statusCode', 400
        expect(response.body).to.equal 'invalid tempUserId'

    it 'creates an account', ->
      originalTempUser = null
      request.postPromised "#{guitarQuestUrl}/users/register",
        json:
          firstName: 'Julian'
          lastName: 'Bream'
          email: 'bream@guitarquest.com'
          password: '1234abc!'
      .spread (response) ->
        expect(response).to.have.property 'statusCode', 201
        expect(response.body).to.deep.equal {}
        TempUser.find({email: 'bream@guitarquest.com'}).select('firstName lastName email hash salt').exec()
      .then (tempUsers) ->
        expect(tempUsers).to.have.length 1
        originalTempUser = _.first tempUsers
        request.postPromised "#{guitarQuestUrl}/users/confirm/#{_.first(tempUsers)._id}", {json: true}
      .spread (response) ->
        expect(response).to.have.property 'statusCode', 201
        returnedUser = response.body
        expect(returnedUser).not.to.have.property 'hash'
        expect(returnedUser).not.to.have.property 'salt'
        Promise.props
          user: User.findById(returnedUser._id).select('firstName lastName email hash salt').exec()
          updatedTempUser: TempUser.find({email: 'bream@guitarquest.com'})
      .then ({user, updatedTempUser}) ->
        expect(updatedTempUser).to.deep.equal [] # deletes original
        expect(user).to.have.property 'firstName', 'Julian'
        expect(user).to.have.property 'lastName', 'Bream'
        expect(user).to.have.property 'email', 'bream@guitarquest.com'
        expect(user).to.have.property 'hash', originalTempUser.hash
        expect(user).to.have.property 'salt', originalTempUser.salt
