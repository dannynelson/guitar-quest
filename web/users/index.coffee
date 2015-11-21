Promise = require 'bluebird'
settings = require 'local_modules/settings'
joi = require 'joi'
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
  if joi.validate(req.body.email, joi.string().email().required()).error
    return res.status(400).send 'Invalid email.'
  if req.body.password.length < 8
    return res.status(400).send 'Password must be at least 8 characters long.'
  # http://stackoverflow.com/questions/19605150/regex-for-password-must-be-contain-at-least-8-characters-least-1-number-and-bot
  if not /^(?=.*[A-Za-z])(?=.*\d)(?=.*[$@$!%*#?&])[A-Za-z\d$@$!%*#?&]{8,}$/.test(req.body.password)
    return res.status(400).send 'Password must contain at least 1 letter, 1 number, and 1 special character.'

  TempUser.create
    firstName: req.body.firstName
    lastName: req.body.lastName
    email: req.body.email
    password: req.body.password
  .then (tempUser) ->
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
    user = new User
      firstName: tempUser.firstName
      lastName: tempUser.lastName
      email: tempUser.email
    User.register user, tempUser.password, (err, user) ->
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
