import superagent from 'superagent-bluebird-promise'

function requestPieces() {
  return {type: 'REQUEST_PIECES'}
}

function receivePieces(pieces) {
  debugger
  return {type: 'RECEIVE_PIECES', payload: pieces}
}

// Action creators are pure functions so that they are easy to unit test
export function loadLevelPieces(level) {
  return dispatch => {
    dispatch(requestPieces())
    return superagent.get(`/pieces`).query({level: 0})
    .then(res => {
      debugger
      dispatch(receivePieces(res.body))
    }).then(null, err => {
    })
  }
}


