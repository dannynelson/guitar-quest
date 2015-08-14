module.exports = (gulp) ->
  uglify = require 'gulp-uglify'
  sourcemaps = require 'gulp-sourcemaps'

  gulp.task 'assets:compress', ->
    gulp.src('build/public/*.js')
      .pipe(sourcemaps.init({loadMaps: true}))
      .pipe(uglify())
      .pipe(sourcemaps.write('../sourcemaps'))
      .pipe(gulp.dest('build/public'))
