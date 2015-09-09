settings = require 'local_modules/settings'
module.exports  = require('sendgrid')(settings.sendgrid.apiKey)
