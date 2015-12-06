lodash = require 'lodash'

module.exports = (gulp) ->
  # Note: this repl implementation uses CoffeeScript's REPL which extends node's REPL
  # Start coffee REPL with some customization:
  #  Assign last eval to __ instead of _
  #  _ is global lodash
  #  If fibrous: true option is passed, eval each line in a fiber so you can use sync
  goodEggsRepl = (opts = {}) ->
    coffeeRepl = require 'coffee-script/lib/coffee-script/repl'
    opts.prompt = 'fibrous> ' if opts.fibrous
    repl = coffeeRepl.start(opts)

    # Monkey patch to put last value at __ and lodash at _
    evalWithoutLodash = repl.eval
    evalWithLodash = (input, context, filename, cb) ->
      context._ = lodash
      evalWithoutLodash input, context, filename, (err, result) ->
        return cb(err) if err?
        context.__ = result
        cb(null, result)
    repl.eval = evalWithLodash.bind(repl)

    # Monkey patch to wrap eval in a fiber
    if opts.fibrous
      fibrous = require 'fibrous'
      evalWithoutFibrous = repl.eval
      evalWithFibrous = fibrous (input, context, filename) ->
        evalWithoutFibrous.sync(input, context, filename)
      repl.eval = evalWithFibrous.bind(repl)

    repl

  gulp.task 'console', (cb) ->

    # (apps w/o mongodb should export `null` here)
    database = require "#{process.cwd()}/local_modules/database"

    require('fibrous').run ->
      database?.sync.connect()
      goodEggsRepl(fibrous: true).sync.on 'exit' # Pause this fiber in the connected state until the exit signal
      database?.sync.disconnect()
    , cb
