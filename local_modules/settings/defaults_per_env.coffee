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

  production:
    appInstance: 'production'
    server:
      bind: '0.0.0.0'
