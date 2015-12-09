###
Execute tests
- mocha - all tests ending in test.coffee
- karama - all tests ending in karma.coffee
- smoke - all tests ending in smoke.coffee
###

_ = require 'lodash'
glob = require 'glob'
Promise = require 'bluebird'

TEST_FILES = ['**/*test.coffee', '!node_modules/**']

mochaOptions = (opts) ->
  _.extend {}, {
      require: 'local_modules/boot'
      compilers: 'coffee:coffee-script/register'
      reporter: 'spec'
    }, opts

module.exports = (gulp) ->
  # note, smoke tests are intentionally excluded from default test task
  gulp.task 'test', (done) ->
    gutil = require 'gulp-util'
    runSequence = require('run-sequence').use(gulp)
    tasks = []
    globAsync = Promise.promisify glob

    # dynamically choose tests to run based on files that we find
    Promise.props({
      karmaFiles: globAsync('**/*karma.coffee', {ignore: 'node_modules/**'})
      mochaFiles: globAsync('**/*test.coffee', {ignore: 'node_modules/**'})
    }).then ({karmaFiles, mochaFiles}) ->
      # tasks.push 'test:karma' if karmaFiles.length
      tasks.push 'test:mocha' if mochaFiles.length
      runSequence tasks, (args...) ->
        if gutil.env.watch is false
          # this is a hack, the task hangs otherwise
          process.exit(0)
        done(args...)

    null # don't return the promise, otherwise gulp won't know to wait for the done callback

  gulp.task 'test:karma', (done) ->
    karma = require 'goodeggs-karma'
    gutil = require 'gulp-util'
    process.env.NODE_ENV = 'test'
    # run karma if we find *karma.coffee files
    karma.run
      singleRun: if gutil.env.watch then false else true
    , done

  gulp.task 'test:mocha', ->
    process.env.NODE_ENV = 'test'
    gutil = require 'gulp-util'
    mocha = require 'gulp-spawn-mocha'

    # add `--bail` flag to stop after first failure.
    bail = gutil.env.bail?

    # run single file
    if gutil.env.file?
      gulp
        .src(gutil.env.file, {read: false})
        .pipe(mocha mochaOptions {bail})

    # run all tests
    else
      gulp
        .src(TEST_FILES, {read: false, bail})
        .pipe(mocha mochaOptions {bail})

  gulp.task 'test:watch', ->
    gulp.watch TEST_FILES, ['test:mocha']

  # To run a suite against staging locally, run:
  # `SMOKE_TEST_ENV=staging gulp test:smoke`
  gulp.task 'test:smoke', (done) ->
    gutil = require 'gulp-util'
    mocha = require 'gulp-spawn-mocha'

    bail = gutil.env.bail?

    # run single file
    if gutil.env.file?
      gulp
        .src(gutil.env.file, read: false)
        .pipe(mocha mochaOptions {timeout: 120000, bail})

    # run all tests
    else
      gulp
        .src(['**/*smoke.coffee', '!node_modules/**'], read: false)
        .pipe(mocha mochaOptions {timeout: 120000, bail})

