require 'local_modules/test_helpers/chai_config'
_ = require 'lodash'
objectIdString = require 'objectid'
challengeEnums = require 'local_modules/models/challenge/enums'
userFactory = require 'local_modules/models/user/factory'
pieceFactory = require 'local_modules/models/piece/factory'
userPieceFactory = require 'local_modules/models/user_piece/factory'
challengeHelpers = require './index'

describe 'challengeHelpers', ->
  describe '.generateChallenge()', ->
    it 'creates a challenge object', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      challenge = challengeHelpers.generateChallenge('firstVideo', {user})
      expect(challenge).to.deep.equal
        userId: userId
        type: 'firstVideo'
        quantityToComplete: 1
        completed: false
        params: {}
        reward:
          credits: 10

    it 'does not error for all challenge types', ->
      user = userFactory.create({_id: objectIdString()})
      challengeEnums.challengeTypes.forEach (challengeType) ->
        challengeHelpers.generateChallenge(challengeType, {user})

  describe '.getTitle()', ->
    it 'works', ->
      user = userFactory.create({_id: objectIdString()})
      challenge = challengeHelpers.generateChallenge('firstVideo', {user})
      expect(challengeHelpers.getTitle(challenge)).to.equal 'Submit First Video'

    it 'does not error for all challenge types', ->
      user = userFactory.create({_id: objectIdString()})
      challengeEnums.challengeTypes.forEach (challengeType) ->
        challenge = challengeHelpers.generateChallenge(challengeType, {user})
        challengeHelpers.getTitle(challenge)

  describe '.getDescription()', ->
    it 'works', ->
      user = userFactory.create({_id: objectIdString()})
      challenge = challengeHelpers.generateChallenge('firstVideo', {user})
      expect(challengeHelpers.getDescription(challenge)).to.equal 'Submit a video for any guitar piece.'

    it 'does not error for all challenge types', ->
      user = userFactory.create({_id: objectIdString()})
      challengeEnums.challengeTypes.forEach (challengeType) ->
        challenge = challengeHelpers.generateChallenge(challengeType, {user})
        challengeHelpers.getDescription(challenge)

  describe '.generateInitialChallenges()', ->
    it 'works', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      challenges = challengeHelpers.generateInitialChallenges({user})
      expect(challenges).to.have.length 1
      expect(challenges[0]).to.deep.equal
        userId: userId
        type: 'firstVideo'
        quantityToComplete: 1
        completed: false
        params: {}
        reward:
          credits: 10

  describe '.generateRandomChallenge()', ->
    it 'works', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      challenge = challengeHelpers.generateRandomChallenge({user})
      expect(challenge).to.have.property 'userId', userId
      expect(challenge).to.have.property 'quantityToComplete'

    it 'allows excludes types', ->
      userId = objectIdString()
      user = userFactory.create({_id: userId})
      challenge = challengeHelpers.generateRandomChallenge({user, excludeChallengeTypes: ['level', 'era', 'perfectGrade']})
      expect(challenge).to.have.property 'type', 'sightReading'

  describe '.matchesConditions()', ->
    it 'returns true if piece and userPiece meet conditions', ->
      user = userFactory.create({_id: objectIdString()})
      piece = pieceFactory.create()
      userPiece = userPieceFactory.create()
      challenge = challengeHelpers.generateChallenge('sightReading', {user})
      expect(challengeHelpers.matchesConditions(challenge, {piece, userPiece, user})).to.equal true

    it 'returns false if piece and userPiece do not meet conditions', ->
      user = userFactory.create({_id: objectIdString()})
      piece = pieceFactory.create()
      piece.grade = 0.2 # below condition requirement
      userPiece = userPieceFactory.create()
      challenge = challengeHelpers.generateChallenge('level', {user})
      expect(challengeHelpers.matchesConditions(challenge, {piece, userPiece, user})).to.equal false

    describe 'challenge types', ->
      itMatchesConditions = (trueOrFalse, challengeType, {piece, userPiece, user, challenge, challengeParams}={}) ->
        it "#{if trueOrFalse then "matches" else "does not match"} conditions for #{challengeType}", ->
          user._id = objectIdString()
          user = userFactory.create(user)
          piece = pieceFactory.create(piece)
          piece._id = objectIdString()
          userPiece = userPieceFactory.create(userPiece)
          userPiece.pieceId = piece._id
          userPiece.userId = user._id
          generatedChallenge = challengeHelpers.generateChallenge(challengeType, {piece, userPiece, user})
          generatedChallenge = _.merge(generatedChallenge, {params: challengeParams}) # override any custom params
          expect(challengeHelpers.matchesConditions(generatedChallenge, {piece, userPiece, user})).to.equal trueOrFalse

      itMatchesConditions true, 'firstVideo',
        user: {}
        piece: {}
        userPiece: {}
        challengeParams: {}

      itMatchesConditions true, 'level',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 0.8}
        challengeParams: {}

      # grade too low
      itMatchesConditions false, 'level',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 0.7}
        challengeParams: {}

      # wrong level
      itMatchesConditions false, 'level',
        user: {level: 2}
        piece: {level: 2}
        userPiece: {grade: 0.8}
        challengeParams: {level: 1}

      itMatchesConditions true, 'era',
        user: {level: 1}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.8}
        challengeParams: {era: 'baroque'}

      # not current level
      itMatchesConditions false, 'era',
        user: {level: 2}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.8}
        challengeParams: {era: 'baroque'}

      # not correct era
      itMatchesConditions false, 'era',
        user: {level: 1}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.8}
        challengeParams: {era: 'classical'}

      # grade too low
      itMatchesConditions false, 'era',
        user: {level: 1}
        piece: {level: 1, era: 'baroque'}
        userPiece: {grade: 0.7}
        challengeParams: {era: 'baroque'}

      itMatchesConditions true, 'sightReading',
        user: {}
        piece: {}
        userPiece: {}
        challengeParams: {}

      itMatchesConditions true, 'perfectGrade',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 1}
        challengeParams: {}

      # not current level
      itMatchesConditions false, 'perfectGrade',
        user: {level: 2}
        piece: {level: 1}
        userPiece: {grade: 1}
        challengeParams: {}

      itMatchesConditions false, 'perfectGrade',
        user: {level: 1}
        piece: {level: 1}
        userPiece: {grade: 0.9}
        challengeParams: {}
