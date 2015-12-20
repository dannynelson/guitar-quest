import { combineReducers } from 'redux'
import { routeReducer } from 'redux-simple-router'
import piecesReducer from './pieces'

const rootReducer = combineReducers({
  routing: routeReducer,
  data: combineReducers({
    pieces: piecesReducer
  })
})
// reducers are pure function that take a state and an action, and return the new,
// modified state
export default rootReducer
