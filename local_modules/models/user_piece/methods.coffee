Promise = require 'bluebird'
_ = require 'lodash'
Promise = require 'bluebird'
sendgrid = require 'local_modules/sendgrid'
settings = require 'local_modules/settings'

module.exports = (schema) ->
  schema.method 'gradePiece', ({grade, comment, updatedBy}) ->
    Notification = require 'local_modules/models/notification'

    userPiece = @
    userPiece.updatedBy = updatedBy
    userPiece.grade = grade
    userPiece.comment = comment
    userPiece.waitingToBeGraded = false

    notification =
      userId: @userId
      category: 'piece'
      type: 'success'
      title: 'GuitarQuest video submission graded.'
      text: "
        Your video submission for #{piece.name} was graded
        #{userPiece.grade * 100}% and you earned #{level.getPointsPerPiece(piece.level) * userPiece.grade} points.
      "

    sendgrid.send
      to: user.email
      from: settings.guitarQuestEmail
      subject: notification.title
      html: "
        Hello,<br><br>
        #{notification.text}.<br><br>
        Log in to guitar challenge to view more info.<br>
        #{settings.server.url}<br><br>
        Thanks,<br>
        The GuitarQuest Team
      "

    Notification.send(notification)

    userPiece.save()

  return schema
