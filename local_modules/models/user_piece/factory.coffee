unionized = require 'unionized'
JSONSchema = require './schema'
objectIdString = require 'objectid'

module.exports = unionized.JSONSchemaFactory(JSONSchema).factory
  'updatedBy': objectIdString()
