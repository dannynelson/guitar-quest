Promise = require 'bluebird'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
User = require 'local_modules/models/user'
passport = require 'local_modules/passport'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.get '/',
  resourceConverter.get()
  resourceConverter.send

router.get '/:_id',
  resourceConverter.get('_id')
  resourceConverter.send

router.post '/',
  resourceConverter.post()
  resourceConverter.send

router.put '/:_id',
  resourceConverter.put('_id')
  resourceConverter.send
