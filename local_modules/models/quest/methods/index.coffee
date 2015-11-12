Promise = require 'bluebird'
_ = require 'lodash'
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

  schema.static 'createRandomQuest', ({user}) ->
    Quest = @
    Quest.create questHelpers.generateRandomQuest({user})

  schema.static 'createQuest', (type, {user}) ->
    Quest = @
    Quest.create questHelpers.generateQuest(type, {user})

  schema.static 'createRandomQuest', ({user}) ->
    Quest = @
    Quest.create questHelpers.generateRandomQuest({user})

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
