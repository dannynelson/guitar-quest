import { combineReducers } from 'redux'
import todos from './todos'
import visibilityFilter from './visibilityFilter'
import { routeReducer } from 'redux-simple-router'

const rootReducer = combineReducers({
  routing: routeReducer,
  todos,
  visibilityFilter
})
// reducers are pure function that take a state and an action, and return the new,
// modified state
export default rootReducer
