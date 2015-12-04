require 'local_modules/test_helpers/chai_config'
_ = require 'lodash'
objectIdString = require 'objectid'
challengeEnums = require 'local_modules/models/challenge/enums'
userFactory = require 'local_modules/models/user/factory'
pieceFactory = require 'local_modules/models/piece/factory'
userPieceFactory = require 'local_modules/models/user_piece/factory'
challengeFactory = require 'local_modules/models/challenge/factory'
notificationHelpers = require './index'

describe 'notificationHelpers', ->
  describe '.generateNotification()', ->
    it 'creates "pieceGraded"', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      notification = notificationHelpers.generateNotification('pieceGraded', {piece, userPiece})
      expect(notification).to.deep.equal
        userId: userId
        type: 'pieceGraded'
        isRead: false
        params:
          pieceId: piece._id.toString()
          pieceName: 'Romanza'
          grade: 0.7
          comment: 'Good job!'

    it 'creates "challengeProgressed"', ->
      userId = objectIdString()
      challenge = challengeFactory.create({userId})
      notification = notificationHelpers.generateNotification('challengeProgressed', {challenge})
      expect(notification).to.deep.equal
        userId: userId
        type: 'challengeProgressed'
        isRead: false
        params:
          challenge: challenge

  describe '.getTitle()', ->
    it '"pieceGraded"', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      notification = notificationHelpers.generateNotification('pieceGraded', {piece, userPiece})
      title = notificationHelpers.getTitle(notification)
      expect(title).to.equal "Video submission for Romanza graded 70%"

    it '"challengeProgressed"', ->
      userId = objectIdString()
      challenge = challengeFactory.create({userId, type: 'firstVideo', quantityCompleted: 1, quantityToComplete: 3})
      notification = notificationHelpers.generateNotification('challengeProgressed', {challenge})
      title = notificationHelpers.getTitle(notification)
      expect(title).to.equal 'Completed 1/3 of challenge "Submit First Video"'

  describe '.getTitle()', ->
    it '"pieceGraded"', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      notification = notificationHelpers.generateNotification('pieceGraded', {piece, userPiece})
      title = notificationHelpers.getTitle(notification)
      expect(title).to.equal "Video submission for Romanza graded 70%"

    it '"challengeProgressed"', ->
      userId = objectIdString()
      challenge = challengeFactory.create({userId, type: 'firstVideo', quantityCompleted: 1, quantityToComplete: 3})
      notification = notificationHelpers.generateNotification('challengeProgressed', {challenge})
      title = notificationHelpers.getTitle(notification)
      expect(title).to.equal 'Completed 1/3 of challenge "Submit First Video"'

  describe '.getDescription()', ->
    it '"pieceGraded"', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      notification = notificationHelpers.generateNotification('pieceGraded', {piece, userPiece})
      description = notificationHelpers.getDescription(notification)
      expect(description).to.equal "Your video submission for Romanza was graded 70% and you received a teacher comment."

    it '"challengeProgressed"', ->
      userId = objectIdString()
      challenge = challengeFactory.create
        userId: userId
        type: 'firstVideo'
        quantityCompleted: 3
        quantityToComplete: 3
        reward:
          credits: 10
      notification = notificationHelpers.generateNotification('challengeProgressed', {challenge})
      description = notificationHelpers.getDescription(notification)
      expect(description).to.equal 'Completed 3/3 of challenge "Submit First Video" and earned $10 lesson credits'

  describe '.getLink()', ->
    it '"pieceGraded"', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      notification = notificationHelpers.generateNotification('pieceGraded', {piece, userPiece})
      title = notificationHelpers.getLink({notification, serverUrl: 'http://guitarquest.com'})
      expect(title).to.equal "http://guitarquest.com/#/pieces/#{pieceId}"

    it '"challengeProgressed"', ->
      userId = objectIdString()
      challenge = challengeFactory.create
        userId: userId
        type: 'firstVideo'
        quantityCompleted: 3
        quantityToComplete: 3
        reward:
          credits: 10
      notification = notificationHelpers.generateNotification('challengeProgressed', {challenge})
      link = notificationHelpers.getLink({notification, serverUrl: 'http://guitarquest.com'})
      expect(link).to.equal "http://guitarquest.com/#/challenges"
