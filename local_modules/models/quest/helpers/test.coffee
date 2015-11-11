require 'local_modules/test_helpers/chai_config'
objectIdString = require 'objectid'
questEnums = require 'local_modules/models/quest/enums'
userFactory = require 'local_modules/models/user/factory'
pieceFactory = require 'local_modules/models/piece/factory'
userPieceFactory = require 'local_modules/models/user_piece/factory'
questHelpers = require './index'

describe 'questHelpers', ->
  describe '.generateQuest()', ->
    it 'creates a quest object', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      quest = questHelpers.generateQuest('firstVideo', {user})
      expect(quest).to.deep.equal
        userId: userId
        type: 'firstVideo'
        quantityCompleted: 0
        quantityToComplete: 1
        completed: false
        params: {}
        reward:
          credits: 10

    it 'does not error for all quest types', ->
      user = userFactory.create({_id: objectIdString()})
      questEnums.questTypes.forEach (questType) ->
        questHelpers.generateQuest(questType, {user})

  describe '.getTitle()', ->
    it 'works', ->
      user = userFactory.create({_id: objectIdString()})
      quest = questHelpers.generateQuest('firstVideo', {user})
      expect(questHelpers.getTitle(quest)).to.equal 'Submit First Video'

    it 'does not error for all quest types', ->
      user = userFactory.create({_id: objectIdString()})
      questEnums.questTypes.forEach (questType) ->
        quest = questHelpers.generateQuest(questType, {user})
        questHelpers.getTitle(quest)

  describe '.getDescription()', ->
    it 'works', ->
      user = userFactory.create({_id: objectIdString()})
      quest = questHelpers.generateQuest('firstVideo', {user})
      expect(questHelpers.getDescription(quest)).to.equal 'Submit a video for any guitar piece.'

    it 'does not error for all quest types', ->
      user = userFactory.create({_id: objectIdString()})
      questEnums.questTypes.forEach (questType) ->
        quest = questHelpers.generateQuest(questType, {user})
        questHelpers.getDescription(quest)

  describe '.generateInitialQuests()', ->
    it 'works', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      quests = questHelpers.generateInitialQuests({user})
      expect(quests).to.have.length 1
      expect(quests[0]).to.deep.equal
        userId: userId
        type: 'firstVideo'
        quantityCompleted: 0
        quantityToComplete: 1
        completed: false
        params: {}
        reward:
          credits: 10

  describe '.generateRandomQuest()', ->
    it 'works', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      quest = questHelpers.generateRandomQuest({user})
      expect(quest).to.have.property 'userId', userId
      expect(quest).to.have.property 'quantityCompleted', 0

  describe '.matchesConditions()', ->
    it 'returns true if piece and userPiece meet conditions', ->
      user = userFactory.create({_id: objectIdString()})
      piece = pieceFactory.create()
      userPiece = userPieceFactory.create()
      quest = questHelpers.generateQuest('sightReading', {user})
      expect(questHelpers.matchesConditions(quest, {piece, userPiece})).to.equal true

    it 'returns false if piece and userPiece do not meet conditions', ->
      user = userFactory.create({_id: objectIdString()})
      piece = pieceFactory.create()
      piece.grade = 0.2 # below condition requirement
      userPiece = userPieceFactory.create()
      quest = questHelpers.generateQuest('level', {user})
      expect(questHelpers.matchesConditions(quest, {piece, userPiece})).to.equal false
