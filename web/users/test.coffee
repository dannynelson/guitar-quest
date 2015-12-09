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
User = require 'local_modules/models/user'
UserPiece = require 'local_modules/models/user_piece'
Notification = require 'local_modules/models/notification'
Challenge = require 'local_modules/models/challenge'
userPieceFactory = require 'local_modules/models/user_piece/factory'
pieceFactory = require 'local_modules/models/piece/factory'
userFactory = require 'local_modules/models/user/factory'
guitarQuestUrl = settings.server.url
superAgentRequest = require('superagent-bluebird-promise')

describe '/users', ->
  beforeEach database.reset
  before (done) -> @serverUp(done)
  after (done) -> @serverDown(done)

  describe 'POST /login', ->
    describe 'validation', ->
      it 'validates email', ->
        request.postPromised "#{guitarQuestUrl}/users/login",
          json:
            email: 'bream'
            password: '1234abcde!'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'invalid email'

      it 'validates password', ->
        request.postPromised "#{guitarQuestUrl}/users/login",
          json:
            email: 'bream@gmail.com'
            password: ''
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'invalid password'

    it 'logs in to existing account', ->
      @authenticate().then ([@request, @user]) ->
        newAgent = superAgentRequest.agent()
          .post("#{guitarQuestUrl}/users/login")
          .send
            email:'julian.bream@Gmail.com'
            password: '1234abc!'
      .then (response) ->
        expect(response).to.have.property 'statusCode', 200
        expect(response.body.email).to.equal 'Julian.Bream+guitarquest@Gmail.com'

  describe 'POST /register', ->
    describe 'validation', ->
      it 'validates firstName', ->
        request.postPromised "#{guitarQuestUrl}/users/register",
          json:
            firstName: ''
            lastName: 'Bream'
            email: 'bream@gmail.com'
            password: '1234abcde!'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'invalid firstName'

      it 'validates lastName', ->
        request.postPromised "#{guitarQuestUrl}/users/register",
          json:
            firstName: 'Julian'
            lastName: ''
            email: 'bream@gmail.com'
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
            email: 'bream@gmail.com'
            password: '1234'
        .spread (response) ->
          expect(response).to.have.property 'statusCode', 400
          expect(response.body).to.equal 'password must be at least 8 characters long'

    it 'creates a temporary user', ->
      request.postPromised "#{guitarQuestUrl}/users/register",
        json:
          firstName: 'Julian'
          lastName: 'Bream'
          email: 'Bream+promotions@Gmail.com'
          password: '1234abc!'
      .spread (response) ->
        expect(response).to.have.property 'statusCode', 201
        expect(response.body).to.deep.equal {}
        TempUser.find()
      .then (users) ->
        TempUser.find({emailId: 'bream@gmail.com'})
      .then (tempUsers) ->
        expect(tempUsers).to.have.length 1
        tempUser = _.first(tempUsers)
        expect(tempUser).to.have.property 'firstName', 'Julian'
        expect(tempUser).to.have.property 'lastName', 'Bream'
        expect(tempUser).to.have.property 'email', 'Bream+promotions@Gmail.com'
        expect(tempUser).to.have.property 'emailId', 'bream@gmail.com'

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
          email: 'Bream+promotions@Gmail.com'
          password: '1234abc!'
      .spread (response) ->
        expect(response).to.have.property 'statusCode', 201
        expect(response.body).to.deep.equal {}
        TempUser.find({emailId: 'bream@gmail.com'}).select('firstName lastName email hash salt').exec()
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
          user: User.findById(returnedUser._id).select('firstName lastName email emailId hash salt').exec()
          updatedTempUser: TempUser.find({emailId: 'bream@gmail.com'})
      .then ({user, updatedTempUser}) ->
        expect(updatedTempUser).to.deep.equal [] # deletes original
        expect(user).to.have.property 'firstName', 'Julian'
        expect(user).to.have.property 'lastName', 'Bream'
        expect(user).to.have.property 'email', 'Bream+promotions@Gmail.com'
        expect(user).to.have.property 'emailId', 'bream@gmail.com'
        expect(user).to.have.property 'hash', originalTempUser.hash
        expect(user).to.have.property 'salt', originalTempUser.salt


