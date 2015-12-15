module.exports =

  development:
    server:
      forceSSL: false
    log:
      pretty: true

  test:
    log:
      level: 'warn'
      pretty: true
    auth:      # TODO - used anywhere?
      name: 'Test User'
      email: 'test@guitarquest.com'
    server:
      port: 8076
    mongo:
      url: 'mongodb://localhost:27017/guitar_quest_test'

  production:
    appInstance: 'production'
    server:
      bind: '0.0.0.0'
