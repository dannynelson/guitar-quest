###
Entry point for web process
###

require 'local_modules/boot'

onceUpon = require 'once-upon'
server = require './server'

server.start (err) ->
  if err then console.error("Failed to start server", err)
  onceUpon 'SIGINT SIGTERM', process, ->
    server.stop (err) ->
      if err then console.error("Failed to stop server", err)
