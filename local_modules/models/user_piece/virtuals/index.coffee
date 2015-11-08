_ = require 'lodash'

module.exports = (schema) ->

  ###
  created a simplified version of history that only includes the changes
  ###
  schema.virtual('historyChanges').get ->
    diffs = []
    history = @get('history').toObject()  # clone

    _addDiff = (diff, snapshot) ->
      diffs.push _.extend {}, diff, _.pick(snapshot, ['updatedBy', 'updatedAt'])

    for snapshot, i in history
      previous = history[i-1] ? {}

       # graded
      changedGrade = previous.grade isnt snapshot.grade
      regradedWithoutChange = previous.waitingToBeGraded is true and snapshot.waitingToBeGraded isnt true
      if changedGrade or regradedWithoutChange
        _addDiff {grade: snapshot.grade}, snapshot

       # submitted
      else if snapshot.submissionVideoURL isnt previous.submissionVideoURL
        _addDiff {submissionVideoURL: snapshot.submissionVideoURL}, snapshot

      # commented
      else if snapshot.comment isnt previous.comment
        _addDiff {comment: snapshot.comment}, snapshot

    diffs

  return schema
