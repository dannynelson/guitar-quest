import {expect} from 'chai'
import pieceFactory from 'local_modules/models/piece/factory'
import objectIdString from 'objectid'
import piecesReducer from './index'
import * as pieceActions from './index'
import configureMockStore from 'redux-mock-store'
import thunk from 'redux-thunk'
import Promise from 'bluebird'
import nock from 'nock'
import sinon from 'sinon'
import SERVER_URL from 'local_modules/settings/server_url'
fetch.Promise = Promise

const mockStore = configureMockStore([thunk])

describe('redux pieces', function() {
  describe('actions', function() {
    afterEach(function() {
      nock.cleanAll()
    })

    describe('.fetchForLevel()', function() {
      it('handles successful request', (done) => {
        const piece = pieceFactory.create()
        nock(SERVER_URL)
          .get('/pieces')
          .query({level: 1})
          .reply(200, [piece])

        const meta = {
          url: `${SERVER_URL}/pieces?level=1`,
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

    // describe('.fetchById()', function() {
    //   it('handles successful request', (done) => {
    //     const PIECE_ID = objectIdString()
    //     const piece = pieceFactory.create({_id: PIECE_ID})
    //     fetchMock.mock(`http://localhost:9876/pieces/${PIECE_ID}`, 'GET', {
    //       body: piece,
    //       headers: {'Content-Type': 'application/json'}
    //     })

    //     const meta = {
    //       url: `http://localhost:9876/pieces/${PIECE_ID}`,
    //       config: {}
    //     }

    //     const expectedActions = [
    //       {
    //         type: pieceActions.FETCH_BY_ID_REQUEST,
    //         meta: meta
    //       },
    //       {
    //         type: pieceActions.FETCH_BY_ID_SUCCESS,
    //         payload: [piece],
    //         meta: meta
    //       }
    //     ]
    //     const store = mockStore({}, expectedActions, done)
    //     store.dispatch(pieceActions.fetchById(PIECE_ID))
    //   })
    // })
  })
})
