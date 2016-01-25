mongoose = require 'mongoose'
passportLocalMongoose = require 'passport-local-mongoose'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
database = require 'local_modules/database'

schema = JSONSchemaConverter.toMongooseSchema(JSONSchema, mongoose)
schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'LoginToken', schema

module.exports = model
