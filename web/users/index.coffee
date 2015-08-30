Promise = require 'bluebird'
User = require 'local_modules/models/user'
passport = require 'local_modules/passport'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.get '/',
  resourceConverter.get()
  resourceConverter.send

router.put '/:_id',
  resourceConverter.put('_id')
  resourceConverter.send

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

router.post '/change_password', (req, res, next) ->
  {oldPassword, newPassword} = req.body
  user = req.user
  # FIXME this can't be promisified -- Unhandled rejection TypeError: Object #<Object> has no method 'get'
  # this is changed somehow?
  user.authenticate oldPassword, (err) ->
    return next(err) if err
    user.setPassword newPassword, (err, user) ->
      return next(err) if err
      user.save().then =>
        resourceConverter.createResourceFromModel(user, {req, res, next})
      .then (resource) =>
        return res.status(200).send resource

router.post '/assert_logged_in', (req, res, next) ->
  if not req.user?
    res.status(401).send {message: 'Not Logged In'}
  else
    resourceConverter.createResourceFromModel(req.user, {req, res, next}).then (resource) ->
      res.status(200).send resource
    .then null, (err) ->
      next(err)
