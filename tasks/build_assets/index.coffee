###
Build assets of an angular app
- angular source code
- styles
- other static assets

@param {glob pattern(s)} options.staticFiles = any static files that you want served publicly.
- Could be thirdparty CSS files, PDFs, images, etc.
###

module.exports = (gulp, options={}) ->

  gutil = require 'gulp-util'
  runSequence = require('run-sequence').use(gulp)
  require('./browserify')(gulp)
  require('./styles')(gulp)
  require('./copy')(gulp, options)
  require('./compress')(gulp)
  require('./version')(gulp)
  # require('./rollbar_sourcemaps')(gulp)

  gulp.task 'build_assets', (done) ->
    sequence = [
      ['assets:browserify', 'assets:styles', 'assets:copy']
    ]

    if gutil.env.prod
      sequence.push 'assets:version'
      sequence.push 'assets:compress'
      # sequence.push 'assets:rollbar_sourcemaps'

    runSequence sequence..., (args...) ->
      if gutil.env.watch is false
        # this is a hack, the task hangs otherwise
        process.exit(0)

      done(args...)
