require 'local_modules/test_helpers/server'
objectIdString = require 'objectid'
database = require 'local_modules/database'
Quest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
userFactory = require 'local_modules/models/user/factory'
Piece = require 'local_modules/models/piece'
pieceFactory = require 'local_modules/models/piece/factory'
UserPiece = require 'local_modules/models/user_piece'
userPieceFactory = require 'local_modules/models/user_piece/factory'

describe 'UserPiece hooks', ->
  beforeEach database.reset

  it 'progresses quest if conditions met', ->
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
      userPiece.save()
    .then (userPiece) ->
      Quest.findById(quest.id)
    .then (quest) ->
      expect(quest).to.have.property 'quantityCompleted', 1

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

