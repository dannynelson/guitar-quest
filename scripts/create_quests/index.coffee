Promise = require 'bluebird'
database = require 'local_modules/database'
Quest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
require 'mongoose-querystream-worker'

database.connect ->
  createQuest = (user, done) ->
    Quest.count({userId: user._id.toString(), completed: {$ne: true}}).then (activeQuestCount) ->
      if activeQuestCount < 3
        return Quest.createRandomQuest({user})
    .then ->
      done()
    .then null, done

  User.find().stream().concurrency(10).work createQuest, (err) ->
    console.log {err}
    database.disconnect()

