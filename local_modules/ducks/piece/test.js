import {expect} from 'chai'
var pieceFactory = require('local_modules/models/piece/factory.js')
import objectIdString from 'objectid'
import settings from 'local_modules/settings'
import piecesReducer from './index'
import * as pieceActions from './index'
import configureMockStore from 'redux-mock-store'
import nock from 'nock'
import thunk from 'redux-thunk'
import fetch from 'isomorphic-fetch'
import Promise from 'bluebird'
fetch.Promise = Promise

const mockStore = configureMockStore([thunk])

describe('redux pieces', () => {
  describe('actions', () => {
    beforeEach(() => {
      this.api = nock(settings.server.url)
        .defaultReplyHeaders({
          'Content-Type': 'application/json'
        })
    })
    afterEach(() => {
      nock.cleanAll()
    })

    describe('.fetchForLevel()', () => {
      it('handles successful request', (done) => {
        const piece = pieceFactory.create()
        this.api.get('/pieces')
          .query({level: 1})
          .reply(200, [piece])

        const meta = {
          url: 'http://127.0.0.1:8075/pieces?level=1',
          config: {}
        }

        const expectedActions = [
          {
            type: pieceActions.FETCH_FOR_LEVEL_REQUEST,
            meta: meta
          },
          {
            type: pieceActions.FETCH_FOR_LEVEL_SUCCESS,
            payload: [piece],
            meta: meta
          }
        ]
        const store = mockStore({}, expectedActions, done)
        store.dispatch(pieceActions.fetchForLevel(1))
      })
    })

    describe('.fetchById()', () => {
      it('handles successful request', (done) => {
        const piece = pieceFactory.create()
        this.api.get('/pieces')
          .query({level: 1})
          .reply(200, [piece])
          .get('/pieces')
          .query({level: 1})
          .reply(200, [piece])

        const meta = {
          url: 'http://127.0.0.1:8075/pieces/',
          config: {}
        }

        const expectedActions = [
          {
            type: pieceActions.FETCH_FOR_LEVEL_REQUEST,
            meta: meta
          },
          {
            type: pieceActions.FETCH_FOR_LEVEL_SUCCESS,
            payload: [piece],
            meta: meta
          }
        ]
        const store = mockStore({}, expectedActions, done)
        store.dispatch(pieceActions.fetchForLevel(1))
      })
    })
  })
})
