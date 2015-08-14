
###
Gives you 5 tasks:
- assets:styles - all of the below
- watch:styles
- assets:stylus
- assets:images
- assets:fonts
###
path = require 'path'
gutil = require 'gulp-util'

ROOT_DIR = path.resolve __dirname, '../..'

STYLUS_SOURCES = [
  # "#{ROOT_DIR}/public/bootstrap.min.css"
  # "#{ROOT_DIR}/styles/variables.styl"
  # "#{ROOT_DIR}/styles/imports.styl"
  # "#{ROOT_DIR}/styles/*.styl"
]

module.exports = (gulp) ->

  DEST = 'build/public'
  STYLUS_SOURCES = STYLUS_SOURCES.concat [
    'local_modules/**/*.styl'
    'app/**/*.styl'
  ]

  gulp.task 'assets:stylus', ->
    # stylusConvertUrls = require('./stylus_convert_urls')(getPathFn)
    # bootstrapStylus = require('bootstrap-styl')()
    # stylusNodeModules = require('./stylus_node_modules')()
    nib = require('nib')()


    stylus = require 'gulp-stylus'
    concat = require 'gulp-concat'
    rename = require 'gulp-rename'
    gutil = require 'gulp-util'

    # TODO: Add source maps. Difficult because concat.styl is ephemeral.
    stylusStreamer = stylus
      compress: gutil.env.prod
      use: [
        nib
        # stylusConvertUrls,
        # bootstrapStylus,
        # stylusNodeModules
      ]

    gulp.src(STYLUS_SOURCES)
      .pipe(concat(path: 'concat.styl'))
      .pipe(stylusStreamer)
      .pipe(rename('app.css'))
      .pipe(gulp.dest(DEST))


  gulp.task 'watch:styles', ->
    if !gutil.env.prod
      gulp.watch STYLUS_SOURCES, ['assets:stylus']
      # gulp.watch IMAGE_SOURCES, ['assets:images']
      # gulp.watch FONT_SOURCES, ['assets:fonts']


  gulp.task 'assets:styles', [
    'assets:stylus'
    # 'assets:fonts'
    # 'assets:images'
    'watch:styles'
  ]
