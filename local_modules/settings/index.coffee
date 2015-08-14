_ = require 'lodash'
convict = require 'convict'
path = require 'path'

###
base convict settings.
can extend with app-specific settings.
returns POJO.
###
module.exports = do ->

  convictConfig = require('./config')
  settings = convict convictConfig
  envConfig = require('./defaults_per_env')[settings.get('env')] ? {}
  settings.load envConfig

  unless settings.get('server.url')?
    settings.set 'server.url', "http://localhost:#{settings.get('server.port')}"

  # Load the app version
  try
    version = require path.join(process.cwd(), 'version')
    settings.load {sha: version}
  catch err
    throw err unless err.code is 'MODULE_NOT_FOUND'

  settings.validate()

  return settings.root()
