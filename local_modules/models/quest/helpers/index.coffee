###
Helpers for working with quests
###

_ = require 'lodash'

# conditions required to complete each quest type
pieceEnums = require 'local_modules/models/piece/enums'
userPieceEnums = require 'local_modules/models/user_piece/enums'
questEnums = require 'local_modules/models/quest/enums'

chooseRandom = (items) ->
  items[Math.floor(Math.random() * items.length)]

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

buildQuest = ({userId, type, quantityToComplete, params, credits}) ->
  userId: userId
  type: type
  quantityCompleted: 0
  quantityToComplete: quantityToComplete
  completed: false
  params: params
  reward:
    credits: credits

questDefinitions =
  # ================== initial =========================
  'firstVideo':
    title: ({quest}) -> "Submit First Video"
    description: ({quest}) -> "Submit a video for any guitar piece."
    quest: ({user}) ->
      buildQuest
        userId: user._id.toString()
        type: 'firstVideo'
        quantityToComplete: 1
        params: {}
        credits: 10
    conditions: ({quest, piece, userPiece}) ->
      userPiece.submissionVideoURL?

  # ==================== generic ==========================
  'level':
    title: ({quest}) -> "Level #{quest.params.level} Practice"
    description: ({quest}) -> "Complete any 3 pieces from level #{quest.params.level} with at least an 80% grade."
    quest: ({user}) ->
      questLevel = _.random(1, user.level)
      buildQuest
        userId: user._id.toString()
        type: 'level'
        quantityToComplete: 3
        params:
          'level': questLevel
        credits: 8 + (2 * questLevel)
    conditions: ({quest, piece, userPiece}) ->
      userPiece.grade >= 0.8 and piece.level is quest.params.level

  'era':
    title: ({quest}) -> "Submit #{capitalize(quest.params.era)} Video"
    description: ({quest}) -> "Complete any 3 pieces from the #{quest.params.era} era with at least an 80% grade."
    quest: ({user}) ->
      userId: user._id.toString()
      type: 'era'
      quantityToComplete: 3
      params:
        'era': chooseRandom(pieceEnums.musicalEras)
      credits: chooseRandom([10, 15])
    conditions: ({quest, piece, userPiece}) ->
      userPiece.grade >= 0.8 and piece.era is quest.params.era

  'sightReading':
    title: ({quest}) -> "Sight Reading Practice"
    description: ({quest}) -> "Submit videos for any 6 pieces (grade does not matter)."
    quest: ({user}) ->
      buildQuest
        userId: user._id.toString()
        type: 'sightReading'
        quantityToComplete: 6
        params: {}
        credits: chooseRandom([10, 15])
    conditions: ({quest, piece, userPiece}) ->
      userPiece.submissionVideoURL?

  'perfectGrade':
    title: ({quest}) -> "Perfect Grade"
    description: ({quest}) -> "Complete any 2 pieces with a 100% grade."
    quest: ({user}) ->
      buildQuest
        userId: user._id.toString()
        type: 'perfectGrade'
        quantityToComplete: 2
        params: {}
        credits: chooseRandom([10, 15])
    conditions: ({quest, piece, userPiece}) ->
      piece.grade is _.max(userPieceEnums.grades)

  # 'technique':

  # 'composer':

module.exports = questHelpers =
  getTitle: (quest) ->
    questDefinitions[quest.type]?.title({quest})

  getDescription: (quest) ->
    questDefinitions[quest.type]?.description({quest})

  generateQuest: (type, {user}) ->
    questDefinitions[type].quest({user})

  generateInitialQuests: ({user}) ->
    questEnums.initialQuestTypes.map (questType) ->
      questHelpers.generateQuest(questType, {user})

  generateRandomQuest: ({user}) ->
    questType = chooseRandom(questEnums.genericQuestTypes)
    questHelpers.generateQuest(questType, {user})

  matchesConditions: (quest, {piece, userPiece}) ->
    questDefinitions[quest.type].conditions({quest, piece, userPiece})

  ## very complicated: does not seem worth it. Just give them a random one, and the can cancel it if it is not completable
  # (which should never happen since they can resubmit old pieces that have already been submitted)
  # generateQuestThatIsCompletable: (quest, {pieces, userPieces}) ->
  #   userPiecesById = _.indexBy userPieces, '_id'
  #   pieceAndUserPiecePairs = pieces.map (piece) ->
  #     piece: piece
  #     userPiece: userPiecesById[piece._id.toString()]
  #   # filter for pieces that user has access to
  #   # generate every possible quest combination given the param enums
  #   # given each quest possible, do a find an all piece/userPiece pairs to count number of matches of each
  #   # filter all matches for ones that are greater than the required quantity
  #   # of all the ones remaining, choose a random one
