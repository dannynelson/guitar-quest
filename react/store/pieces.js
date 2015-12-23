import _ from 'lodash'
import {PIECES_REQUEST, PIECES_SUCCESS, PIECES_FAILURE} from 'local_modules/actions/pieces'

const INITIAL_STATE = {
  isFetching: false,
  error: null,
  piecesById: {}
}

export default function piecesReducer(state=INITIAL_STATE, action) {
  switch (action.type) {
    case PIECES_REQUEST:
      return Object.assign({}, state, {
        isFetching: true,
        error: null
      })
    case PIECES_SUCCESS:
      return Object.assign({}, state, {
        isFetching: false,
        error: null,
        piecesById: _.indexBy(action.payload, '_id')
      })
    case PIECES_FAILURE:
      return Object.assign({}, state, {
        isFetching: false,
        error: action.payload,
      })
    default:
      return state
  }
}
