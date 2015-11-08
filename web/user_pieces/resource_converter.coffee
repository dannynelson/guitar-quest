_ = require 'lodash'
ResourceSchema = require 'resource-schema'
UserPiece = require 'local_modules/models/user_piece'
Piece = require 'local_modules/models/piece'
User = require 'local_modules/models/user'

schema = Object.keys(UserPiece.schema.paths).reduce (obj, path) ->
  obj[path] = path
  obj
, {}

_.extend schema,
  'user':
    optional: true
    get: (userPiece, {usersById}) ->
      usersById[userPiece.userId.toString()]
    resolve:
      usersById: ({models}, done) ->
        userPieces = models
        User
          .find({_id: {$in: userPieces.map (userPiece) -> userPiece.userId}})
          .select('name email')
          .exec()
        .then (users) ->
          usersById = _.indexBy users, '_id'
          done(null, usersById)
        .then null, (err) ->
          throw err

  'piece':
    optional: true
    get: (userPiece, {piecesById}) ->
      piecesById[userPiece.pieceId.toString()]
    resolve:
      piecesById: ({models}, done) ->
        userPieces = models
        Piece
          .find({_id: {$in: userPieces.map (userPiece) -> userPiece.pieceId}})
          .select('name')
          .exec()
        .then (pieces) ->
          piecesById = _.indexBy pieces, '_id'
          done(null, piecesById)
        .then null, (err) ->
          throw err

  'historyChanges':
    optional: true
    get: (model) ->
      # a hack until I find the bug in json schema
      new UserPiece(model).historyChanges or []

  'updatedBy':
    field: 'updatedBy'
    set: (value, {req, res, next}) -> req.user._id

module.exports = new ResourceSchema UserPiece, schema
