var currentIndex = 0
const INITIAL_STATE = []

export default function todos(state=INITIAL_STATE, action) {
  switch (action.type) {
    case 'ADD_TODO':
      return [
        {
          id: currentIndex++,
          text: action.text,
          isComplete: false
        },
        ...state
      ]
    case 'TOGGLE_TODO':
      return state.map((todo) => {
        if (todo.id === action.id) {
          var isComplete = todo.isComplete ? false : true
          return Object.assign({}, todo, {isComplete})
        } else {
          return todo
        }
      })
    default:
      return state
  }
}
