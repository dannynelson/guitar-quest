mongoose = require 'mongoose'
passportLocalMongoose = require 'passport-local-mongoose'
# require('mongoose-extensions')(mongoose)
# {toMongooseSchema} = require 'goodeggs-json-schema-converter'

database = require 'local_modules/database'

# modelSchema = require './model_json_schema'

schema = new mongoose.Schema
  exp: {type: Number, required: true, default: 0}
  # email added by passportLocalMongoose

schema.plugin require('mongoose-timestamp')
schema.plugin passportLocalMongoose,
  usernameField: 'email'


model = database.mongooseConnection.model 'User', schema

module.exports = model
