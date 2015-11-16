Promise = require 'bluebird'
sendgrid = require 'local_modules/sendgrid'
settings = require 'local_modules/settings'

module.exports = (schema) ->
  schema.static 'send', (notification, {sendEmail}={}) ->
    sendEmail ?= false
    User = require 'local_modules/models/user'
    notification.acknowledged = false
    Notification = @

    Notification.create(notification).then ->
      if sendEmail is true
        return User.findById(notification.userId).then (user) ->
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
