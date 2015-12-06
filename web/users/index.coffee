_ = require 'lodash'
Promise = require 'bluebird'
settings = require 'local_modules/settings'
joi = require 'joi'
joi.objectId = require('joi-objectid')(joi)
User = require 'local_modules/models/user'
Notification = require 'local_modules/models/notification'
TempUser = require 'local_modules/models/temp_user'
passport = require 'local_modules/passport'
stripe = require 'local_modules/stripe'
sendgrid = require 'local_modules/sendgrid'
resourceConverter = require './resource_converter'

module.exports = router = require('express').Router()

router.get '/card', (req, res, next) ->
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  return res.status(404).send('No credit card available') unless user.stripeId
  stripe.customers.retrieve(user.stripeId).then (customer) ->
    creditCardInfo = _.first(customer.sources.data)
    res.send(creditCardInfo)
  .then null, next

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
  if joi.validate(req.body.firstName, joi.string().min(1).required()).error
    return res.status(400).send 'invalid firstName'
  if joi.validate(req.body.lastName, joi.string().min(1).required()).error
    return res.status(400).send 'invalid lastName'
  if joi.validate(req.body.email, joi.string().email().required()).error
    return res.status(400).send 'invalid email'
  if joi.validate(req.body.password, joi.string().min(8).required()).error
    return res.status(400).send 'password must be at least 8 characters long'

  tempUser = new TempUser
    firstName: req.body.firstName
    lastName: req.body.lastName
    email: req.body.email
  TempUser.register tempUser, req.body.password, (err, tempUser) ->
    return next(err) if err?
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
    return res.status(201).send({})

router.post '/confirm/:tempUserId', (req, res, next) ->
  if joi.validate(req.params.tempUserId, joi.objectId().required()).error
    return res.status(400).send 'invalid tempUserId'
  TempUser
    .findById(req.params.tempUserId)
    .select('firstName lastName email hash salt') # explicitly need to select hash and salt
    .exec()
  .then (tempUser) ->
    return res.send({}) unless tempUser
    user = new User(tempUser)
    Promise.all [
      user.save()
      tempUser.remove()
    ]
  .tap ([user]) ->
    reqLoginPromised = Promise.promisify(req.login).bind(req)
    reqLoginPromised(user)
  .then ->
    resourceConverter.createResourceFromModel(req.user, {req, res, next})
  .then (resource) ->
    res.status(201).send(resource)
  .then null, next

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

router.post '/save_credit_card', (req, res, next) ->
  stripeCustomer = null
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  return res.status(400).send('stripe token required') unless req.body?.stripeToken?
  stripeToken = req.body.stripeToken
  stripe.customers.create
    source: stripeToken
    description: 'payinguser@example.com'
  .then (customer) ->
    stripeCustomer = customer
    user.stripeId = stripeCustomer.id
    user.save()
  .then ->
    creditCardInfo = _.first(stripeCustomer.sources.data)
    res.status(201).send(creditCardInfo)
  .then null, next

router.post '/subscribe', (req, res, next) ->
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  return res.status(400).send('Must specify a plan') unless req.body?.plan?
  return res.status(400).send('User does not have a credit card associated with account') unless req.user?.stripeId?
  stripe.customers.createSubscription(req.user.stripeId, {plan: req.body.plan})
  .then (subscription) ->
    user.roles.push 'professionalAccount'
    user.save()
  .then ->
    return res.status(200).send({})
  .then null, next

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

router.post '/mark_all_notifications_read', (req, res, next) ->
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  Notification.find({userId: user._id, isRead: {$ne: true}})
  .then (notifications) ->
    notifications.forEach (notification) ->
      notification.isRead = true
      notification.save()
  .then ->
    res.send(200, {})
  .then null, next

router.post '/assert_logged_in', (req, res, next) ->
  if not req.user?
    res.status(401).send {message: 'Not Logged In'}
  else
    resourceConverter.createResourceFromModel(req.user, {req, res, next}).then (resource) ->
      res.status(200).send resource
    .then null, (err) ->
      next(err)
