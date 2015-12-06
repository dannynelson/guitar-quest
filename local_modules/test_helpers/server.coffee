require './chai_config'

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
request = require('superagent-bluebird-promise')

database = require "local_modules/database"
# if database?
#   database.setLogger? require "#{process.cwd()}/local_modules/logger"
beforeEach 'connect database', (done) ->
  database.connect done

before ->
  @serverUp = (callback) ->
    # reload,
    # and wipe any server module from cache,
    # to allow for server pieces like middleware to be stubbed.
    # == NASTY! but what alternative? ==
    Object.keys(require.cache).filter (cachePath) ->
      if cachePath.indexOf("#{process.cwd()}/web") is 0 and !/node_modules/.test(cachePath)
        delete require.cache[cachePath]

    server = require "#{process.cwd()}/web/server"
    server.start callback

  @serverDown = (callback) ->
    server = require "#{process.cwd()}/web/server"
    server.stop callback

  @authenticate = (callback) ->
    customRequest = request.agent()
    originalTempUser = null
    customRequest
      .post("#{guitarQuestUrl}/users/register")
      .send
        firstName: 'Julian'
        lastName: 'Bream'
        email: 'bream@guitarquest.com'
        password: '1234abc!'
    .then (response) ->
      expect(response).to.have.property 'statusCode', 201
      expect(response.body).to.deep.equal {}
      TempUser.find({email: 'bream@guitarquest.com'}).select('firstName lastName email hash salt').exec()
    .then (tempUsers) ->
      expect(tempUsers).to.have.length 1
      originalTempUser = _.first tempUsers
      customRequest.post("#{guitarQuestUrl}/users/confirm/#{_.first(tempUsers)._id}")
    .then (response) ->
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
      return [customRequest, user]
