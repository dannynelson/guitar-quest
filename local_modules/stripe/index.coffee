settings = require 'local_modules/settings'
module.exports = require('stripe')(settings.stripe.secretKey)
