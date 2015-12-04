Promise = require 'bluebird'
sendgrid = require 'local_modules/sendgrid'
settings = require 'local_modules/settings'
notificationHelpers = require 'local_modules/models/notification/helpers'

capitalize = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

module.exports = (schema) ->
  schema.static 'createNew', (type, params, {sendEmail}={}) ->
    sendEmail ?= false
    User = require 'local_modules/models/user'
    Notification = @

    Notification.create(notificationHelpers.generateNotification(type, params)).then (notification) ->
      if sendEmail is true
        return User.findById(notification.userId).then (user) ->
          description = notificationHelpers.getDescription({notification})
          link = notificationHelpers.getLink({notification, serverUrl: settings.server.url})
          sendgrid.send
            to: user.email
            from: settings.guitarQuestEmail
            subject: notificationHelpers.getTitle({notification})
            html: "#{description}.<br>#{link}"
      return notification
