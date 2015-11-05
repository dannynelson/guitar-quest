###
Quests to show once a user arrives at each level
###
module.exports.generate = (user) ->
  musicEras = ['renaissance', 'baroque', 'classical', 'romantic', 'contemporary']
  musicEras.map (era) ->
    userId: user._id
    name: "Complete 3 level #{user.level} pieces from the #{era} era"
    quantityCompleted: 0
    quantityToComplete: 3
    completed: false
    conditions:
      userPiece:
        status: 'graded'
      piece:
        level: user.level
        era: era
    reward:
      credit: 5 + (user.level * 5)
