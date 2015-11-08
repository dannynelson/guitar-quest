Promise = require 'bluebird'
UserPiece = require 'local_modules/models/user_piece'
passport = require 'local_modules/passport'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.get '/',
  resourceConverter.get()
  resourceConverter.send

router.get '/:_id',
  resourceConverter.get('_id')
  resourceConverter.send

router.put '/:_id',
  resourceConverter.put('_id')
  resourceConverter.send

router.post '/:_id/grade',
  (req, res, next) ->
    UserPiece.findById(req.params._id).then (userPiece) =>
      grade = Number(req.query.grade)
      userPiece.gradePiece({grade: grade, updatedBy: req.user._id})
    .then (userPiece) =>
      req.query.$add = ['historyChanges'] # hack
      resourceConverter.createResourceFromModel(userPiece, {req, res, next})
    .then (userPieceResource) =>
      res.body = userPieceResource
      next()
  resourceConverter.send
