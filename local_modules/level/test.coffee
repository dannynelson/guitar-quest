require 'local_modules/test_helpers/chai_config'
levelHelper = require './index'

describe 'levelHelper', ->
  it '.getPointsPerPiece(level)', ->
    expect(levelHelper.getPointsPerPiece(2)).to.equal 140

  it '.getTotalLevelPoints(level)', ->
    expect(levelHelper.getTotalLevelPoints(3)).to.equal 4000

  it '.displayPiecePoints(pieceGrade, level)', ->
    expect(levelHelper.displayPiecePoints(0.5, 2)).to.equal '70 / 140'

  it '.calculateCurrentLevel(totalUserPoints)', ->
    expect(levelHelper.calculateCurrentLevel(8700)).to.equal 3
    expect(levelHelper.calculateCurrentLevel(8800)).to.equal 4

  it '.calculatePointsIntoLevel(totalUserPoints, level)', ->
    expect(levelHelper.calculatePointsIntoLevel(50, 1)).to.equal 50
    expect(levelHelper.calculatePointsIntoLevel(8700, 2)).to.equal 2800
    expect(levelHelper.calculatePointsIntoLevel(8700, 3)).to.equal 3900
    expect(levelHelper.calculatePointsIntoLevel(8700, 4)).to.equal 0
    expect(levelHelper.calculatePointsIntoLevel(148800, 10)).to.equal 44800
