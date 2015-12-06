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

describe '/user_pieces', ->
  beforeEach database.reset
  before (done) -> @serverUp(done)
  after (done) -> @serverDown(done)
  beforeEach ->
    @authenticate().then ([@request, @user]) =>

  describe 'POST /:_id/submit_video', ->
    it 'validates userPieceId', ->
      UserPiece.create(userPieceFactory.create())
      .then (userPiece) =>
        submitPromise = @request
          .post("#{guitarQuestUrl}/user_pieces/bam/submit_video")
          .send
            submissionVideoURL: 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com/user_566496bff5401a666a5edb78/piece_55d8a2696ce78dc3156ca8d0_56649caa7ce0472729000001.33 PM'
            pieceId: objectIdString()
        expect(submitPromise).to.eventually.be.rejectedWith /400/

    it 'validates submissionVideoURL', ->
      UserPiece.create(userPieceFactory.create())
      .then (userPiece) =>
        submitPromise = @request
          .post("#{guitarQuestUrl}/user_pieces/#{userPiece._id}/submit_video")
          .send
            submissionVideoURL: ''
            pieceId: objectIdString()
        expect(submitPromise).to.eventually.be.rejectedWith /400/

    it 'calls submitVideo', ->
      UserPiece.create(userPieceFactory.create())
      .then (userPiece) =>
        sinon.stub UserPiece::, 'submitVideo', -> Promise.resolve userPiece
        @request
          .post("#{guitarQuestUrl}/user_pieces/#{userPiece._id}/submit_video")
          .send
            submissionVideoURL: 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com/user_566496bff5401a666a5edb78/piece_55d8a2696ce78dc3156ca8d0_56649caa7ce0472729000001.33 PM'
            pieceId: objectIdString()
      .then (response) =>
        expect(response).to.be.ok
        expect(UserPiece::submitVideo).to.have.been.calledWith
          submissionVideoURL: 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com/user_566496bff5401a666a5edb78/piece_55d8a2696ce78dc3156ca8d0_56649caa7ce0472729000001.33 PM'
          updatedBy: @user._id.toString()
        UserPiece::submitVideo.restore()
