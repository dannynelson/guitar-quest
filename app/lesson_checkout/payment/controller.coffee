_ = require 'lodash'

module.exports = ngInject ($state) ->
  @stateIncludes = (state) ->
    $state.includes(state)

