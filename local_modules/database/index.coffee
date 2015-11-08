async = require 'async'
Promise = require 'bluebird'
_ = require 'lodash'
mongoose = require 'mongoose'
mongoose.Promise = Promise # make mongoose use bluebird promises
settings = require 'local_modules/settings'
connectionManager = require('mongoose-connection-manager')(mongoose)

mongoSettings = _.clone settings.mongo
dbName = mongoSettings.name
delete mongoSettings.name


###
base mongodb instance for apps.
###
module.exports = db =
  connect: (callback) ->
    connectionManager.connect (err) -> callback?(err)

  disconnect: (callback) ->
    connectionManager.disconnect callback

  # completely clear out the database (for tests!)
  reset: (callback) ->
    if settings.env isnt 'test'
      return callback new Error 'Only available during testing'

    # removing everything in the collection preserves the indexes (rather than dropping the db)
    async.waterfall [
      (next) ->
        connectionManager.get(dbName).db.collections next
      (collections, next) ->
        async.forEach collections, (collection, nextCollection) ->
          unless collection and collection.collectionName.match /system/
            collection.remove (err) -> nextCollection err
          else
            nextCollection()
        , next
    ], (err) -> callback err

db.mongooseConnection = connectionManager.create dbName, mongoSettings
