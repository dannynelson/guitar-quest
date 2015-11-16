initialChallenges = ['firstVideo']
genericChallenges = ['level', 'era', 'sightReading', 'perfectGrade']

module.exports =
  initialChallengeTypes: initialChallenges
  genericChallengeTypes: genericChallenges
  challengeTypes: initialChallenges.concat genericChallenges
