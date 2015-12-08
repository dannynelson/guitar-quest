require 'local_modules/test_helpers/server'
objectIdString = require 'objectid'
database = require 'local_modules/database'
Challenge = require 'local_modules/models/challenge'
User = require 'local_modules/models/user'
userFactory = require 'local_modules/models/user/factory'
Piece = require 'local_modules/models/piece'
pieceFactory = require 'local_modules/models/piece/factory'
UserPiece = require 'local_modules/models/user_piece'
userPieceFactory = require 'local_modules/models/user_piece/factory'

describe 'UserPiece hooks', ->
  beforeEach database.reset

  it 'copies any changes to history', ->

