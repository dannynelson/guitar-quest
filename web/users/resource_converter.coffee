ResourceSchema = require 'resource-schema'
User = require 'local_modules/models/user'

module.exports = new ResourceSchema User, {
  '_id'
  'email'
  'exp'
}
