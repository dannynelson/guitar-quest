mongoose = require 'mongoose'
database = require 'local_modules/database'

schema = new mongoose.Schema
  name: {type: String, required: true}
  reward: {type: String, required: true}

schema.plugin require('mongoose-timestamp')

model = database.mongooseConnection.model 'Quest', schema

module.exports = model
