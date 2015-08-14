path = require 'path'
fs = require 'fs'
serveStatic = require 'serve-static'

module.exports = ({settings}) ->

  manifest = null

  if settings.env is 'production'
    get = (absPath) ->
      relPath = absPath[1..]
      if versionedPath = manifest?[relPath]
        versionedPath
      else
        absPath

    get.middleware = ->
      return serveStatic('./build/public', maxAge: '365d')

    get.reload = ->
      manifestText = fs.readFileSync path.resolve(process.cwd(), 'build/rev-manifest.json')
      manifest = JSON.parse manifestText

  else
    ## dev/test ##

    get = (absPath) ->
      absPath

    get.middleware = ->
      serveStatic('./build/public')

    get.reload = ->
      # stub

  return get
