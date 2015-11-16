Promise = require 'bluebird'
sendgrid = require 'local_modules/sendgrid'

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
            from: 'danny.edward.nelson@gmail.com'
            subject: notification.title
            html: "
              Hello,<br><br>
              #{notification.text}.<br><br>
              Log in to guitar quest to view more info.<br>
              https://www.guitarquest.com<br><br>
              Thanks,<br>
              GuitarQuest Team
            "
