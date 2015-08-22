mongoose = require 'mongoose'
passportLocalMongoose = require 'passport-local-mongoose'
# require('mongoose-extensions')(mongoose)
# {toMongooseSchema} = require 'goodeggs-json-schema-converter'

database = require 'local_modules/database'

# modelSchema = require './model_json_schema'

schema = new mongoose.Schema
  # email added by passportLocalMongoose
  level: {type: Number, required: true, default: 1}
  pointsIntoCurrentLevel: {type: Number, required: true, default: 0}
  # skype lesson credit available
  credit: {type: Number, required: true, default: 0}

schema.plugin require('mongoose-timestamp')
schema.plugin passportLocalMongoose,
  usernameField: 'email'

require('./hooks')(schema)

model = database.mongooseConnection.model 'User', schema

module.exports = model
