require './chai_config'

before ->
  @serverUp = (callback) ->
    # reload,
    # and wipe any server module from cache,
    # to allow for server pieces like middleware to be stubbed.
    # == NASTY! but what alternative? ==
    Object.keys(require.cache).filter (cachePath) ->
      if cachePath.indexOf("#{process.cwd()}/web") is 0 and !/node_modules/.test(cachePath)
        delete require.cache[cachePath]

    server = require "#{process.cwd()}/web/server"
    server.start callback

  @serverDown = (callback) ->
    server.stop callback
