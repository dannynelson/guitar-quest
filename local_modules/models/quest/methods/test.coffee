require 'local_modules/test_helpers/server'
_ = require 'lodash'
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

  it '.generateAnyPieceQuest(user)', ->
    user = null
    User.create(userFactory.create({level: 1})) # set as level 1 so that there is no randomness
    .then (_user) ->
      user = _user
      Quest.generateAnyPieceQuest(user)
    .then (quest) ->
      expect(clean(quest)).to.deep.equal
        userId: user.id
        name: "Complete 3 level 1 pieces with at least an 80% grade"
        quantityCompleted: 0
        quantityToComplete: 3
        conditions:
          userPiece:
            'grade': {gte: 0.8}
          piece:
            'level': 1
        reward:
          credit: 10

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
      Quest.generateAnyPieceQuest(user)
    .then (_quest) ->
      quest = _quest
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


