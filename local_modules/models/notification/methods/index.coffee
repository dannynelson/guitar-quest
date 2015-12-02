Promise = require 'bluebird'
sendgrid = require 'local_modules/sendgrid'
settings = require 'local_modules/settings'
notificationHelpers = 'local_modules/notification/helpers'

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

module.exports = (schema) ->
  schema.static 'createNew', (type, params, {sendEmail}={}) ->
    sendEmail ?= false
    User = require 'local_modules/models/user'
    Notification = @

    Notification.create(notificationHelpers.generate(type, params)).then ->
      if sendEmail is true
        return User.findById(notification.userId).then (user) ->
          description = notificationHelpers.getDescription({description})
          link = notificationHelpers.getLink({description})
          sendgrid.send
            to: user.email
            from: settings.guitarQuestEmail
            subject: notificationHelpers.getTitle({notification})
            html: "
              Hello #{capitalize(user.firstName)},<br><br>
              #{description}.<br>
              #{link}<br><br>
              Thanks,<br>
              The GuitarQuest Team
            "
