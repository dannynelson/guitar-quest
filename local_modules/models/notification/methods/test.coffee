require 'local_modules/test_helpers/server'
_ = require 'lodash'
objectIdString = require 'objectid'
database = require 'local_modules/database'
Notification = require 'local_modules/models/notification'
User = require 'local_modules/models/user'
userFactory = require 'local_modules/models/user/factory'
Piece = require 'local_modules/models/piece'
pieceFactory = require 'local_modules/models/piece/factory'
UserPiece = require 'local_modules/models/user_piece'
userPieceFactory = require 'local_modules/models/user_piece/factory'

clean = (mongooseModel) ->
  object = JSON.parse JSON.stringify mongooseModel
  _.omit object, ['__v', 'createdAt', 'updatedAt', '_id']

describe 'Notification', ->
  beforeEach database.reset

  describe '.createNew()', ->
    it 'works', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      Notification.createNew('pieceGraded', {piece, userPiece}).then (notification) ->
        expect(clean notification).to.deep.equal
          userId: userId
          type: 'pieceGraded'
          isRead: false
          params:
            pieceId: piece._id.toString()
            pieceName: 'Romanza'
            grade: 0.7
            comment: 'Good job!'
