import {expect} from 'chai'
var pieceFactory = require('local_modules/models/piece/factory.js')
import piecesReducer from './index'
import * as piecesActions from './index'
import configureMockStore from 'redux-mock-store'
import nock from 'nock'
import thunk from 'redux-thunk'

const middlewares = [ thunk ]
const mockStore = configureMockStore(middlewares)

describe('pieces duck', () => {
  describe('reducer', () => {
    it('handles pieces/QUERY_LEVEL_REQUEST', () => {
      const ACTION = {
        type: 'pieces/QUERY_LEVEL_REQUEST'
      }
      const state = piecesReducer(null, ACTION)
      expect(state).to.have.property('isFetching', true)
    })

    it('handles pieces/QUERY_LEVEL_SUCCESS', () => {
      const PIECES = [pieceFactory.create(), pieceFactory.create()]
      const ACTION = {
        type: 'pieces/QUERY_LEVEL_SUCCESS',
        payload: {pieces: PIECES}
      }
      const INITIAL_STATE = {
        isFetching: true,
        error: null,
        piecesById: {}
      }
      const state = piecesReducer(INITIAL_STATE, ACTION)
      expect(state).to.deep.equal({
        isFetching: false,
        error: null,
        piecesById: {
          [PIECES[0]._id]: PIECES[0],
          [PIECES[1]._id]: PIECES[1]
        }
      })
    })

    it('handles pieces/QUERY_LEVEL_FAILURE', () => {
      const PIECES = [pieceFactory.create(), pieceFactory.create()]
      const ACTION = {
        type: 'pieces/QUERY_LEVEL_FAILURE',
        payload: 'Internal server error',
        error: true
      }
      const INITIAL_STATE = {
        isFetching: true,
        error: null,
        piecesById: {}
      }
      const state = piecesReducer(INITIAL_STATE, ACTION)
      expect(state).to.deep.equal({
        isFetching: false,
        error: 'Internal server error',
        piecesById: {}
      })
    })
  })

  describe('actions', () => {
    afterEach(() => {
      nock.cleanAll()
    })

    describe('loadLevelPieces', () => {
      it('handles successful request', function (done) {
        const piece = pieceFactory.create()
        let scope = nock('http://127.0.0.1:8075')
          .defaultReplyHeaders({
            'Content-Type': 'application/json'
          })
          .get('/pieces')
          .query({level: 1})
          .reply(200, [piece])

        const expectedActions = [
          { type: 'pieces/QUERY_LEVEL_REQUEST', payload: {} },
          { type: 'pieces/QUERY_LEVEL_SUCCESS', payload: {pieces: [piece]} }
        ]
        const store = mockStore({}, expectedActions, done)
        store.dispatch(piecesActions.loadLevelPieces(1))
        expect(scope.isDone()).to.equal(true)
      })
    })
  })
})
