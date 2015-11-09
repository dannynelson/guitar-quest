mongoose = require 'mongoose'
jsonSchemaConverter = require 'goodeggs-json-schema-converter'
database = require 'local_modules/database'
JSONSchema = require './schema'

schema = jsonSchemaConverter.toMongooseSchema(JSONSchema, mongoose)
schema.plugin require('mongoose-timestamp')
model = database.mongooseConnection.model 'Notification', schema

module.exports = model
