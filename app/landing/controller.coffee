_ = require 'lodash'

module.exports = ngInject ->
  @settings = window.settings
  return @ # http://stackoverflow.com/challengeions/28953289/using-controller-as-with-the-ui-router-isnt-working-as-expected
