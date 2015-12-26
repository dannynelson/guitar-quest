import { combineReducers } from 'redux'
import { routeReducer } from 'redux-simple-router'
import pieceReducer from './piece'

const rootReducer = combineReducers({
  routing: routeReducer,
  piece: pieceReducer
})

export default rootReducer
