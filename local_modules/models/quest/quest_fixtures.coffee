###
Quests to show once a user arrives at each level
###

pieceEnums = require 'local_modules/models/piece/enums'

selectRandomQuestLevel = (level) ->
  Math.ceil(Math.random() * level)

generateMusicalEraQuest = (user, era) ->
  questLevel = selectRandomQuestLevel(user.level)
  return {
    userId: user._id
    name: "Complete 2 level #{questLevel}, #{era} era pieces with at least an 80% grade"
    quantityToComplete: 2
    conditions:
      userPiece:
        'grade': {gte: 0.8}
      piece:
        'level': questLevel
        'era': era
    reward:
      credit: 5 + (questLevel * 5)
  }

musicalEraQuests = pieceEnums.musicalEras.map (era) ->
  (user) ->
    generateMusicalEraQuest(user, era)

generateAnyPieceQuest = (user) ->
  questLevel = selectRandomQuestLevel(user.level)
  return {
    userId: user._id
    name: "Complete 3 level #{questLevel} pieces with at least an 80% grade"
    quantityToComplete: 3
    conditions:
      userPiece:
        'grade': {gte: 0.8}
      piece:
        'level': questLevel
    reward:
      credit: 5 + (questLevel * 5)
  }

generatePerfectGradeQuest = (user) ->
  questLevel = selectRandomQuestLevel(user.level)
  return {
    userId: user._id
    name: "Complete 2 level #{questLevel} pieces with a 100% grade"
    quantityCompleted: 0
    quantityToComplete: 3
    conditions:
      userPiece:
        'grade': 1
      piece:
        'level': questLevel
    reward:
      credit: 5 + (questLevel * 5)
  }

questGenerators = musicalEraQuest.concat generateAnyPieceQuest, generatePerfectGradeQuest

exports.generateRandomQuest = (user) ->
  questGenerator = questGenerators[Math.floor(Math.random()*questGenerators.length)]
  questGenerator(user)

exports.generateAnyPieceQuest = generateAnyPieceQuest

exports.generatePerfectGradeQuest = generatePerfectGradeQuest

exports.generateMusicalEraQuest = generateMusicalEraQuest

