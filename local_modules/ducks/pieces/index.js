import _ from 'lodash'
import { CALL_API } from 'redux-api-middleware'

const QUERY_LEVEL_REQUEST = 'pieces/QUERY_LEVEL_REQUEST'
const QUERY_LEVEL_SUCCESS = 'pieces/QUERY_LEVEL_SUCCESS'
const QUERY_LEVEL_FAILURE = 'pieces/QUERY_LEVEL_FAILURE'

export function loadLevelPieces(level) {
  return {
    [CALL_API]: {
      endpoint: `http://127.0.0.1:8075/pieces?level=${level}`,
      method: 'GET',
      transform: (response) => {
        return {pieces: response}
      },
      types: [
        QUERY_LEVEL_REQUEST,
        QUERY_LEVEL_SUCCESS,
        QUERY_LEVEL_FAILURE
      ]
    }
  }
}

const INITIAL_STATE = {
  isFetching: false,
  error: null,
  piecesById: {}
}
export default function piecesReducer(state=INITIAL_STATE, action) {
  switch (action.type) {
    case QUERY_LEVEL_REQUEST:
      return Object.assign({}, state, {
        isFetching: true,
        error: null
      })
    case QUERY_LEVEL_SUCCESS:
      return Object.assign({}, state, {
        isFetching: false,
        error: null,
        piecesById: _.indexBy(action.payload.pieces, '_id')
      })
    case QUERY_LEVEL_FAILURE:
      return Object.assign({}, state, {
        isFetching: false,
        error: action.payload,
      })
    default:
      return state
  }
}
