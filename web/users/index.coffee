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
normalizeEmail = require 'normalize-email'

module.exports = router = require('express').Router()

# assuming only one card allowed per user, retrieve the users card if available
router.get '/card', (req, res, next) ->
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  return res.status(404).send('No credit card available') unless user.stripeId
  stripe.customers.retrieve(user.stripeId).then (customer) ->
    card = _.first(customer.sources?.data)
    if card?
      res.send(card)
    else
      res.status(404).send('no card available for user')
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

  Promise.all([
    User.findOne({emailId: normalizeEmail(req.body.email)})
    TempUser.findOne({emailId: normalizeEmail(req.body.email)})
  ]).then ([user, tempUser]) ->
    if user?
      return res.status(400).send 'user already exists'
    Promise.try =>
      # remove previous register attempt first
      return tempUser.remove() if tempUser?
    .then =>
      tempUser = new TempUser
        firstName: req.body.firstName
        lastName: req.body.lastName
        email: req.body.email
        emailId: normalizeEmail(req.body.email)
      registerPromised = Promise.promisify(TempUser.register).bind(TempUser)
      return registerPromised(tempUser, req.body.password)
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
      return res.status(201).send({})
  .then null, next

router.post '/confirm/:tempUserId', (req, res, next) ->
  if joi.validate(req.params.tempUserId, joi.objectId().required()).error
    return res.status(400).send 'invalid tempUserId'
  TempUser
    .findById(req.params.tempUserId)
    .select('firstName lastName email emailId hash salt') # explicitly need to select hash and salt
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
  (req, res, next) ->
    if joi.validate(req.body.email, joi.string().email().required()).error
      return res.status(400).send 'invalid email'
    if joi.validate(req.body.password, joi.string().min(1).required()).error
      return res.status(400).send 'invalid password'
    req.body.emailId = normalizeEmail(req.body.email)
    next()
  passport.authenticate('local')
  (req, res, next) ->
    resourceConverter.createResourceFromModel(req.user, {req, res, next}).then (resource) ->
      res.status(200).send(resource)
    .then null, (err) ->
      next(err)

router.post '/logout', (req, res) ->
  req.logout()
  res.status(200).send('Logout successful')

router.post '/save_card', (req, res, next) ->
  stripeCustomer = null
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  return res.status(400).send('stripeToken required') unless req.body.stripeToken?
  Promise.try ->
    # if user exists, remove existing cards and add a new one
    if req.user.stripeId?
      return stripe.customers.listCards(req.user.stripeId).then (cards) ->
        Promise.map cards.data, (card) ->
          stripe.customers.deleteCard(req.user.stripeId, card.id)
      .then ->
        stripe.customers.createSource(req.user.stripeId, {source: req.body.stripeToken})
    # otherwise save new stripe user with provided source
    else
      return stripe.customers.create
        source: req.body.stripeToken
        description: req.user._id.toString()
      .then (customer) ->
        user.stripeId = customer.id
        user.save()
      .then ->
        card = _.first(stripeCustomer.sources.data)
  .then (card) ->
    return res.status(201).send(card)
  .then null, next

router.post '/subscribe', (req, res, next) ->
  user = req.user
  return res.status(401).send('unauthorized') unless req.user?
  return res.status(400).send('User does not have a credit card associated with account') unless req.user?.stripeId?
  stripe.customers.createSubscription(req.user.stripeId, {plan: settings.subscription.id})
  .then (subscription) ->
    user.roles.push 'subscriber'
    user.save()
  .then (user) ->
    resourceConverter.createResourceFromModel(user, {req, res, next})
  .then (resource) =>
    return res.status(200).send(resource)
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
