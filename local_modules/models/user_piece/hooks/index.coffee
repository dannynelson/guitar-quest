Promise = require 'bluebird'
level = require 'local_modules/level'
_ = require 'lodash'
geomoment = require 'geomoment'

module.exports = (schema) ->

  # if changing submissing url, notify that the piece needs to be graded
  schema.pre 'validate', (next) ->
    if @isModified('submissionVideoURL')
      @waitingToBeGraded = true
    next()

  # copy current data to history
  schema.pre 'validate', (next) ->
    if not @get('updatedBy')?
      next new Error "Must set updatedBy whenever userPiece is saved."
    next()

  # if piece grade changes, add experience
  schema.pre 'save', (next) ->
    User = require 'local_modules/models/user'
    Notification = require 'local_modules/models/notification'
    Piece = require 'local_modules/models/piece'

    userPiece = @
    return next() unless @isModified('grade')

    Promise.all([
      User.findById(@userId)
      Piece.findById(@pieceId)
    ]).then ([user, piece]) =>
      user.points += level.getPointsPerPiece(piece.level) * userPiece.grade
      user.level = level.calculateCurrentLevel(user.points)

      notification = new Notification
        userId: @userId
        category: 'piece'
        type: 'success'
        text: "Congratulations! Your video submission for #{piece.name} was accepted and you earned #{piece.points} points."
        acknowledged: false

      # save notification before user so that level up notifications come afterwards
      notification.save().then => user.save()
    .nodeify(next)

  # progress quests
  schema.pre 'save', (next) ->
    Quest = null
    Piece = null
    Promise.try =>
      Quest = require 'local_modules/models/quest'
      Piece = require 'local_modules/models/piece'
      Piece.findById(@pieceId)
    .then (piece) =>
      Quest.progressMatchingQuests @userId, {userPiece: @}
    .nodeify(next)

  # notify if piece was rejected
  # schema.pre 'save', (next) ->
  #   Piece = require 'local_modules/models/piece'
  #   Notification = require 'local_modules/models/notification'

  #   if @isModified('status') and @status is 'retry'
  #     Piece.findById(@pieceId).then (piece) =>
  #       notification = new Notification
  #         userId: @userId
  #         category: 'piece'
  #         type: 'info'
  #         text: "You received teacher feedback for \"#{piece.name}\". Please review and submit another video."
  #         acknowledged: false
  #       notification.save()
  #     .nodeify(next)
  #   else
  #     next()

  # copy current data to history
  schema.pre 'save', (next) ->
    @set 'updatedAt', geomoment.utc().toDate()
    # copy on write
    cloneAndClean = (mongooseModel) -> JSON.parse JSON.stringify mongooseModel # converts objectIds to strings
    snapshot = cloneAndClean _.omit(@toObject({virtuals: false}), ['_id', 'userId', 'pieceId'])
    @history.push snapshot

    # After copying `updatedNotes` and `splitFromLot`, to history, remove from doc itself.
    # It's important that we do this for any field that we do not want to accidentally save more than
    # once in the audit log:
    @set 'comment', undefined # set as empty string for default next time
    @set 'updatedBy', undefined
    # Note, we do not need to clear updatedAt b/c we know it will always be updated by mongoose timestamps
    next()

  return schema

