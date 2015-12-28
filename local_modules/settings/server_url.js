var SERVER_URL

try {
  SERVER_URL = window.settings
} catch (e) {
  var settings = require('local_modules/settings')
  SERVER_URL = settings.server.url
}

export default SERVER_URL
