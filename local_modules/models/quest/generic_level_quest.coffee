module.exports.generate = (userLevel) ->
  name: "Complete any 3 level #{userLevel} pieces"
  # quantity of pieces with matching conditions that need to be completed
  # to finish this quest
  quantityToComplete: 3
  quantityCompleted: 0
  # user level necessary in order to display the quest
  pieceConditions:
    level: userLevel
  reward:
    credit: userLevel * 5
