_ = require 'lodash'
express = require 'express'
bodyParser = require 'body-parser'
session = require 'express-session'
MongoStore = require('connect-mongo')(session)
helmet = require 'helmet'
crashpad = require 'crashpad'
async = require 'async'
path = require 'path'
logger = require 'local_modules/logger'
database = require 'local_modules/database'
settings = require 'local_modules/settings'
passport = require 'local_modules/passport'
enforce = require 'express-sslify'

require './fixtures'

module.exports = app = express()

app.use(enforce.HTTPS({ trustProtoHeader: true }))

# app.use require('express-bunyan-logger')()
#
app.locals.assets = assets = require('local_modules/ui_assets')({settings})
app.use assets.middleware()

app.use require('cookie-parser')()

app.use bodyParser.urlencoded(extended: true)
app.use bodyParser.json()

# if contentSecurityPolicy
# cspOptions =
#   defaultSrc: ["'self'", 'data:']
#   styleSrc: ["'self'", 'maxcdn.bootstrapcdn.com', "'unsafe-inline'"]
#   fontSrc: ["'self'", 'maxcdn.bootstrapcdn.com', 'data:']
#   imgSrc: ["'self'", '*.guitarquest.com', '*.googleusercontent.com']
#   scriptSrc: ["'self'", "'unsafe-inline'", "'unsafe-eval'", '*.cloudfront.net']
#   # for XHRs
#   connectSrc: ["'self'", 'api.rollbar.com']
# _.forOwn contentSecurityPolicy, (value, key) ->
#   cspOptions[key] = _.union(cspOptions[key], value)
# app.use helmet.contentSecurityPolicy cspOptions

app.use helmet.hidePoweredBy()
app.use helmet.ieNoOpen()
app.use helmet.noSniff()
app.use helmet.xssFilter()
app.use helmet.frameguard()

# don't let the browser cache anything after this middleware
app.use helmet.noCache()

app.set 'view engine', 'jade'
app.set 'views', path.resolve(process.cwd(), 'web')

app.use session({secret: 'julian bream', store: new MongoStore({ url: settings.mongo.url })})

# passport
app.use passport.initialize()
app.use passport.session()

# Routes
app.use '/users', require './users'
app.use '/notifications', require './notifications'
app.use '/challenges', require './challenges'
app.use '/pieces', require './pieces'
app.use '/user_pieces', require './user_pieces'
app.use '/s3_policy', require './s3_policy'

# if options.serveLayoutAtRoot
clientSettingsWhitelist = _.union clientSettingsWhitelist, ['env', 'stripe.publishableKey', 'server.url', 'subscription.price']
sharedSettings = {}
for settingPath in clientSettingsWhitelist
  _.set(sharedSettings, settingPath, _.get(settings, settingPath))
app.get '/', (req, res, next) ->
  res.locals.sharedSettings = sharedSettings
  res.render 'layout'


# assume all other req are looking for static files; if they get here, they don't exist.
app.use (req, res, next) ->
  res.status(404).send 'File not found' unless res.headersSent

# app.use logger.middleware.error
app.use (err, req, res, next) ->
  logger.error err
  next()
app.use crashpad()

### other middlewares could hook here w/ sub-app/router ###

app.connect = (cb) ->
  async.parallel [
    # (next) ->
    #   stats.start next
    (next) ->
      if database? then database.connect next
      else next()
    (next) ->
      # if onConnect then onConnect next
      next()
  ], cb

app.disconnect = (cb) -> cb()


app.start = (cb) ->
  app.connect (err) ->
    return cb(err) if err?
    assets?.reload()
    server = app.listen settings.server.port, settings.server.bind
    server.once 'listening', ->
      logger.info "#{settings.name} is listening at #{server.address().address}:#{server.address().port} in #{settings.env} mode"
      cb()

app.stop = (cb) ->
  server?.close()
  app.disconnect cb

return app
