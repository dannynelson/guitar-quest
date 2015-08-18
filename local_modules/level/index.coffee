# when you are on the previous level, this is how much more exp you need to reach this level
expByLevel =
  "1": 0
  "2": 10
  "3": 20


# total exp needed to reach each level
totalExpByLevel = do ->
  totalExp = 0
  result = {}
  for level, levelExp of expByLevel
    totalExp += levelExp
    result[level] = totalExp
  result

module.exports =
  getLevel: (exp) ->
    userLevel = 1
    for level, levelExp of totalExpByLevel
      if exp >= levelExp
        userLevel = parseInt(level)
      else
        break
    return userLevel

  getExpToNextLevel: (exp, selectedLevel) ->
    nextLevel = selectedLevel +  1
    expRequired = totalExpByLevel[nextLevel]
    expRequired - exp

  getTotalLevelExp: (level) ->
    expByLevel[level]

  getExpIntoSelectedLevel: (totalExp, selectedLevel) ->
    experienceOverage = totalExp - totalExpByLevel[selectedLevel]
    result =
      if experienceOverage < 0
        0
      else if experienceOverage > expByLevel[selectedLevel]
        expByLevel[selectedLevel]
      else
        experienceOverage
    return result
