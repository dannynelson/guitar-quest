Promise = require 'bluebird'
database = require 'local_modules/database'
Challenge = require 'local_modules/models/challenge'
User = require 'local_modules/models/user'
require 'mongoose-querystream-worker'

database.connect ->
  createChallenge = (user, done) ->
    Challenge.count({userId: user._id.toString(), completed: {$ne: true}}).then (activeChallengeCount) ->
      if activeChallengeCount < 3
        return Challenge.createRandomChallenge({user})
    .then ->
      done()
    .then null, done

  User.find().stream().concurrency(10).work createChallenge, (err) ->
    console.log {err}
    database.disconnect()

