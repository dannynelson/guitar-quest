import { createStore, applyMiddleware, compose } from 'redux'
import thunk from 'redux-thunk'
import { apiMiddleware } from 'redux-api-middleware';
import DevTools from 'local_modules/components/DevTools';
import { combineReducers } from 'redux'
import { routeReducer } from 'redux-simple-router'
import piecesReducer from 'local_modules/ducks/pieces'

const rootReducer = combineReducers({
  routing: routeReducer,
  data: combineReducers({
    pieces: piecesReducer
  })
})

export default function configureStore(initialState) {
  const finalCreateStore = compose(
    // Middleware you want to use in development:
    applyMiddleware(apiMiddleware, thunk),
    // Required! Enable Redux DevTools with the monitors you chose
    DevTools.instrument()
  )(createStore);
  var store = finalCreateStore(rootReducer, initialState)

  if (module.hot) {
    // Enable Webpack hot module replacement for reducers
    module.hot.accept('../reducers', () => {
      const nextReducer = require('../reducers')
      store.replaceReducer(nextReducer)
    })
  }

  return store
}
