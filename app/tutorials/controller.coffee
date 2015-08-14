_ = require 'lodash'

module.exports = ngInject ->
  @max = 100
  @dynamic = 20

  return @ # http://stackoverflow.com/questions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
