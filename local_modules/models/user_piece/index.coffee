###
Track user progress as they work on a piece
###

mongoose = require 'mongoose'
_ = require 'lodash'
database = require 'local_modules/database'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'

JSONSchemaClone = do ->
  clone = _.cloneDeep(JSONSchema)
  delete clone.properties.createdAt
  delete clone.properties.updatedAt
  clone

schema = JSONSchemaConverter.toMongooseSchema(JSONSchemaClone, mongoose)
schema.plugin require('mongoose-timestamp')
require('./hooks')(schema)
require('./virtuals')(schema)
require('./methods')(schema)
model = database.mongooseConnection.model 'UserPiece', schema

module.exports = model
