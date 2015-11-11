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

  it '.progressMatchingQuests(userId, {userPiece})', ->
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


