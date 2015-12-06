Promise = require 'bluebird'
level = require 'local_modules/level'
_ = require 'lodash'
geomoment = require 'geomoment'

module.exports = (schema) ->

  # copy current data to history
  schema.pre 'validate', (next) ->
    if not @get('updatedBy')?
      next new Error "Must set updatedBy whenever userPiece is saved."
    next()

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
    @set 'comment', undefined
    @set 'updatedBy', undefined
    # Note, we do not need to clear updatedAt b/c we know it will always be updated by mongoose timestamps
    next()

  return schema

