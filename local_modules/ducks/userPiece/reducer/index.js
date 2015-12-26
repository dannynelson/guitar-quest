const INITIAL_STATE = {
  isFetching: false,
  error: null,
  byId: {},
  piecesById: {}
}

export default function piecesReducer(state=INITIAL_STATE, action) {
  switch (action.type) {
    case REQUEST_PIECES:
    case REQUEST_PIECES:
      return Object.assign({}, state, {
        isFetching: true,
        error: null
      })
    case RECEIVE_PIECES:
      return Object.assign({}, state, {
        isFetching: false,
        error: null,
        piecesById: _.indexBy(action.payload.pieces, '_id')
      })
    case REQUEST_PIECES_FAILURE:
      return Object.assign({}, state, {
        isFetching: false,
        error: action.payload,
      })
    default:
      return state
  }
}
