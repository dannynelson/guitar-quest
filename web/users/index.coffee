Promise = require 'bluebird'
User = require 'local_modules/models/user'
passport = require 'local_modules/passport'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.post '/register', (req, res, next) ->
  # FIXME why cant this be promisified??
  User.register new User({ email: req.body.email }), req.body.password, (err, user) ->
    Promise.try ->
      throw err if err
    .then ->
      resourceConverter.createResourceFromModel(user, {req, res, next})
    .then (resource) ->
      res.status(201)
      res.send resource
    .then null, (err) ->
      next(err)

router.post '/login',
  passport.authenticate('local')
  (req, res, next) ->
    resourceConverter.createResourceFromModel(req.user, {req, res, next}).then (resource) ->
      res.status(200).send(resource)
    .then null, (err) ->
      next(err)

router.post '/logout', (req, res) ->
  req.logout()
  res.status(200).send('Logout successful')

router.post '/assert_logged_in', (req, res, next) ->
  if not req.user?
    res.status(401).send {message: 'Not Logged In'}
  else
    resourceConverter.createResourceFromModel(req.user, {req, res, next}).then (resource) ->
      res.status(200).send resource
    .then null, (err) ->
      next(err)
