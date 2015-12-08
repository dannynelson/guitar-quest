require 'local_modules/test_helpers/chai_config'
levelHelper = require './index'

describe 'levelHelper', ->
  it '.getPointsPerPiece(level)', ->
    expect(levelHelper.getPointsPerPiece(1)).to.equal 140

  it '.getTotalLevelPoints(level)', ->
    expect(levelHelper.getTotalLevelPoints(2)).to.equal 4000

  it '.getSheetMusicURL(level)', ->
    expect(levelHelper.getSheetMusicURL(1)).to.equal 'http://www.sheetmusicplus.com/title/bridges-a-comprehensive-guitar-series-guitar-repertoire-and-studies-1-sheet-music/19528890?aff_id=465759'

  it '.displayPiecePoints(pieceGrade, level)', ->
    expect(levelHelper.displayPiecePoints(0.5, 1)).to.equal '70 / 140'

  it '.calculateCurrentLevel(totalUserPoints)', ->
    expect(levelHelper.calculateCurrentLevel(8700)).to.equal 2
    expect(levelHelper.calculateCurrentLevel(8800)).to.equal 3

  it '.calculatePointsIntoLevel(totalUserPoints, level)', ->
    expect(levelHelper.calculatePointsIntoLevel(50, 0)).to.equal 50
    expect(levelHelper.calculatePointsIntoLevel(8700, 1)).to.equal 2800
    expect(levelHelper.calculatePointsIntoLevel(8700, 2)).to.equal 3900
    expect(levelHelper.calculatePointsIntoLevel(8700, 3)).to.equal 0
    expect(levelHelper.calculatePointsIntoLevel(148800, 9)).to.equal 44800
