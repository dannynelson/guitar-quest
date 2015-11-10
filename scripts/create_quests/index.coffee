database = require 'local_modules/database'
Quest = require 'local_modules/models/quest'
User = require 'local_modules/models/user'
require 'mongoose-querystream-worker'

database.connect ->
  createQuest = (user, done) ->
    console.log 'creating quest'
    Quest.generateRandomQuest(user).then ->
      done()
    .then null, done

  User.find().stream().concurrency(10).work createQuest, (err) ->
    console.log {err}
    database.disconnect()

