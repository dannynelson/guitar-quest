###
when you are at a given level, how many points does it take to get to the next level
- all pieces will be divisible by 10 so that we can grade everything on a 10 point scale
- it takes approximately 15 perfect pieces to get to the next level
- most books have 40 - 45 pieces
- every 2 levels is twice as hard as the current level (so the pieces give twice as many points)

I will want to change these things, so
- users current level should never change
- save score for each piece, so that we can recalculate users total points/level at any time
 based on the pieces they've completed

challengeions
- what if I want to add a level before level 1 (Early beginner)

FIXME: this needs refinement if someone ever maxes out level 10

###
_ = require 'lodash'

# assuming average finished grade of 20%, it will take them 20 to get to the next level
perfectPiecesRequiredToProgressToNextLevel = 15

sheetMusicPlusLinkByLevel =
  "0": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-preparatory-guitar-repertoire-and-studies-sheet-music/19528889?aff_id=465759'
  "1": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-1-sheet-music/19528890?aff_id=465759'
  "2": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-2-sheet-music/19528891?aff_id=465759'
  "3": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-3-sheet-music/19528892?aff_id=465759'
  "4": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-4-sheet-music/19528893?aff_id=465759'
  "5": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-5-sheet-music/19528894?aff_id=465759'
  "6": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-6-sheet-music/19528895?aff_id=465759'
  "7": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-7-sheet-music/19528896?aff_id=465759'
  "8": 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-8-sheet-music/19528897?aff_id=465759'

piecePointsByLevel =
  "0": 100 # each piece 100 points
  "1": 140 # each piece about 140 points
  "2": 200 # each piece about 200 points
  "3": 280 # each piece about 280 points
  "4": 400 # each piece about 400 points
  "5": 560 # each piece about 560 points
  "6": 800 # each piece about 800 points
  "7": 1120 # each piece about 1120 points
  "8": 1600 # each piece about 1600 points
  "9": 2240 # each piece about 2240 points

pointsByLevel = _.mapValues piecePointsByLevel, (pointsPerPiece) ->
  pointsPerPiece * perfectPiecesRequiredToProgressToNextLevel

cumulativePointsByLevel = _.mapValues pointsByLevel, (points, _level) ->
  level = Number(_level)
  _(_.range(0, level+1))
    .map (l) -> pointsByLevel[l]
    .sum()

maxLevel = _(Object.keys(piecePointsByLevel)).map(Number).max()

module.exports = level =
  getTotalLevelPoints: (level) ->
    pointsByLevel[level]

  getPointsPerPiece: (level) ->
    piecePointsByLevel[level]

  getLevelName: (level) ->
    level = Number(level)
    if level is 0
      return 'Preparatory Level'
    else
      return "Level #{level}"

  getSheetMusicURL: (level) ->
    sheetMusicPlusLinkByLevel[level]

  calculateCurrentLevel: (totalUserPoints) ->
    level = null
    for _level, points of pointsByLevel
      level = Number(_level)
      totalUserPoints -= points
      return level if totalUserPoints < 0
    level

  calculatePointsIntoLevel: (totalUserPoints, level) ->
    # above this level
    if cumulativePointsByLevel[level] < totalUserPoints
      return pointsByLevel[level]
    # above previous level, below this level (or maxed out)
    else if level is maxLevel or (cumulativePointsByLevel[level-1] ? 0) < totalUserPoints < cumulativePointsByLevel[level]
      return totalUserPoints - (cumulativePointsByLevel[level - 1] ? 0)
    # below this level, below previous level
    else
      return 0

  displayPiecePoints: (pieceGrade, level) ->
    piecePoints = piecePointsByLevel[level]
    "#{(pieceGrade * piecePoints) || 0} / #{piecePoints}"
