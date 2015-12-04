require 'local_modules/test_helpers/server'
objectIdString = require 'objectid'
database = require 'local_modules/database'
Challenge = require 'local_modules/models/challenge'
User = require 'local_modules/models/user'
userFactory = require 'local_modules/models/user/factory'
Piece = require 'local_modules/models/piece'
pieceFactory = require 'local_modules/models/piece/factory'
UserPiece = require 'local_modules/models/user_piece'
userPieceFactory = require 'local_modules/models/user_piece/factory'

describe 'UserPiece hooks', ->
  beforeEach database.reset

  describe 'piece graded', ->
  it 'denormalizes points and level onto user if piece graded', ->
    user = null
    challenge = null
    piece = null
    Promise.all([
      User.create(userFactory.create({level: 1}))
      Piece.create(pieceFactory.create({level: 1}))
    ]).then ([_user, _piece]) ->
      piece = _piece
      user = _user
      expect(user).to.have.property 'points', 0
      expect(user).to.have.property 'level', 1
      UserPiece.create(userPieceFactory.create({pieceId: piece.id, userId: user.id}))
    .then (userPiece) ->
      userPiece.grade = 0.9
      userPiece.updatedBy = user.id
      userPiece.save()
    .then (userPiece) ->
      User.findById(user.id)
    .then (user) ->
      expect(user).to.have.property 'points', 90
      expect(user).to.have.property 'level', 1

  it 'progresses challenge if conditions met', ->
    user = null
    challenge = null
    piece = null
    Promise.all([
      User.create(userFactory.create({level: 1}))
      Piece.create(pieceFactory.create({level: 1}))
    ]).then ([_user, _piece]) ->
      piece = _piece
      user = _user
      Challenge.createInitialChallenges({user})
    .then (challenges) ->
      challenge = challenges[0]
      expect(challenge).to.have.property 'quantityCompleted', 0
      UserPiece.create(userPieceFactory.create({pieceId: piece.id, userId: user.id}))
    .then (userPiece) ->
      userPiece.grade = 0.9
      userPiece.updatedBy = user.id
      userPiece.save()
    .then (userPiece) ->
      Challenge.findById(challenge.id)
    .then (challenge) ->
      expect(challenge).to.have.property 'quantityCompleted', 1

  it 'sets waitingToBeGraded: true if video submitted', ->
    userPiece = userPieceFactory.create({submissionVideoURL: 'http://test.com'})
    delete userPiece.waitingToBeGraded
    UserPiece.create(userPiece)
    .then (userPiece) ->
      expect(userPiece).to.have.property 'waitingToBeGraded', true
      userPiece.waitingToBeGraded = false
      userPiece.updatedBy = objectIdString()
      userPiece.save()
    .then (userPiece) ->
      expect(userPiece).to.have.property 'waitingToBeGraded', false
      userPiece.submissionVideoURL = 'http://test2.com'
      userPiece.updatedBy = objectIdString()
      userPiece.save()
    .then (userPiece) ->
      expect(userPiece).to.have.property 'waitingToBeGraded', true

  it 'copies any changes to history', ->

