mongoose = require 'mongoose'
pieceEnums = require './enums'
database = require 'local_modules/database'

###
canonical information about piece shared between all users
###
schema = new mongoose.Schema
  name: {type: String, required: true}
  composer: {type: String, required: true}
  level: {type: Number, required: true}
  era: {type: String, required: true, enum: pieceEnums.musicalEras}
  sheetMusicURL: {type: String, required: true}
  spotifyURI: {type: String, required: true}
  description: {type: String, required: true}

schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'Piece', schema

module.exports = model
