import { createStore, applyMiddleware, compose } from 'redux'
import rootReducer from '../reducers/index.js'
import thunk from 'redux-thunk'
import DevTools from '../DevTools';

export default function configureStore(initialState) {
  const finalCreateStore = compose(
    // Middleware you want to use in development:
    applyMiddleware(thunk),
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
