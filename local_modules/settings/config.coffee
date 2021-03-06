# default convict config.

module.exports =
  env:
    doc: 'The applicaton environment.'
    format: ['production', 'development', 'test']
    default: 'development'
    env: 'NODE_ENV'

  smokeTestEnv:
    doc: 'The environment of where to run smoke tests'
    format: ['development', 'staging']
    default: 'development'
    env: 'SMOKE_TEST_ENV'

  appInstance:
    doc: 'The application instance.'
    format: '*'
    default: 'localhost'
    env: 'APP_INSTANCE'

  name:
    doc: 'The application name.'
    format: '*'
    default: 'guitar-quest'
    env: 'APP_NAME'

  mongo:
    name:
      doc: 'DB connection name'
      format: '*'
      default: 'database'
      env: 'MONGO_NAME'
    url:
      doc: 'Mongo URL'
      format: '*'
      default: 'mongodb://localhost:27017/guitar_quest_development'
      env: 'MONGO_URL'
    options:
      doc: 'Mongo Connection Options'
      format: '*'
      default: w: 'majority'
      env: 'MONGO_OPTIONS'

  log:
    level:
      doc: 'The log level for the default STDOUT stream.'
      format: ['trace', 'debug', 'info', 'warn', 'error', 'fatal']
      default: 'info'
      env: 'LOG_LEVEL'

    pretty:
      doc: 'Output logs for human readability.'
      format: Boolean
      default: false
      env: 'LOG_PRETTY'

  server:
    url:
      doc: 'The canonical base URL of this app'
      format: 'url'
      default: null
      env: 'SERVER_URL'

    bind:
      doc: 'The IP address to bind.'
      format: 'ipaddress'
      default: '127.0.0.1'
      env: 'SERVER_BIND'

    port:
      doc: 'The port to bind.'
      format: 'port'
      default: 8075
      env: 'PORT'

  sendgrid:
    apiKey:
      doc: 'API key for sendgrid'
      format: '*'
      default: null
      env: 'SENDGRID_API_KEY'

  guitarQuestEmail:
    doc: 'from email for all guitarquest emails'
    format: '*'
    default: 'admin@guitarquest.com'
    env: 'GUITAR_QUEST_EMAIL'

  myEmail:
    doc: 'My personal email for sending myself updates'
    format: '*'
    default: null
    env: 'MY_EMAIL'

  subscription:
    id:
      doc: 'monthly price for a PRO subscription'
      format: '*'
      default: 'professional'
      env: 'SUBSCRIPTION_ID'
    price:
      doc: 'monthly price for a PRO subscription'
      format: '*'
      default: 29
      env: 'SUBSCRIPTION_PRICE'

  stripe:
    secretKey:
      doc: 'API key for communicating with Stripe'
      format: '*'
      default: null
      env: 'STRIPE_SECRET_KEY'
    publishableKey:
      doc: 'API key for communicating with Stripe'
      format: '*'
      default: null
      env: 'STRIPE_PUBLISHABLE_KEY'
