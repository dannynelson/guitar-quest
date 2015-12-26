
const INITIAL_STATE = {
  pieces: {},
  userPieces: {},
  challenges: {}
}

export default function entities(state = INITIAL_STATE, action) {
  if (action.payload && action.payload.entities) {
    return Object.assign({}, state, action.payload.entities)
  }
  return state
}
