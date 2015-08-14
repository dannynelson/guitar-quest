
module.exports = (gulp) ->
  vinylPaths = require 'vinyl-paths'
  gutil = require 'gulp-util'
  {spawn} = require 'child_process'

  gulp.task 'assets:rollbar_sourcemaps', (done) ->
    uploadSourceMaps = (file, cb) ->
      settings = require "#{process.cwd()}/local_modules/settings"

      url = settings.server.url
      serverToken = settings.rollbar.serverAccessToken
      sha = settings.sha

      uploads = []
      fileName = file.replace(/.*\/([\w-]+\.js)\.map$/, '$1')
      minifiedJsUrl = "#{url}/#{fileName}"
      uploads.push {file, minifiedJsUrl}

      gutil.log "Uploading to Rollbar:\n  local source map: #{file}\n  public minified url: #{minifiedJsUrl}"

      output = ''
      curl = spawn 'curl', [
        'https://api.rollbar.com/api/1/sourcemap',
        '-F', "access_token=#{serverToken}",
        '-F', "version=#{sha}"
        '-F', "minified_url=#{minifiedJsUrl}"
        '-F', "source_map=@#{file}"
      ]

      curl.stdout.on 'data', (buf) -> output += buf.toString()

      curl.on 'close', (code) ->
        json = JSON.parse output
        if json.err isnt 0
          gutil.log "Error uploading to Rollbar:\n  local source map: #{file}\n  public minified url: #{minifiedJsUrl}\n  response: #{output}"
        # but we don't want this to fail the build
        cb()

    gulp.src('build/sourcemaps/*', read: false)
      .pipe(vinylPaths(uploadSourceMaps))

