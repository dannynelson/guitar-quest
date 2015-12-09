mongoose = require 'mongoose'
joi = require 'joi'
_ = require 'lodash'
Promise = require 'bluebird'
normalizeEmail = require 'normalize-email'
passportLocalMongoose = require 'passport-local-mongoose'
JSONSchemaConverter = require 'goodeggs-json-schema-converter'
JSONSchema = require './schema'
database = require 'local_modules/database'
levelHelper = require 'local_modules/level'

JSONSchemaClone = _.cloneDeep(JSONSchema)
JSONSchemaClone.required.push ['emailId']
JSONSchemaClone.properties.emailId =
  type: 'string'

schema = JSONSchemaConverter.toMongooseSchema(JSONSchemaClone, mongoose)

schema.plugin require('mongoose-timestamp')
schema.plugin passportLocalMongoose,
  usernameField: 'emailId'

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

# normalize email
schema.pre 'save', (next) ->
  if @isModified 'email'
    @emailId = normalizeEmail(@email)
  next()

schema.index({'emailId': 1}, { unique: true })

model = database.mongooseConnection.model 'User', schema

module.exports = model
