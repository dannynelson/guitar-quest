import _ from 'lodash'

const INITIAL_STATE = {
  isFetching: false,
  hasFetchFailed: null,
  piecesById: {}
}
export default function piecesReducer(state=INITIAL_STATE, action) {
  switch (action.type) {
    case 'REQUEST_PIECES':
      return Object.assign({}, state, {
        isFetching: true,
        hasFetchFailed: false,
      })
    case 'RECEIVE_PIECES':
      debugger
      return Object.assign({}, state, {
        isFetching: false,
        hasFetchFailed: false,
        piecesById: _.indexBy(action.payload, '_id')
      })
    default:
      return state
  }
}
