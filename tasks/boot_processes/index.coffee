###
Start up all processes defined in Procfile.
Mimics what heroku does, but in development.

process flow:
gulp -> nodemon -> {this} -> [web, workers...]
###

module.exports = (gulp) ->

  gulp.task 'boot_processes', ->
    path = require 'path'
    nodemon = require 'gulp-nodemon'

    nodemon
      script: path.resolve(__dirname, 'dev_boot.coffee')
      ext: 'js coffee'
      # watching everything
