initialQuests = ['firstVideo']
genericQuests = ['level', 'era', 'sightReading', 'perfectGrade']

module.exports =
  initialQuestTypes: initialQuests
  genericQuestTypes: genericQuests
  questTypes: initialQuests.concat genericQuests
