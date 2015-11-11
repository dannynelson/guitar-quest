pieceEnums = require './enums'

module.exports =
  type: 'object'
  description: 'canonical information about piece shared between all users'
  required: ['name', 'composer', 'level', 'era']
  properties:
    _id:
      type: 'string'
      format: 'objectid'

    name:
      type: 'string'

    composer:
      type: 'string'

    level:
      type: 'integer'

    era:
      type: 'string', enum: pieceEnums.musicalEras

    spotifyURI:
      type: 'string'

