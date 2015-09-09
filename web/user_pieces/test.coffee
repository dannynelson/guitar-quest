require 'local_modules/test_helpers/server'
Promise = require 'bluebird'
request = Promise.promisifyAll require('request')
serverUrl = require('local_modules/settings').server.url
UserPiece = require 'local_modules'

describe 'PUT /v1/user_pieces/:_id', ->
  before (done) -> @serverUp done
  after (done) -> @serverDown done

  it 'updates piece', ->
    request.putAsync "#{serverUrl}/user_pieces/"

