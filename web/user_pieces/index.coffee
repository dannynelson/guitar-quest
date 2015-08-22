Promise = require 'bluebird'
UserPiece = require 'local_modules/models/user_piece'
passport = require 'local_modules/passport'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.get '/:_id',
  (req, res, next) -> # create default if doesnt exist
    UserPiece.findById(req.params._id).then (userPiece) ->
      if not userPiece?
        return res.json
          _id: req.params._id
          userId: req.user._id
          status: 'unfinished'
      else
        next()
  resourceConverter.get('_id')
  resourceConverter.send

router.put '/:_id',
  (req, res, next) ->
    console.log 'PUTTING'
    next()
  resourceConverter.put('_id')
  resourceConverter.send
