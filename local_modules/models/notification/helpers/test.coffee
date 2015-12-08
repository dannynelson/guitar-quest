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
    it '"pieceGraded"', ->
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

    it '"challengeProgressed"', ->
      userId = objectIdString()
      challenge = challengeFactory.create({userId})
      notification = notificationHelpers.generateNotification('challengeProgressed', {challenge})
      expect(notification).to.deep.equal
        userId: userId
        type: 'challengeProgressed'
        isRead: false
        params:
          challenge: challenge

    it '"levelUp"', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId, level: 2})
      notification = notificationHelpers.generateNotification('levelUp', {user})
      expect(notification).to.deep.equal
        userId: userId
        type: 'levelUp'
        isRead: false
        params:
          level: 2

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

    it '"levelUp"', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId, level: 2})
      notification = notificationHelpers.generateNotification('levelUp', {user})
      title = notificationHelpers.getTitle(notification)
      expect(title).to.equal 'Advanced to Level 2'

  describe '.getDescription()', ->
    it '"pieceGraded"', ->
      userId = objectIdString()
      pieceId = objectIdString()
      piece = pieceFactory.create({_id: pieceId, name: 'Romanza'})
      userPiece = userPieceFactory.create({grade: 0.7, comment: 'Good job!', userId: userId})
      notification = notificationHelpers.generateNotification('pieceGraded', {piece, userPiece})
      description = notificationHelpers.getDescription(notification)
      expect(description).to.equal "Video submission for <em>Romanza</em> graded <strong>70%</strong> and received a comment"

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
      expect(description).to.equal 'Completed <strong>3/3</strong> of challenge <strong>Submit First Video</strong> and earned <strong>$10 lesson credits</strong>'

    it '"levelUp"', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId, level: 2})
      notification = notificationHelpers.generateNotification('levelUp', {user})
      description = notificationHelpers.getDescription(notification)
      expect(description).to.equal 'You advanced to <strong>Level 2</strong> and unlocked new pieces'

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

    it '"levelUp"', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId, level: 2})
      notification = notificationHelpers.generateNotification('levelUp', {user})
      link = notificationHelpers.getLink({notification, serverUrl: 'http://guitarquest.com'})
      expect(link).to.equal "http://guitarquest.com/#/pieces_by_level/2"

