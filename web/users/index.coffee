Promise = require 'bluebird'
settings = require 'local_modules/settings'
User = require 'local_modules/models/user'
TempUser = require 'local_modules/models/temp_user'
passport = require 'local_modules/passport'
sendgrid = require 'local_modules/sendgrid'
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

router.post '/register', (req, res, next) ->
  TempUser.create({email: req.body.email, password: req.body.password}).then (tempUser) ->
    sendgrid.send
      to: tempUser.email
      from: settings.guitarQuestEmail
      subject: 'Confirm GuitarQuest Email'
      html: "
        Hello,<br><br>
        Welcome to GuitarQuest! Click the link below to confirm your email.<br>
        #{settings.server.url}/#/confirm_email?id=#{tempUser._id}<br><br>
        Thanks,<br>
        The GuitarQuest Team
      "
    , (err) ->
      console.log err if err?
    res.status(201)
    res.send({})
  .then null, next

router.post '/confirm_email/:tempUserId', (req, res, next) ->
  TempUser.findById(req.params.tempUserId)
  .then (tempUser) ->
    return res.send({}) unless tempUser
    {email, password} = tempUser
    # FIXME why cant this be promisified??
    User.register new User({ email: tempUser.email }), tempUser.password, (err, user) ->
      Promise.try ->
        throw err if err
      .then ->
        tempUser.remove()
      .then ->
        resourceConverter.createResourceFromModel(user, {req, res, next})
      .then (resource) ->
        res.status(201)
        res.send({email, password}) # so that we can immediately log in
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
