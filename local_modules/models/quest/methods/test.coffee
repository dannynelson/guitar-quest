require 'local_modules/test_helpers/server'
_ = require 'lodash'
objectIdString = require 'objectid'
database = require 'local_modules/database'
Quest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
userFactory = require 'local_modules/models/user/factory'
Piece = require 'local_modules/models/piece'
pieceFactory = require 'local_modules/models/piece/factory'
UserPiece = require 'local_modules/models/user_piece'
userPieceFactory = require 'local_modules/models/user_piece/factory'

clean = (mongooseModel) ->
  object = JSON.parse JSON.stringify mongooseModel
  _.omit object, ['__v', 'createdAt', 'updatedAt', '_id']

describe 'Quest', ->
  beforeEach database.reset

  describe '.createRandomQuest()', ->
    it 'doesnt fail', ->
      User.create(userFactory.create({level: 1})).then (user) ->
        Quest.createRandomQuest({user})

  describe '.createQuest()', ->
    it 'doesnt fail', ->
      User.create(userFactory.create({level: 1})).then (user) ->
        Quest.createQuest('level', {user})

  describe '.progressMatchingQuests()', ->
    it 'works', ->
      user = null
      quest = null
      piece = null
      Promise.all([
        User.create(userFactory.create({level: 1}))
        Piece.create(pieceFactory.create({level: 1}))
      ]).then ([_user, _piece]) ->
        piece = _piece
        user = _user
        Quest.createInitialQuests({user})
      .then (quests) ->
        quest = quests[0]
        expect(quest).to.have.property 'quantityCompleted', 0
        UserPiece.create(userPieceFactory.create({pieceId: piece.id, userId: user.id}))
      .then (userPiece) ->
        userPiece.grade = 0.9
        userPiece.updatedBy = user.id
        Quest.progressMatchingQuests(user.id, {userPiece})
      .then ->
        Quest.findById(quest.id)
      .then (quest) ->
        expect(quest).to.have.property 'quantityCompleted', 1

    it 'does not count the same piece more than once for each quest', ->
      user = null
      quest = null
      quest2 = null
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
        Quest.createQuest('level', {user})
      .then (_quest) ->
        quest = _quest
        expect(quest).to.have.property 'quantityCompleted', 0
        UserPiece.create(userPieceFactory.create({pieceId: piece.id, userId: user.id}))
      .then (_userPiece) ->
        userPiece = _userPiece
        userPiece.grade = 0.9
        userPiece.updatedBy = user.id
        Quest.progressMatchingQuests(user.id, {userPiece})
      .then ->
        Quest.findById(quest.id)
      .then (quest) ->
        expect(quest).to.have.property 'quantityCompleted', 1
        expect(quest.piecesCompleted).to.have.length 1
        userPiece.grade = 1
        userPiece.updatedBy = user.id
        Quest.progressMatchingQuests(user.id, {userPiece})
      .then ->
        Quest.findById(quest.id)
      .then (quest) ->
        expect(quest).to.have.property 'quantityCompleted', 1
        expect(quest.piecesCompleted).to.have.length 1
        UserPiece.create(userPieceFactory.create({pieceId: piece2.id, userId: user.id}))
      .then (_userPiece) ->
        userPiece = _userPiece
        userPiece.grade = 0.8
        userPiece.updatedBy = user.id
        Quest.progressMatchingQuests(user.id, {userPiece})
      .then ->
        Quest.findById(quest.id)
      .then (quest) ->
        expect(quest).to.have.property 'quantityCompleted', 2
        expect(quest.piecesCompleted).to.have.length 2
