import _ from 'lodash'
import { createAction, handleAction, handleActions } from 'redux-actions'
import { normalize, Schema, arrayOf } from 'normalizr';
import reduxFetch from 'local_modules/redux_fetch'

var pieceSchema = new Schema('pieces', {idAttribute: '_id'})

const MODULE_NAME = 'piece'

const INITIAL_STATE = {
  isFetching: false,
  pieceIdsByLevel: {},
  error: null,
  entities: {
    pieces: {}
  }
}

const FETCH_FOR_LEVEL_REQUEST = `${MODULE_NAME}/FETCH_FOR_LEVEL_REQUEST`
const FETCH_FOR_LEVEL_SUCCESS = `${MODULE_NAME}/FETCH_FOR_LEVEL_SUCCESS`
const FETCH_FOR_LEVEL_FAILURE = `${MODULE_NAME}/FETCH_FOR_LEVEL_FAILURE`
export function fetchForLevel(level) {
  return reduxFetch({
    method: 'GET',
    url: `/pieces`,
    qs: {level},
    types: [FETCH_FOR_LEVEL_REQUEST, FETCH_FOR_LEVEL_SUCCESS, FETCH_FOR_LEVEL_FAILURE]
  })
}

const FETCH_BY_ID_REQUEST = `${MODULE_NAME}/FETCH_BY_ID_REQUEST`
const FETCH_BY_ID_SUCCESS = `${MODULE_NAME}/FETCH_BY_ID_SUCCESS`
const FETCH_BY_ID_FAILURE = `${MODULE_NAME}/FETCH_BY_ID_FAILURE`
export function fetchById(pieceId) {
  return reduxFetch({
    method: 'GET',
    url: `/pieces/${pieceId}`,
    types: [FETCH_BY_ID_REQUEST, FETCH_BY_ID_SUCCESS, FETCH_BY_ID_FAILURE]
  })
}

export default function piecesReducer(state=INITIAL_STATE, action) {
  state = Object.assign({}, state, {
    isFetching: false,
    error: null
  })
  switch (action.type) {
    case FETCH_FOR_LEVEL_REQUEST:
    case FETCH_BY_ID_REQUEST:
      return Object.assign({}, state, {
        isFetching: true,
      })
    case FETCH_FOR_LEVEL_SUCCESS:
      const fetchedPieces = action.payload
      const fetchedLevel = fetchedPieces[0].level
      var normalizedPieces = normalize(fetchedPieces, arrayOf(pieceSchema))
      return Object.assign({}, state, {
        pieceIdsByLevel: {
          [fetchedLevel]: normalizedPieces.result
        },
        entities: normalizedPieces.entities
      })
    case FETCH_BY_ID_SUCCESS:
      const fetchedPiece = action.payload
      var normalizedPieces = normalize(fetchedPiece, pieceSchema)
      return Object.assign({}, state, {
        entities: normalizedPieces.entities
      })
    case FETCH_FOR_LEVEL_FAILURE:
    case FETCH_BY_ID_FAILURE:
      return Object.assign({}, state, {
        error: action.payload,
      })
    default:
      return state
  }
}
