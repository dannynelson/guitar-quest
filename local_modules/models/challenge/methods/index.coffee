Promise = require 'bluebird'
_ = require 'lodash'
settings = require 'local_modules/settings'
sendgrid = require 'local_modules/sendgrid'
Piece = require 'local_modules/models/piece'
UserPiece = require 'local_modules/models/user_piece'
pieceEnums = require 'local_modules/models/piece/enums'
challengeHelpers = require 'local_modules/models/challenge/helpers'

selectRandomChallengeLevel = (level) ->
  Math.ceil(Math.random() * level)

module.exports = (schema) ->
  schema.static 'createInitialChallenges', ({user}) ->
    Challenge = @
    Challenge.create challengeHelpers.generateInitialChallenges({user})

  schema.static 'createChallenge', (type, {user}) ->
    Challenge = @
    Challenge.create challengeHelpers.generateChallenge(type, {user})

  schema.static 'createRandomChallenge', ({user, sendEmail}={}) ->
    sendEmail ?= false
    Challenge = @
    Challenge.find({completed: {$ne: true}}).distinct('type').exec()
    .then (existingChallengeTypes) ->
      Challenge.create challengeHelpers.generateRandomChallenge({user, excludeChallengeTypes: existingChallengeTypes})
    .then (challenge) ->
      if sendEmail
        sendgrid.send
          to: user.email
          from: settings.guitarQuestEmail
          subject: 'New GuitarQuest challenge!'
          html: "
            Hello,<br><br>
            You just received a new GuitarQuest challenge, <strong>#{challengeHelpers.getTitle(challenge)}</strong>! Log into to GuitarQuest to learn more:
            #{settings.server.url}/#/challenges<br><br>
            Thanks,<br>
            The GuitarQuest Team
          "
        , (err) ->
          console.log err if err?
      return challenge

  schema.static 'progressMatchingChallenges', (userId, {userPiece}) ->
    Piece = require 'local_modules/models/piece'
    User = require 'local_modules/models/user'

    Challenge = @
    Promise.all([
      Challenge.find({userId: userId, completed: {$ne: true}})
      Piece.findById(userPiece.pieceId)
      User.findById(userId)
    ]).then ([challenges, piece, user]) ->
      Promise.each challenges, (challenge) =>
        return unless challengeHelpers.matchesConditions(challenge, {piece, userPiece, user})
        challenge.piecesCompleted ?= []
        challenge.piecesCompleted = _(challenge.piecesCompleted.concat(userPiece.pieceId)).invoke('toString').uniq().value()
        challenge.save()
