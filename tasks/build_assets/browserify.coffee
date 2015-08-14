gutil = require 'gulp-util'
angularBrowserify = require 'goodeggs-angular-browserify/src'
async = require 'async'

module.exports = (gulp) ->
  externalModules = ['angular', 'angular-bootstrap', 'angular-resource', 'angular-ui-router']

  gulp.task 'assets:browserify', (done) ->
    async.parallel([

      angularBrowserify.run.bind(null, {
        src: 'app/index.coffee'
        dest: 'build/public'
        watch: if gutil.env.prod then false else true
        externalModules
      })

      angularBrowserify.run.bind(null, {
        src: 'app/index.coffee'
        entrypoint: false
        dest: 'build/public'
        exposeModules: externalModules
      })

    ], done)
