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
import settings from 'local_modules/settings'
const SERVER_URL = settings.server.url
const PIECE_INITIAL_STATE = pieceActions.INITIAL_STATE
const INITIAL_STATE = {piece: PIECE_INITIAL_STATE}

const mockStore = configureMockStore([thunk])

describe('redux pieces', function() {
  describe('actions', function() {
    afterEach(function() {
      nock.cleanAll()
    })

    describe('.fetchForLevel()', function() {
      it('handles successful request', function() {
        const PIECE = pieceFactory.create()
        nock(SERVER_URL)
          .get('/pieces')
          .query({level: 1})
          .reply(200, [PIECE])

        const meta = {
          url: `${SERVER_URL}/pieces?level=1`,
          config: {}
        }

        const EXPECTED_ACTIONS = [
          {
            type: pieceActions.FETCH_FOR_LEVEL_REQUEST,
            meta: meta
          },
          {
            type: pieceActions.FETCH_FOR_LEVEL_SUCCESS,
            payload: [PIECE],
            meta: meta
          }
        ]
        const store = mockStore(INITIAL_STATE, EXPECTED_ACTIONS)
        return store.dispatch(pieceActions.fetchForLevel(1)).then(pieces => {
          expect(pieces).to.deep.equal([PIECE])
        })
      })

      it('returns cached pieces if already saved', function() {
        const PIECE = pieceFactory.create()
        const meta = {
          url: `${SERVER_URL}/pieces?level=1`,
          config: {}
        }

        const EXPECTED_ACTIONS = []
        const CUSTOM_INITIAL_STATE = Object.assign({}, INITIAL_STATE, {
          piece: {
            pieceIdsByLevel: {
              [1]: [PIECE._id]
            },
            entities: {
              pieces: {
                [PIECE._id]: PIECE
              }
            }
          }
        })
        const store = mockStore(CUSTOM_INITIAL_STATE, EXPECTED_ACTIONS)
        return store.dispatch(pieceActions.fetchForLevel(1)).then(pieces => {
          expect(pieces).to.have.length(1)
        })
      })
    })

    describe('.fetchById()', function() {
      it('handles successful request', function() {
        const PIECE_ID = objectIdString()
        const PIECE = pieceFactory.create({_id: PIECE_ID})
        nock(SERVER_URL)
          .get(`/pieces/${PIECE_ID}`)
          .reply(200, PIECE)

        const meta = {
          url: `${SERVER_URL}/pieces/${PIECE_ID}`,
          config: {}
        }

        const EXPECTED_ACTIONS = [
          {
            type: pieceActions.FETCH_BY_ID_REQUEST,
            meta: meta
          },
          {
            type: pieceActions.FETCH_BY_ID_SUCCESS,
            payload: PIECE,
            meta: meta
          }
        ]
        const store = mockStore(INITIAL_STATE, EXPECTED_ACTIONS)
        return store.dispatch(pieceActions.fetchById(PIECE_ID)).then(piece => {
          expect(piece).to.deep.equal(PIECE)
        })
      })

      it('returns cached piece if already fetched', function() {
        const PIECE_ID = objectIdString()
        const PIECE = pieceFactory.create({_id: PIECE_ID})

        const meta = {
          url: `${SERVER_URL}/pieces/${PIECE_ID}`,
          config: {}
        }

        const EXPECTED_ACTIONS = []
        const CUSTOM_INITIAL_STATE = Object.assign({}, INITIAL_STATE, {
          piece: {
            entities: {
              pieces: {
                [PIECE._id]: PIECE
              }
            }
          }
        })
        const store = mockStore(CUSTOM_INITIAL_STATE, EXPECTED_ACTIONS)
        return store.dispatch(pieceActions.fetchById(PIECE_ID)).then(piece => {
          expect(piece).to.deep.equal(PIECE)
        })
      })
    })
  })

  describe('reducer', () => {
    it('FETCH_FOR_LEVEL_REQUEST', () => {
      const ACTION = {
        type: pieceActions.FETCH_FOR_LEVEL_REQUEST
      }
      const state = piecesReducer(PIECE_INITIAL_STATE, ACTION)
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
      const PIECE = pieceFactory.create({level: 1})
      const ACTION = {
        type: pieceActions.FETCH_FOR_LEVEL_SUCCESS,
        payload: [PIECE]
      }
      const state = piecesReducer(PIECE_INITIAL_STATE, ACTION)
      expect(state).to.deep.equal({
        isFetching: false,
        error: null,
        pieceIdsByLevel: {
          [1]: [PIECE._id]
        },
        entities: {
          pieces: {
            [PIECE._id]: PIECE
          }
        }
      })
    })

    it('FETCH_FOR_LEVEL_FAILURE', () => {
      const PIECE = pieceFactory.create({level: 1})
      const ACTION = {
        type: pieceActions.FETCH_FOR_LEVEL_FAILURE,
        error: true,
        payload: new Error('internal server error')
      }
      const state = piecesReducer(PIECE_INITIAL_STATE, ACTION)
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
      const ACTION = {
        type: pieceActions.FETCH_BY_ID_REQUEST
      }
      const state = piecesReducer(PIECE_INITIAL_STATE, ACTION)
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
      const PIECE = pieceFactory.create({level: 1})
      const ACTION = {
        type: pieceActions.FETCH_BY_ID_SUCCESS,
        payload: PIECE
      }
      const state = piecesReducer(PIECE_INITIAL_STATE, ACTION)
      expect(state).to.deep.equal({
        isFetching: false,
        error: null,
        pieceIdsByLevel: {},
        entities: {
          pieces: {
            [PIECE._id]: PIECE
          }
        }
      })
    })

    it('FETCH_BY_ID_FAILURE', () => {
      const PIECE = pieceFactory.create({level: 1})
      const ACTION = {
        type: pieceActions.FETCH_BY_ID_FAILURE,
        error: true,
        payload: new Error('internal server error')
      }
      const state = piecesReducer(PIECE_INITIAL_STATE, ACTION)
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
