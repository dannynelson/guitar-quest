Promise = require 'bluebird'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
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

router.post '/:_id/submit_video',
  (req, res, next) ->
    if not req.user?
      return res.status(401).send('unauthorized')
    if joi.validate(req.params._id, joi.objectId().required()).error
      return res.status(400).send('invalid userPieceId')
    if joi.validate(req.body.pieceId, joi.objectId().required()).error
      return res.status(400).send('invalid pieceId')
    if joi.validate(req.body.submissionVideoURL, joi.string().required()).error
      return res.status(400).send('invalid submissionVideoURL')
    UserPiece.findById(req.params._id)
    .then (userPiece) =>
      userPiece ?= new UserPiece
        _id: req.params._id
        userId: req.user._id
        pieceId: req.body.pieceId
      userPiece.submitVideo
        submissionVideoURL: req.body.submissionVideoURL
        updatedBy: req.user._id.toString()
    .then (userPiece) =>
      req.query.$add = ['historyChanges'] # hack
      resourceConverter.createResourceFromModel(userPiece, {req, res, next})
    .then (userPieceResource) =>
      res.body = userPieceResource
      next()
  resourceConverter.send

router.post '/:_id/grade',
  (req, res, next) ->
    res.status(401).send('unauthorized') if not req.user?
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
