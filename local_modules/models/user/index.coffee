mongoose = require 'mongoose'
passportLocalMongoose = require 'passport-local-mongoose'
# require('mongoose-extensions')(mongoose)
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
database = require 'local_modules/database'

schema = JSONSchemaConverter.toMongooseSchema(JSONSchema, mongoose)

schema.plugin require('mongoose-timestamp')
schema.plugin passportLocalMongoose,
  usernameField: 'email'

require('./hooks')(schema)

schema.index({'email': 1}, { unique: true })

model = database.mongooseConnection.model 'User', schema


module.exports = model
