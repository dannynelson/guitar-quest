var unionized = require('unionized')
var JSONSchema = require('./schema')
var objectIdString = require('objectid')

module.exports = unionized.JSONSchemaFactory(JSONSchema).factory({
  _id: function() { return objectIdString(); }
})
