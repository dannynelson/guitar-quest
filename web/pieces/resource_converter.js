// Generated by CoffeeScript 1.10.0
(function() {
  var Piece, ResourceSchema, UserPiece, _;

  _ = require('lodash');

  ResourceSchema = require('resource-schema');

  Piece = require('local_modules/models/piece');

  UserPiece = require('local_modules/models/user_piece');

  module.exports = new ResourceSchema(Piece, {
    '_id': '_id',
    'name': 'name',
    'composer': 'composer',
    'level': 'level',
    'era': 'era',
    'points': 'points',
    'sheetMusicURL': 'sheetMusicURL',
    'spotifyURI': 'spotifyURI',
    'description': 'description',
    'status': {
      resolve: {
        'userPiecesByPieceId': function(arg, done) {
          var models;
          models = arg.models;
          return UserPiece.find({
            pieceId: {
              $in: models.map(function(model) {
                return model._id.toString();
              })
            }
          }).then(function(userPieces) {
            var userPiecesByPieceId;
            userPiecesByPieceId = _.indexBy(userPieces, 'pieceId');
            return done(null, userPiecesByPieceId);
          }).then(null, function() {
            return done(null, {});
          });
        }
      },
      get: function(pieceModel, arg) {
        var ref, userPiecesByPieceId;
        userPiecesByPieceId = arg.userPiecesByPieceId;
        return (ref = userPiecesByPieceId[pieceModel._id.toString()]) != null ? ref.status : void 0;
      }
    }
  });

}).call(this);
