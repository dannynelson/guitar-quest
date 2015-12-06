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
    res.status(400).send('unauthorized') if not req.user?
    UserPiece.findById(req.params._id).then (userPiece) =>
      userPiece.gradePiece
        grade: req.body.grade
        comment: req.body.comment
        updatedBy: req.user._id.toString()
    .then (userPiece) =>
      req.query.$add = ['historyChanges'] # hack
      resourceConverter.createResourceFromModel(userPiece, {req, res, next})
    .then (userPieceResource) =>
      res.body = userPieceResource
      next()
  resourceConverter.send
