Promise = require 'bluebird'
_ = require 'lodash'
settings = require 'local_modules/settings'
sendgrid = require 'local_modules/sendgrid'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
pieceEnums = require 'local_modules/models/piece/enums'
questHelpers = require 'local_modules/models/quest/helpers'

selectRandomQuestLevel = (level) ->
  Math.ceil(Math.random() * level)

module.exports = (schema) ->
  schema.static 'createInitialQuests', ({user}) ->
    Quest = @
    Quest.create questHelpers.generateInitialQuests({user})

  schema.static 'createQuest', (type, {user}) ->
    Quest = @
    Quest.create questHelpers.generateQuest(type, {user})

  schema.static 'createRandomQuest', ({user, sendEmail}={}) ->
    sendEmail ?= false
    Quest = @
    Quest.find({completed: {$ne: true}}).distinct('type').exec()
    .then (existingQuestTypes) ->
      Quest.create questHelpers.generateRandomQuest({user, excludeQuestTypes: existingQuestTypes})
    .then (quest) ->
      if sendEmail
        sendgrid.send
          to: user.email
          from: settings.guitarQuestEmail
          subject: 'New GuitarQuest challenge!'
          html: "
            Hello,<br><br>
            You just received a new GuitarQuest challenge, <strong>#{questHelpers.getTitle(quest)}</strong>! Log into to GuitarQuest to learn more:
            #{settings.server.url}/#/quests<br><br>
            Thanks,<br>
            The GuitarQuest Team
          "
        , (err) ->
          console.log err if err?
      return quest

  schema.static 'progressMatchingQuests', (userId, {userPiece}) ->
    Piece = require 'local_modules/models/piece'
    User = require 'local_modules/models/user'

    Quest = @
    Promise.all([
      Quest.find({userId: userId, completed: {$ne: true}})
      Piece.findById(userPiece.pieceId)
      User.findById(userId)
    ]).then ([quests, piece, user]) ->
      Promise.each quests, (quest) =>
        return unless questHelpers.matchesConditions(quest, {piece, userPiece, user})
        quest.piecesCompleted ?= []
        quest.piecesCompleted = _(quest.piecesCompleted.concat(userPiece.pieceId)).invoke('toString').uniq().value()
        quest.save()
