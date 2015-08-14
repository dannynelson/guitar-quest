
module.exports = (gulp) ->
  del = require 'del'
  vinylPaths = require 'vinyl-paths'
  rev = require 'gulp-rev'
  revReplace = require 'gulp-rev-replace'

  gulp.task 'assets:version', ->

    gulp.src(['build/public/**', '!build/public/{fonts,images}/', '!build/public/', '!build/public/**/*.map']) # don't publish sourcemaps
      .pipe(rev())
      .pipe(revReplace())
      .pipe(gulp.dest('build/public'))
      .pipe(rev.manifest())
      .pipe(gulp.dest('build'))
