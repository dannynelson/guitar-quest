require 'goodeggs-ops-api-test-helpers/server'
{disableOutgoingEvents} = require 'local_modules/test_helpers'

geomoment = require 'geomoment'
Promise = require 'bluebird'
_ = require 'lodash'
{ObjectId} = require('mongoose').Types

database = require 'local_modules/database'

InventoryLot = require '../index'
inventoryLotFactory = require '../factory'

describe 'InventoryLot virtuals', ->
  disableOutgoingEvents()

  beforeEach 'reset db', database.reset

  describe '`auditLogDiffs`', ->

    beforeEach ->
      geomoment.stubTime geomoment.pacific('2015-06-01 12:00').toDate()

    afterEach ->
      geomoment.restoreTime()

    beforeEach ->
      inventoryLotFactory.createAndSave
        quantityReceived: 500
        receivedDate: geomoment.pacific('2015-06-01 09:30').toDate()
        expirationDay: '2015-07-01'
        'catalogProduct.customerRequiredLeadTime': 5
        pieces: [ {state: 'received', quantity: 500} ]
        updatedBy: 'test.user1@goodeggs.com'
      .then (@lot) =>
        @diffs = @lot.get('auditLogDiffs')

    given 'initial', ->
      it 'log has 1 diff', ->
        expect(@diffs).to.have.length 1

      it 'diff shows lot creation', ->
        expect(_.last @diffs).to.deep.equal
          type: 'created'
          changed:
            state: {from: null, to: 'received'}
          quantity: 500
          updatedBy: 'test.user1@goodeggs.com'
          updatedAt: @lot.get('updatedAt')
          updatedNotes: ''

    given 'move with location added', ->
      beforeEach ->
        @lot.move 100,
          {state: 'received', marketProduct: {_id: null}, location: null},
          {state: 'stowed', location: 'B-1'},
          {updatedBy: 'test.user2@goodeggs.com', updatedNotes: 'storage'}
        @lot.save().then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')

      it 'diff shows move', ->
        expect(@diffs).to.have.length 2
        expect(_.last @diffs).to.deep.equal
          type: 'moved'
          changed:
            state: {from: 'received', to: 'stowed'}
            location: {from: null, to: 'B-1'}
          quantity: 100
          updatedBy: 'test.user2@goodeggs.com'
          updatedNotes: 'storage'
          updatedAt: @lot.get('updatedAt')

    given 'split', ->
      beforeEach 'split', ->
        @lot.split
          quantity: 100
          newExpirationDay: '2014-11-11'
          piece: {state: 'received', marketProduct: {_id: null}, location: null}
          updatedBy: 'test@goodeggs.com'
          updatedNotes: 'messed up at receiving'
        .then ([@oldLot, @newLot]) =>

      it 'diff shows split', ->
        expect(@oldLot.get('auditLogDiffs')).to.have.length 2
        clean = (mongooseModel) -> JSON.parse JSON.stringify mongooseModel
        expect(_.last clean @oldLot.get('auditLogDiffs')).to.deep.equal
          type: 'split'
          quantity: 100 # meaning 100 split off from this lot
          changed:
            splitFromLot: {from: null, to: @newLot._id.toString()}
          updatedBy: 'test@goodeggs.com'
          updatedNotes: 'messed up at receiving'
          updatedAt: @lot.get('updatedAt').toISOString()

        expect(@newLot.get('auditLogDiffs')).to.have.length 2
        expect(_.last clean @newLot.get('auditLogDiffs')).to.deep.equal
          type: 'split'
          quantity: 400 # meaning 400 split off from this lot
          changed:
            splitFromLot: {from: null, to: @oldLot._id.toString()}
          updatedBy: 'test@goodeggs.com'
          updatedNotes: 'messed up at receiving'
          updatedAt: @lot.get('updatedAt').toISOString()

        # make sure newly created lot history has correct quantity
        expect(_.first clean @newLot.get('auditLogDiffs')).to.deep.equal
          type: 'created'
          quantity: 500 # meaning 400 split off from this lot
          changed:
            state: {from: null, to: 'received'}
          updatedBy: 'test.user1@goodeggs.com'
          updatedNotes: ''
          updatedAt: @lot.get('updatedAt').toISOString()

    given 'move with location and marketProduct added', ->
      beforeEach ->
        @product = {_id: (new ObjectId).toString(), name: '1lb bag of Apples'}
        @lot.move 100,
          {state: 'received', marketProduct: null, location: null},
          {state: 'stowed', location: 'B-1', marketProduct: @product},
          {updatedBy: 'produce.bagger@goodeggs.com', updatedNotes: 'bagged'}
        @lot.save().then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')

      it 'diff shows move', ->
        expect(@diffs).to.have.length 2
        expect(_.last @diffs).to.deep.equal
          type: 'moved'
          changed:
            state: {from: 'received', to: 'stowed'}
            location: {from: null, to: 'B-1'}
            marketProduct: {from: null, to: @product}
          quantity: 100
          updatedBy: 'produce.bagger@goodeggs.com'
          updatedNotes: 'bagged'
          updatedAt: @lot.get('updatedAt')


    given 'metadata field `expirationDay` changed', ->
      beforeEach ->
        @lot.set 'expirationDay', '2015-06-20'
        @lot.set 'updatedBy', 'quality.checker@goodeggs.com'
        @lot.set 'updatedNotes', 'Starting to look funky'
        @lot.save().then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')

      it 'diff shows change', ->
        expect(_.last @diffs).to.deep.equal
          type: 'metadata'
          changed:
            expirationDay: {from: '2015-07-01', to: '2015-06-20'}
          updatedBy: 'quality.checker@goodeggs.com'
          updatedNotes: 'Starting to look funky'
          updatedAt: @lot.get('updatedAt')

        # shows diff for auto changed purge day too
        expect(@diffs[@diffs.length - 2]).to.deep.equal
          type: 'metadata'
          changed:
            purgeDay: {from: '2015-06-26', to: '2015-06-15'}
          updatedBy: 'quality.checker@goodeggs.com'
          updatedNotes: 'Starting to look funky'
          updatedAt: @lot.get('updatedAt')


    given 'metadata field `receivedDate` changed', ->
      beforeEach ->
        @lot.set 'receivedDate', geomoment.pacific('2015-06-01 11:30').toDate()
        @lot.set 'updatedBy', 'eng@goodeggs.com'
        @lot.save().then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')

      it 'diff shows change', ->
        expect(_.last @diffs).to.have.property 'type', 'metadata'
        expect(_.last @diffs).to.have.deep.property 'changed.receivedDate.to'
        expect(_.last(@diffs).changed.receivedDate.to.toString()).to.equal '2015-06-01T18:30:00.000Z'


    given.skip 'metadata field `quantityReceived` changed (corrected)', ->
      # TBD - pieces quantities need to change to match ...?

    # TODO: fix this, or only change one thing at a time in migrations?
    given.skip 'multiple changes at once', ->
      # (this can't currently happen thru the UI, but can via other code paths, or a migration.)
      beforeEach ->
        @lot.move 100,
          {state: 'received', marketProduct: null, location: null},
          {state: 'stowed', location: 'B-1'}
        # (not saving yet)

        @lot.set 'expirationDay', '2015-06-20'     # changed + auto updates purge day
        @lot.set 'updatedBy', 'chaos.monkey@goodeggs.com'
        @lot.set 'updatedNotes', 'Weird migration'

        # save all at once
        @lot.save().then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')

      it 'splits into multiple diffs', ->
        expect(@diffs).to.have.length 4   # creation + 3 (move, expDay, purgeDay)

        expect(@diffs[0]).to.have.property 'type', 'created'

        # (order of diffs is arbitrary, but should be deterministic.)

        expect(@diffs[1]).to.deep.equal
          type: 'metadata'
          changed:
            purgeDay: {from: null, to: '2015-06-15'} # auto updated by hook
          updatedBy: 'chaos.monkey@goodeggs.com'
          updatedNotes: 'Weird migration'
          updatedAt: @lot.get('updatedAt')

        expect(@diffs[2]).to.deep.equal
          type: 'metadata'
          changed:
            expirationDay: {from: '2015-07-01', to: '2015-06-20'}
          updatedBy: 'chaos.monkey@goodeggs.com'
          updatedNotes: 'Weird migration'
          updatedAt: @lot.get('updatedAt')

        expect(@diffs[3]).to.deep.equal
          type: 'moved'
          changed:
            state: {from: 'received', to: 'stowed'}
            location: {from: null, to: 'B-1'}
          quantity: 100
          updatedBy: 'chaos.monkey@goodeggs.com'
          updatedNotes: 'Weird migration'
          updatedAt: @lot.get('updatedAt')

    given.skip 'with catalogProduct.name changed', ->
      # ??

    given 'added (during cycle count)', ->
      # for some reason, this needs to be duplicated here, otherwise we get a "VersionError: No matching document found."
      beforeEach ->
        inventoryLotFactory.createAndSave
          quantityReceived: 500
          receivedDate: geomoment.pacific('2015-06-01 09:30').toDate()
          expirationDay: '2015-07-01'
          'catalogProduct.customerRequiredLeadTime': 5
          pieces: [ {state: 'stowed', location: 'D1.5', quantity: 300} ]
          updatedBy: 'test.user1@goodeggs.com'
        .then (@lot) =>

      it 'shows quantity added to existing pieces', ->
        @lot.addQuantity
          quantity: 2
          location: 'D1.5'
          updatedNotes: 'cycle count'
          updatedBy: 'test@goodeggs.com'
        .then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')
          expect(@diffs).to.have.length 2
          expect(_.last @diffs).to.deep.equal
            type: 'added'
            changed:
              state: {from: 'stowed', to: 'stowed'}
              location: {from: 'D1.5', to: 'D1.5'}
              marketProduct: {from: null, to: null}
            quantity: 2
            updatedBy: 'test@goodeggs.com'
            updatedNotes: 'cycle count'
            updatedAt: @lot.get('updatedAt')

      it 'shows quantity added by creating new pieces', ->
        @lot.addQuantity
          quantity: 6
          location: 'D5.1'
          updatedNotes: 'cycle count'
          updatedBy: 'test@goodeggs.com'
        .then (@lot) =>
          @diffs = @lot.get('auditLogDiffs')
          expect(@diffs).to.have.length 2
          expect(_.last @diffs).to.deep.equal
            type: 'added'
            changed:
              state: {from: null, to: 'stowed'}
              location: {from: null, to: 'D5.1'}
              marketProduct: {from: null, to: null}
            quantity: 6
            updatedBy: 'test@goodeggs.com'
            updatedNotes: 'cycle count'
            updatedAt: @lot.get('updatedAt')

    given 'piece counted, but nothing else changed', ->
      beforeEach ->
        @lot.pieces[0].countedAt = geomoment().toDate()
        @lot.updatedBy = 'test@goodeggs.com'
        @lot.save().then (@lot) =>

      it 'ignores the change (and does not think the change was a "move")', ->
        @diffs = @lot.get('auditLogDiffs')
        expect(@diffs).to.have.length 1 # does not create a new diff

