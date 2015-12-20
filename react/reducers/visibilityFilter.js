var currentIndex = 0
const INITIAL_STATE = 'SHOW_ALL'

export default function todos(state=INITIAL_STATE, action) {
  switch (action.type) {
    case 'SET_VISIBILITY_FILTER':
      return action.filter
    default:
      return state
  }
}
