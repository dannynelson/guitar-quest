mongoose = require 'mongoose'
joi = require 'joi'
Promise = require 'bluebird'
passportLocalMongoose = require 'passport-local-mongoose'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
database = require 'local_modules/database'
levelHelper = require 'local_modules/level'

schema = JSONSchemaConverter.toMongooseSchema(JSONSchema, mongoose)

schema.plugin require('mongoose-timestamp')
schema.plugin passportLocalMongoose,
  usernameField: 'email'

schema.methods.addPoints = Promise.method (points) ->
  Notification = require 'local_modules/models/notification'
  joi.assert points, joi.number().integer().required(), 'points'
  @points += points
  newLevel = levelHelper.calculateCurrentLevel(@points)
  # user can never go below current level
  if newLevel > @level
    @level = newLevel
    Notification.createNew('levelUp', {user: @})
  @save()

require('./hooks')(schema)

schema.index({'email': 1}, { unique: true })

model = database.mongooseConnection.model 'User', schema

module.exports = model
