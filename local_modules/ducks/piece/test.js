import 'local_modules/test_helpers/chai_config'
import Promise from 'bluebird'
import nock from 'nock'
import sinon from 'sinon'
import pieceFactory from 'local_modules/models/piece/factory'
import settings from 'local_modules/settings'
import mockStore from 'local_modules/test_helpers/mock_store'
import objectIdString from 'objectid'
import piecesReducer from './index'
import * as pieceActions from './index'

const SERVER_URL = settings.server.url
const pieceInitialState = pieceActions.initialState
const initialState = {piece: pieceInitialState}

describe('redux piece', function() {
  describe('actions', function() {
    afterEach(function() {
      nock.cleanAll()
    })

    describe('.fetchForLevel()', function() {
      it('handles successful request', function() {
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
        const store = mockStore(initialState, expectedActions)
        return store.dispatch(pieceActions.fetchForLevel(1)).then(pieces => {
          expect(pieces).to.deep.equal([piece])
        })
      })

      it('returns cached pieces if already saved', function() {
        const piece = pieceFactory.create()
        const meta = {
          url: `${SERVER_URL}/pieces?level=1`,
          config: {}
        }

        const expectedActions = []
        const customInitialState = Object.assign({}, initialState, {
          piece: {
            pieceIdsByLevel: {
              [1]: [piece._id]
            },
            entities: {
              pieces: {
                [piece._id]: piece
              }
            }
          }
        })
        const store = mockStore(customInitialState, expectedActions)
        return store.dispatch(pieceActions.fetchForLevel(1)).then(pieces => {
          expect(pieces).to.have.length(1)
        })
      })
    })

    describe('.fetchById()', function() {
      it('handles successful request', function() {
        const PIECE_ID = objectIdString()
        const piece = pieceFactory.create({_id: PIECE_ID})
        nock(SERVER_URL)
          .get(`/pieces/${PIECE_ID}`)
          .reply(200, piece)

        const meta = {
          url: `${SERVER_URL}/pieces/${PIECE_ID}`,
          config: {}
        }

        const expectedActions = [
          {
            type: pieceActions.FETCH_BY_ID_REQUEST,
            meta: meta
          },
          {
            type: pieceActions.FETCH_BY_ID_SUCCESS,
            payload: piece,
            meta: meta
          }
        ]
        const store = mockStore(initialState, expectedActions)
        return store.dispatch(pieceActions.fetchById(PIECE_ID)).then(piece => {
          expect(piece).to.deep.equal(piece)
        })
      })

      it('returns cached piece if already fetched', function() {
        const PIECE_ID = objectIdString()
        const piece = pieceFactory.create({_id: PIECE_ID})

        const meta = {
          url: `${SERVER_URL}/pieces/${PIECE_ID}`,
          config: {}
        }

        const expectedActions = []
        const customInitialState = Object.assign({}, initialState, {
          piece: {
            entities: {
              pieces: {
                [piece._id]: piece
              }
            }
          }
        })
        const store = mockStore(customInitialState, expectedActions)
        return store.dispatch(pieceActions.fetchById(PIECE_ID)).then(piece => {
          expect(piece).to.deep.equal(piece)
        })
      })
    })
  })

  describe('reducer', () => {
    it('FETCH_FOR_LEVEL_REQUEST', () => {
      const action = {
        type: pieceActions.FETCH_FOR_LEVEL_REQUEST
      }
      const state = piecesReducer(pieceInitialState, action)
      expect(state).to.deep.equal({
        isFetching: true,
        error: null,
        pieceIdsByLevel: {},
        entities: {
          pieces: {}
        }
      })
    })

    it('FETCH_FOR_LEVEL_SUCCESS', () => {
      const piece = pieceFactory.create({level: 1})
      const action = {
        type: pieceActions.FETCH_FOR_LEVEL_SUCCESS,
        payload: [piece]
      }
      const state = piecesReducer(pieceInitialState, action)
      expect(state).to.deep.equal({
        isFetching: false,
        error: null,
        pieceIdsByLevel: {
          [1]: [piece._id]
        },
        entities: {
          pieces: {
            [piece._id]: piece
          }
        }
      })
    })

    it('FETCH_FOR_LEVEL_FAILURE', () => {
      const action = {
        type: pieceActions.FETCH_FOR_LEVEL_FAILURE,
        error: true,
        payload: new Error('internal server error')
      }
      const state = piecesReducer(pieceInitialState, action)
      expect(state).to.deep.equal({
        isFetching: false,
        error: 'internal server error',
        pieceIdsByLevel: {},
        entities: {
          pieces: {}
        }
      })
    })

    it('FETCH_BY_ID_REQUEST', () => {
      const action = {
        type: pieceActions.FETCH_BY_ID_REQUEST
      }
      const state = piecesReducer(pieceInitialState, action)
      expect(state).to.deep.equal({
        isFetching: true,
        error: null,
        pieceIdsByLevel: {},
        entities: {
          pieces: {}
        }
      })
    })

    it('FETCH_BY_ID_SUCCESS', () => {
      const piece = pieceFactory.create({level: 1})
      const action = {
        type: pieceActions.FETCH_BY_ID_SUCCESS,
        payload: piece
      }
      const state = piecesReducer(pieceInitialState, action)
      expect(state).to.deep.equal({
        isFetching: false,
        error: null,
        pieceIdsByLevel: {},
        entities: {
          pieces: {
            [piece._id]: piece
          }
        }
      })
    })

    it('FETCH_BY_ID_FAILURE', () => {
      const piece = pieceFactory.create({level: 1})
      const action = {
        type: pieceActions.FETCH_BY_ID_FAILURE,
        error: true,
        payload: new Error('internal server error')
      }
      const state = piecesReducer(pieceInitialState, action)
      expect(state).to.deep.equal({
        isFetching: false,
        error: 'internal server error',
        pieceIdsByLevel: {},
        entities: {
          pieces: {}
        }
      })
    })
  })
})
