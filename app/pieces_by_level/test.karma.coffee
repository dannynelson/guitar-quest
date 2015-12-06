require 'goodeggs-ops-ui-test-helpers/karma_integration'
opsSites = require 'goodeggs-ops-sites'
opsInventoryApiUrl = opsSites.getUrl('opsInventoryApi', 'test')

describe 'inventory UI', ->

  beforeEach ->
    [@$el, @scope, @$provide] = @loadAppOnPage()
    [@$state, @$httpBackend] = @getFromInjector(['$state', '$httpBackend'])
    @stubTokenIdentifier(true)

  describe 'environment warning', ->
    beforeEach ->
      @$httpBackend
        .whenGET("#{opsInventoryApiUrl}/v1/lots?foodhubSlug=sfbay")
        .respond []

    describe 'in production', ->
      beforeEach ->
        @$provide.constant 'settings',
          env: 'production'
          appInstance: 'production'
        @$state.go 'inventory.lots', {foodhubSlug: 'sfbay'}
        @$httpBackend.flush()
        @scope.$digest()

      it 'is not visible', ->
        expect(@$el.find('.environment-warning')).not.to.be.visible

    describe 'in development', ->
      beforeEach ->
        @$provide.constant 'settings',
          env: 'development'
          appInstance: 'localhost'
        @$state.go 'inventory.lots', {foodhubSlug: 'sfbay'}
        @$httpBackend.flush()
        @scope.$digest()

      it 'is visible', ->
        expect(@$el.find('.environment-warning')).to.be.visible

