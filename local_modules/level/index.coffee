# when you are at a given level, how many points does it take to get to the next level
expByLevel =
  "1": 10
  "2": 20
  "3": 30

module.exports =
  getExpToNextLevel: (exp, selectedLevel) ->
    nextLevel = selectedLevel +  1
    expRequired = totalExpByLevel[nextLevel]
    expRequired - exp

  getTotalLevelExp: (level) ->
    expByLevel[level]
