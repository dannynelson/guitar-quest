import { combineReducers } from 'redux'
import { routeReducer } from 'redux-simple-router'
import {reducer as formReducer} from 'redux-form'
import pieceReducer from './piece'
import userReducer from './user'

const rootReducer = combineReducers({
  routing: routeReducer,
  form: formReducer,
  piece: pieceReducer,
  user: userReducer
})

export default rootReducer
