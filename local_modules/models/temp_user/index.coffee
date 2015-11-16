mongoose = require 'mongoose'
# require('mongoose-extensions')(mongoose)
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
database = require 'local_modules/database'

schema = JSONSchemaConverter.toMongooseSchema(JSONSchema, mongoose)
schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'TempUser', schema
schema.index({'email': 1}, { unique: true })

module.exports = model
