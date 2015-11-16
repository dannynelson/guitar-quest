require 'local_modules/test_helpers/server'
_ = require 'lodash'
objectIdString = require 'objectid'
database = require 'local_modules/database'
Challenge = require 'local_modules/models/challenge'
User = require 'local_modules/models/user'
userFactory = require 'local_modules/models/user/factory'
Piece = require 'local_modules/models/piece'
pieceFactory = require 'local_modules/models/piece/factory'
UserPiece = require 'local_modules/models/user_piece'
userPieceFactory = require 'local_modules/models/user_piece/factory'

clean = (mongooseModel) ->
  object = JSON.parse JSON.stringify mongooseModel
  _.omit object, ['__v', 'createdAt', 'updatedAt', '_id']

describe 'Challenge', ->
  beforeEach database.reset

  describe '.createRandomChallenge()', ->
    it 'doesnt fail', ->
      User.create(userFactory.create({level: 1})).then (user) ->
        Challenge.createRandomChallenge({user})

  describe '.createChallenge()', ->
    it 'doesnt fail', ->
      User.create(userFactory.create({level: 1})).then (user) ->
        Challenge.createChallenge('level', {user})

  describe '.progressMatchingChallenges()', ->
    it 'works', ->
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
        Challenge.progressMatchingChallenges(user.id, {userPiece})
      .then ->
        Challenge.findById(challenge.id)
      .then (challenge) ->
        expect(challenge).to.have.property 'quantityCompleted', 1

    it 'does not count the same piece more than once for each challenge', ->
      user = null
      challenge = null
      challenge2 = null
      piece = null
      piece2 = null
      userPiece = null
      Promise.all([
        User.create(userFactory.create({level: 1}))
        Piece.create(pieceFactory.create({level: 1}))
        Piece.create(pieceFactory.create({level: 1}))
      ]).then ([_user, _piece, _piece2]) ->
        piece = _piece
        piece2 = _piece2
        user = _user
        Challenge.createChallenge('level', {user})
      .then (_challenge) ->
        challenge = _challenge
        expect(challenge).to.have.property 'quantityCompleted', 0
        UserPiece.create(userPieceFactory.create({pieceId: piece.id, userId: user.id}))
      .then (_userPiece) ->
        userPiece = _userPiece
        userPiece.grade = 0.9
        userPiece.updatedBy = user.id
        Challenge.progressMatchingChallenges(user.id, {userPiece})
      .then ->
        Challenge.findById(challenge.id)
      .then (challenge) ->
        expect(challenge).to.have.property 'quantityCompleted', 1
        expect(challenge.piecesCompleted).to.have.length 1
        userPiece.grade = 1
        userPiece.updatedBy = user.id
        Challenge.progressMatchingChallenges(user.id, {userPiece})
      .then ->
        Challenge.findById(challenge.id)
      .then (challenge) ->
        expect(challenge).to.have.property 'quantityCompleted', 1
        expect(challenge.piecesCompleted).to.have.length 1
        UserPiece.create(userPieceFactory.create({pieceId: piece2.id, userId: user.id}))
      .then (_userPiece) ->
        userPiece = _userPiece
        userPiece.grade = 0.8
        userPiece.updatedBy = user.id
        Challenge.progressMatchingChallenges(user.id, {userPiece})
      .then ->
        Challenge.findById(challenge.id)
      .then (challenge) ->
        expect(challenge).to.have.property 'quantityCompleted', 2
        expect(challenge.piecesCompleted).to.have.length 2
