Promise = require 'bluebird'
User = require 'local_modules/models/user'
passport = require 'local_modules/passport'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.get '/',
  resourceConverter.get()
  resourceConverter.send

router.put '/:_id/acknowledge',
  (req, res, next) ->
    notification = req.body
    notification.acknowledged = true
    next()
  resourceConverter.put('_id')
  resourceConverter.send
