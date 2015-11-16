require 'local_modules/test_helpers/chai_config'
_ = require 'lodash'
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
      expect(quest).to.have.property 'quantityToComplete'
      console.log {quest}

    it 'allows excludes types', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      quest = questHelpers.generateRandomQuest({user, excludeQuestTypes: ['level', 'era', 'perfectGrade']})
      expect(quest).to.have.property 'type', 'sightReading'

  describe '.matchesConditions()', ->
    it 'returns true if piece and userPiece meet conditions', ->
      user = userFactory.create({_id: objectIdString()})
      piece = pieceFactory.create()
      userPiece = userPieceFactory.create()
      quest = questHelpers.generateQuest('sightReading', {user})
      expect(questHelpers.matchesConditions(quest, {piece, userPiece, user})).to.equal true

    it 'returns false if piece and userPiece do not meet conditions', ->
      user = userFactory.create({_id: objectIdString()})
      piece = pieceFactory.create()
      piece.grade = 0.2 # below condition requirement
      userPiece = userPieceFactory.create()
      quest = questHelpers.generateQuest('level', {user})
      expect(questHelpers.matchesConditions(quest, {piece, userPiece, user})).to.equal false

    describe 'quest types', ->
      itMatchesConditions = (trueOrFalse, questType, {piece, userPiece, user, quest, questParams}={}) ->
        it "#{if trueOrFalse then "matches" else "does not match"} conditions for #{questType}", ->
          user._id = objectIdString()
          user = userFactory.create(user)
          piece = pieceFactory.create(piece)
          piece._id = objectIdString()
          userPiece = userPieceFactory.create(userPiece)
          userPiece.pieceId = piece._id
          userPiece.userId = user._id
          generatedQuest = questHelpers.generateQuest(questType, {piece, userPiece, user})
          generatedQuest = _.merge(generatedQuest, {params: questParams}) # override any custom params
          expect(questHelpers.matchesConditions(generatedQuest, {piece, userPiece, user})).to.equal trueOrFalse

      itMatchesConditions true, 'firstVideo',
        user: {}
        piece: {}
        userPiece: {}
        questParams: {}

      itMatchesConditions true, 'level',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 0.8}
        questParams: {}

      # grade too low
      itMatchesConditions false, 'level',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 0.7}
        questParams: {}

      # wrong level
      itMatchesConditions false, 'level',
        user: {level: 2}
        piece: {level: 2}
        userPiece: {grade: 0.8}
        questParams: {level: 1}

      itMatchesConditions true, 'era',
        user: {level: 1}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.8}
        questParams: {era: 'baroque'}

      # not current level
      itMatchesConditions false, 'era',
        user: {level: 2}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.8}
        questParams: {era: 'baroque'}

      # not correct era
      itMatchesConditions false, 'era',
        user: {level: 1}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.8}
        questParams: {era: 'classical'}

      # grade too low
      itMatchesConditions false, 'era',
        user: {level: 1}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.7}
        questParams: {era: 'baroque'}

      # itMatchesConditions true, 'sightReading',
      #   user: {}
      #   piece: {}
      #   userPiece: {}
      #   questParams: {}

      itMatchesConditions true, 'perfectGrade',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 1}
        questParams: {}

      # not current level
      itMatchesConditions false, 'perfectGrade',
        user: {level: 2}
        piece: {level: 1}
        userPiece: {grade: 1}
        questParams: {}

      itMatchesConditions false, 'perfectGrade',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 0.9}
        questParams: {}
