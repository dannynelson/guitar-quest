require 'local_modules/test_helpers/server'
_ = require 'lodash'
sinon = require 'sinon'
Promise = require 'bluebird'
objectIdString = require 'objectid'
database = require 'local_modules/database'
User = require 'local_modules/models/user'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
Notification = require 'local_modules/models/notification'
Challenge = require 'local_modules/models/challenge'
userPieceFactory = require 'local_modules/models/user_piece/factory'
pieceFactory = require 'local_modules/models/piece/factory'
userFactory = require 'local_modules/models/user/factory'

describe 'UserPiece', ->
  beforeEach database.reset

  describe '.submitVideo()', ->
    beforeEach ->
      sinon.spy Challenge, 'progressMatchingChallenges'
    afterEach ->
      Challenge.progressMatchingChallenges.restore()

    it 'validates video url', ->
      UserPiece.create(userPieceFactory.create())
      .then (userPiece) ->
        submitPromise = userPiece.submitVideo
          submissionVideoURL: 'bam'
          updatedBy: objectIdString()
        expect(submitPromise).to.eventually.be.rejectedWith 'must be video updloaded to guitarquest s3 account'

    it 'submits video and progresses challenges', ->
      updatedBy = objectIdString()
      UserPiece.create  userPieceFactory.create
        waitingToBeGraded: false
      .then (userPiece) ->
        userPiece.submitVideo
          submissionVideoURL: 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com/user_566496bff5401a666a5edb78/piece_55d8a2696ce78dc3156ca8d0_56649caa7ce0472729000001.33 PM'
          updatedBy: updatedBy
      .then (userPiece) ->
        UserPiece.findById userPiece._id
      .then (userPiece) ->
        expect(Challenge.progressMatchingChallenges).to.have.been.calledOnce # will fail if invalid args
        expect(userPiece).to.have.property 'submissionVideoURL', 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com/user_566496bff5401a666a5edb78/piece_55d8a2696ce78dc3156ca8d0_56649caa7ce0472729000001.33 PM'
        expect(userPiece).to.have.property 'waitingToBeGraded', true
        expect(_.last(userPiece.history)).to.have.property 'submissionVideoURL', 'https://guitar-quest-videos.s3-us-west-2.amazonaws.com/user_566496bff5401a666a5edb78/piece_55d8a2696ce78dc3156ca8d0_56649caa7ce0472729000001.33 PM'
        expect(_.last(userPiece.history)).to.have.property 'waitingToBeGraded', true
        expect(_.last(userPiece.history).updatedBy.toString()).to.equal updatedBy

  describe '.gradePiece()', ->
    beforeEach ->
      sinon.spy Challenge, 'progressMatchingChallenges'
    afterEach ->
      Challenge.progressMatchingChallenges.restore()

    it 'validates', ->
      UserPiece.create(userPieceFactory.create())
      .then (userPiece) ->
        Promise.all [
          expect(userPiece.gradePiece({comment: 'Good!', updatedBy: objectIdString()})).to.eventually.be.rejectedWith 'grade'
          expect(userPiece.gradePiece({grade: 0.7, updatedBy: objectIdString()})).to.eventually.be.rejectedWith 'comment'
          expect(userPiece.gradePiece({grade: 0.7, comment: 'Good!'})).to.eventually.be.rejectedWith 'updatedBy'
        ]

    it 'sets grade and comment, adds points to user, adds notification, and progresses challenges', ->
      updatedBy = objectIdString()
      Promise.props
        user: User.create userFactory.create
          email: 'danny.edward.nelson@gmail.com'
          points: 200
        piece: Piece.create pieceFactory.create
          level: 1
      .then ({user, piece}) ->
        UserPiece.create userPieceFactory.create
          userId: user._id
          pieceId: piece._id
          waitingToBeGraded: true
          grade: 0.5
          updatedBy: objectIdString()
      .then (userPiece) ->
        userPiece.gradePiece
          grade: 0.7
          comment: 'Good!'
          updatedBy: updatedBy
      .then (userPiece) ->
        Promise.props
          userPiece: UserPiece.findById(userPiece._id)
          user: User.findById(userPiece.userId)
          pieceGradedNotifications: Notification.find({type: 'pieceGraded'})
      .then ({userPiece, user, pieceGradedNotifications}) ->
        expect(Challenge.progressMatchingChallenges).to.have.been.calledOnce # will fail if invalid args
        expect(userPiece).to.have.property 'waitingToBeGraded', false
        expect(userPiece).to.have.property 'grade', 0.7
        expect(userPiece).to.have.property 'comment', undefined
        expect(userPiece.history).to.have.length 2
        expect(_.last(userPiece.history)).to.have.property 'comment', 'Good!'
        expect(_.last(userPiece.history)).to.have.property 'grade', 0.7
        expect(_.last(userPiece.history).updatedBy.toString()).to.equal updatedBy
        expect(user).to.have.property 'points', 220 # grade increases 0.2, 100 points per piece
        expect(pieceGradedNotifications).to.have.length 1
        expect(_.first(pieceGradedNotifications)).to.have.property 'type', 'pieceGraded'

